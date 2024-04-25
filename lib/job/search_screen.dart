import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Widgets/shimmer_jobcard.dart';
import 'job_detail_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController=TextEditingController();
  String searchQuery = 'Search query';
  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      _updateSearchQuery('');
    });
  }
  void _updateSearchQuery(String newQuery){
    setState(() {
      searchQuery=newQuery;
    });
  }

  Widget _buildSearchField(){
    return TextFormField(
      autocorrect: true,
      controller: _searchQueryController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: (){
            _clearSearchQuery();
          },
          icon: const Icon(Icons.close,color: Colors.grey,),
        ),
        hintText: 'Search for jobs',
        border: InputBorder.none,
        hintStyle: GoogleFonts.dmSans(color: Colors.grey)
      ),
      style: GoogleFonts.dmSans(
        color: Colors.white
      ),
      onChanged: (query)=>_updateSearchQuery(query),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: _buildSearchField(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Jobs')
            .where('JobTitle',isGreaterThanOrEqualTo: searchQuery.toLowerCase().toUpperCase())
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const ShimmerJobCard();
          }
          else if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.data.docs.isNotEmpty==true){
              return ListView.separated(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: (){
                      String id=snapshot.data!.docs[index]['id'];
                      Navigator.push(context,
                          PageTransition(child:JobDetailScreen(
                            id: id,
                            ownerEmail: snapshot.data.docs[index]['OwnerEmail'],
                            jobDescription: snapshot.data.docs[index]['JobDescription'],
                            jobExperience: snapshot.data.docs[index]['JobExperience'],
                            jobType: snapshot.data.docs[index]['JobType'],
                            jobLocation: snapshot.data.docs[index]['JobLocation'],
                            userImage: snapshot.data.docs[index]['UserImage'],
                            userName: snapshot.data.docs[index]['UserName'],
                            jobTitle: snapshot.data.docs[index]['JobTitle'],
                            postDate: snapshot.data.docs[index]['PostedAt'],
                            jobSalary: snapshot.data.docs[index]['JobSalary'],
                          ),
                              type: PageTransitionType.rightToLeft));
                    },
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        // splashColor: Color(0xff5800FF),
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(
                            Color(0xff282837)),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())
                    ),
                    child:Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: 107.h,
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 15.w),
                              leading:CircleAvatar(
                                  radius: 22.r,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(22.r),
                                      child:snapshot.data.docs[index]['UserImage']=="" ?
                                      const Icon(Icons.error,size:25,color:Colors.red,) :
                                      Image.network(snapshot.data.docs[index]['UserImage']))),
                              title: Text(
                                '${snapshot.data.docs[index]['JobTitle']}',
                                style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                '${snapshot.data.docs[index]['UserName']} - ${snapshot.data.docs[index]['PostedAt']}',
                                style: GoogleFonts.dmSans(
                                  color: const Color(0xffF6F8FE),
                                  fontSize: 12.sp,
                                ),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(bottom: 15.h,),
                                child: IconButton(
                                  onPressed: (){},
                                  icon: const Icon(Icons.bookmark_border_outlined,color: Colors.white,),
                                  style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Color(0xff292c47)),
                                    padding:
                                    MaterialStatePropertyAll(
                                        EdgeInsets.zero),
                                    iconColor:
                                    MaterialStatePropertyAll(
                                        Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                    color: Color(0xffd1d1d1), size: 18,),
                                  Text(
                                    '${snapshot.data.docs[index]['JobLocation']}',
                                    style: GoogleFonts.dmSans(
                                      color: const Color(0xffd1d1d1),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  const Icon(Icons.currency_exchange_outlined,
                                    color: Color(0xffd1d1d1), size: 15,),
                                  Text(
                                    '${snapshot.data.docs[index]['JobSalary']}',
                                    style: GoogleFonts.dmSans(
                                      color: const Color(0xffd1d1d1),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h,);
                },
              );
            }
            else{
              return Center(
                child: Text('There is no jobs',style: GoogleFonts.dmSans(color: Colors.white),),
              );
            }
          }
          return Center(
            child: Text('Something went wrong!',style: GoogleFonts.dmSans(color: Colors.white),),
          );
        },
      ),
    );
  }
}
