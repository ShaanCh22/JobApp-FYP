import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/profile/update_job_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../Post/post_job_screen.dart';
import '../Widgets/shimmer_jobcard.dart';



class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  refreshData(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1D1D2F),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('My Jobs',style: GoogleFonts.dmSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500
        ),),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              onPressed: (){
                Navigator.push(context,
                    PageTransition(child: const PostJobScreen(),
                        type:PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 300)));
              },
              icon: const Icon(Icons.add,color: Colors.white,),
              iconSize: 28,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Jobs')
            .where('uid',isEqualTo: uid)
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
                        Navigator.push(context, PageTransition(child:UpdateJobScreen(jobid: id), type: PageTransitionType.rightToLeft));
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
                                  padding: EdgeInsets.only(right: 15.w),
                                  child: const Icon(Icons.edit_outlined,color: Colors.white,),
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


