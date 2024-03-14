import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'add_education_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});
  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final ScrollController scController=ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text('Education',style: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500
          ),),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: IconButton(
                onPressed: (){
                  Navigator.push(context,
                      PageTransition(child: const AddEducationScreen(),
                        type:PageTransitionType.bottomToTop,
                      ));
                },
                icon: const Icon(Icons.add,color: Colors.white,),
                iconSize: 28,
              ),
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').doc(uid).collection('Education').snapshots(),
            builder: (context, snapshot) {
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasError){
                    return Center(child: Text(snapshot.hasError.toString()));
                  }
                  return Container(
                    color: const Color(0xff282837),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${snapshot.data!.docs[index]["School"]}',
                            style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),),
                          SizedBox(height: 5.h,),
                          Text('${snapshot.data!.docs[index]["Degree"]}',
                            style: GoogleFonts.dmSans(
                                height: 1,
                                fontSize: 15.sp,
                                color: Colors.white
                            ),),
                          SizedBox(height: 5.h,),
                          Text('${snapshot.data!.docs[index]["Field of Study"]}',
                            style: GoogleFonts.dmSans(
                                height: 1,
                                fontSize: 15.sp,
                                color: Colors.white
                            ),),
                          SizedBox(height: 5.h,),
                          Text('${snapshot.data!.docs[index]["Start Date"]}-${snapshot.data!.docs[index]["End Date"]}',
                            style: GoogleFonts.dmSans(
                                height: 1,
                                fontSize: 15.sp,
                                color: Colors.grey
                            ),),
                          SizedBox(height: 8.h,),
                          Text('${snapshot.data!.docs[index]["Description"]}',
                            style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                color: Colors.white
                            ),),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20.h,);
                },
              );
            }
        )
    );
  }
}
