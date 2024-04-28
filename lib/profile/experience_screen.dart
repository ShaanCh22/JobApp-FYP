import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/profile/update_experience_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'add_experience_screen.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});
  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final ScrollController scController=ScrollController();
  String? gender;

  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text('Experience',style: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500
          ),),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: IconButton(
                onPressed: (){
                  Navigator.push(context,
                      PageTransition(child: const AddExperienceScreen(),
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
            stream: FirebaseFirestore.instance.collection('Users').doc(uid).collection('Experience').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.hasError){
                return Center(child: Text(snapshot.hasError.toString()));
              }
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  return ElevatedButton(
                    onPressed: (){
                      String id=snapshot.data!.docs[index]['id'];
                      Navigator.push(context, PageTransition(child:UpdateExperienceScreen(id=id), type: PageTransitionType.rightToLeft));
                    },
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        // splashColor: Color(0xff5800FF),
                        overlayColor: MaterialStatePropertyAll(Color(0x27878787)),
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(
                            Color(0xff282837)),
                        shape: MaterialStatePropertyAll(
                            ContinuousRectangleBorder())
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${snapshot.data!.docs[index]['Start Date']}-${snapshot.data!.docs[index]['End Date']}',
                            style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff5800FF)
                            ),),
                          SizedBox(height: 5.h,),
                          Text('${snapshot.data!.docs[index]['Title']}',
                            style: GoogleFonts.dmSans(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),),
                          Text('At ${snapshot.data!.docs[index]['Company Name']}',
                            style: GoogleFonts.dmSans(
                                height: 1,
                                fontSize: 14.sp,
                                color: Colors.grey
                            ),),
                          SizedBox(height: 8.h,),
                          Text('${snapshot.data!.docs[index]['Job Description']}',
                            style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                color: Colors.grey
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
