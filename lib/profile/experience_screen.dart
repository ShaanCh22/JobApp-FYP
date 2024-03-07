import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Services/global_methods.dart';
import 'add_experience_screen.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});
  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final _experienceformkey = GlobalKey<FormState>();
  final ScrollController scController=ScrollController();
  final TextEditingController _experiencecontroller = TextEditingController(text: '');
  String? gender;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future uploadAboutData() async{
    final isValid =_experienceformkey.currentState!.validate();
    if(isValid){
      setState(() {
      });
      try{
        final User? user=_auth.currentUser;
        final uid=user!.uid;
        FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'Experience':_experiencecontroller.text
        });
        Future.delayed(const Duration(seconds:1)).then((value) => {
          setState(() {
            Fluttertoast.showToast(
                msg: 'Changes saved', toastLength: Toast.LENGTH_SHORT);
          })
        });
      }catch(error){
        setState(() {
        });
        GlobalMethod.showErrorDialog(
            error: error.toString(),
            ctx: context);
      }
    }


  }

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
        body: ListView.separated(
          itemCount: 2,
          itemBuilder: (context, index){
            return Container(
              color: const Color(0xff282837),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mey 2019 - Dec 2020',
                      style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff5800FF)
                      ),),
                    SizedBox(height: 5.h,),
                    Text('User Interface Design',
                      style: GoogleFonts.dmSans(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),),
                    Text('At Slab Design!',
                      style: GoogleFonts.dmSans(
                          height: 1,
                          fontSize: 14.sp,
                          color: Colors.grey
                      ),),
                    SizedBox(height: 8.h,),
                    Text('1. Produce products with web views and apps.\n2. Complete some given real projects',
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
        )
    );
  }
}
