import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Widgets/shimmer_jobcard.dart';
import 'job_detail_page.dart';

class NewHiring extends StatefulWidget {
  const NewHiring({super.key});

  @override
  State<NewHiring> createState() => _NewHiringState();
}

class _NewHiringState extends State<NewHiring> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  refreshData(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('New Hiring',style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff1D1D2F),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Jobs').orderBy('PostedAt',descending: true)
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

