import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/job/search_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../Widgets/shimmer_jobcard.dart';
import 'job_detail_page.dart';


class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  refreshData(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              toolbarHeight: 50,
              centerTitle: true,
              backgroundColor: const Color(0xff1D1D2F),
              elevation: 0,
              title:Text('Jobs',style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold
              ),),
              actions: [
                IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                        backgroundColor: const Color(0xff1D1D2F),
                        context: context,
                        builder: (BuildContext context){
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Filter',style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500
                                ),),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Text('Job Category',style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500
                                  ),),
                                  trailing: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "UI/UX  Design ",
                                          style: GoogleFonts.dmSans(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: Icon(Icons.arrow_forward_ios_sharp, size: 15,color: Colors.white,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.grey,thickness: 0.3),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Text('City/Location',style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500
                                  ),),
                                  trailing: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Jakarta ",
                                          style: GoogleFonts.dmSans(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: Icon(Icons.arrow_forward_ios_sharp, size: 15,color: Colors.white,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.grey,thickness: 0.3),
                                Text('Job Types',style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500
                                ),),
                                SizedBox(height: 20.h,),
                                Wrap(
                                  children: [
                                    Chip(
                                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
                                      color: const MaterialStatePropertyAll(Color(0xff5800FF)),
                                      side: BorderSide.none,
                                      elevation: 0,
                                      label: Text(
                                        'Full Time',
                                        style: GoogleFonts.dmSans(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      backgroundColor: const Color(0xff282837),
                                    ),
                                    SizedBox(width: 20.w,),
                                    Chip(
                                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
                                      elevation: 0,
                                      color: const MaterialStatePropertyAll(Color(0xff1D1D2F)),
                                      side: BorderSide.none,
                                      label: Text(
                                        'Part Time',
                                        style: GoogleFonts.dmSans(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      backgroundColor: const Color(0xff282837),
                                    ),
                                    const Divider(color: Colors.grey,thickness: 0.3),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.filter_list,color: Colors.white,),
                ),
                IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchScreen()));
                  },
                  icon: const Icon(Icons.search,color: Colors.white,),
                )
              ],
            ),
          ],
          body:StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Jobs')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return ListView.separated(
                  itemCount: 7,
                  itemBuilder: (context, index) => const ShimmerJobCard(),
                  separatorBuilder: (context, index) => SizedBox(height: 10.h,),
                );
              }
              else if(snapshot.connectionState==ConnectionState.active){
                if(snapshot.data?.docs.isNotEmpty ==true){
                  return RefreshIndicator(
                    backgroundColor: const Color(0xff1D1D2F),
                    color: Colors.white,
                    onRefresh: () => refreshData(),
                    child: ListView.separated(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: (){
                            String id=snapshot.data!.docs[index]['id'];
                            Navigator.push(context,
                                PageTransition(child:JobDetailScreen(
                                  id: id,
                                  uid: snapshot.data.docs[index]['uid'],
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
                                    trailing:Padding(
                                      padding:  EdgeInsets.only(right: 10.w),
                                      child: const Icon(Icons.arrow_forward_ios_sharp,
                                        color: Colors.white,),
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
                    ),
                  );
                }
                else{
                  return Center(
                    child: Text('There is no Job!',style: GoogleFonts.dmSans(
                        color: Colors.white,fontSize: 16.sp
                    ),),
                  );
                }
              }
              return Center(
                child: Text('Something went wrong',style: GoogleFonts.dmSans(
                    color: Colors.white,fontSize: 16.sp
                ),),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Container(
// color: Color(0xff1D1D2F),
// child: ListTile(
// leading: Text('102,548 Available',style: GoogleFonts.dmSans(
// color: Colors.white,
// fontSize: 16.sp
// ),),
// trailing: IconButton(
// onPressed: (){},
// icon: Icon(Icons.filter_list_outlined,color: Colors.white,),
// ),
// ),
// ),
// SizedBox(height: 10.h,),

