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
        body: ListView.separated(
          itemCount: 2,
          itemBuilder: (context, index){
            return Container(
              color: const Color(0xff282837),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Mey 2019 - Dec 2020',
                    //   style: GoogleFonts.dmSans(
                    //       fontSize: 14.sp,
                    //       fontWeight: FontWeight.w500,
                    //       color: const Color(0xff5800FF)
                    //   ),),
                    // SizedBox(height: 5.h,),
                    Text('University of Education Lahore Vehari',
                      style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),),
                    SizedBox(height: 5.h,),
                    Text('Bachelor of Information Technology,',
                      style: GoogleFonts.dmSans(
                          height: 1,
                          fontSize: 15.sp,
                          color: Colors.white
                      ),),
                    SizedBox(height: 5.h,),
                    Text('Computer Science',
                      style: GoogleFonts.dmSans(
                          height: 1,
                          fontSize: 15.sp,
                          color: Colors.white
                      ),),
                    SizedBox(height: 5.h,),
                    Text('2020-2024',
                      style: GoogleFonts.dmSans(
                          height: 1,
                          fontSize: 15.sp,
                          color: Colors.grey
                      ),),
                    SizedBox(height: 8.h,),
                    Text('Produce products with web views and apps.Complete some given real projects',
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
        )
    );
  }
}
