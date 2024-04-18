import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'login_page.dart';

class ConfirmForget extends StatefulWidget {
  const ConfirmForget({super.key});

  @override
  State<ConfirmForget> createState() => _ConfirmForgetState();
}

class _ConfirmForgetState extends State<ConfirmForget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Jobseek',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset('assets/images/forget_mail.png'),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  'Confirmation',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Reset mail has been sent. Please check and then log in with your new password',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.dmSans(color: Colors.white, fontSize: 15.sp),
                ),
                SizedBox(
                  height: 150.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 53.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r))),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const Login(),
                                type: PageTransitionType.topToBottom,
                                duration: const Duration(milliseconds: 300)));
                      },
                      child: Text(
                        'Go to Login',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
