import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Services/splash_service.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashService= SplashService();
  @override
  void initState() {
    super.initState();
    splashService.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Jobseek',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 36.sp,
            fontWeight: FontWeight.w700,
            height: 0.03.h,
            letterSpacing: -0.72,
          ),
        ),
      ),
    );
  }
}
