import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/global_methods.dart';
import 'login_page.dart';

class ConfirmForget extends StatefulWidget {
  const ConfirmForget({super.key});

  @override
  State<ConfirmForget> createState() => _ConfirmForgetState();
}

class _ConfirmForgetState extends State<ConfirmForget> {
  void logOut()async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Login()), (route) => false);
    }catch(error){
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness
        ),
        centerTitle: true,
        title: Text('Jobseek',style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 25.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
                Image.asset('assets/images/forget_mail.png'),
                SizedBox(height: 30.h,),
                Text('Confirmation',style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 20.h,),
                Text('Reset mail has been sent. Please check and then log in with your new password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 150.h,),
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
                      onPressed: (){
                        logOut();
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
