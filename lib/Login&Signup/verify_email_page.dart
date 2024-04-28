// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Services/global_methods.dart';
import '../main_page.dart';

class Otp extends StatelessWidget {
  const Otp({super.key, required this.otpController});
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      height: 50.h,
      child: TextFormField(
        cursorColor: const Color(0xff5800FF),
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
        controller: otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20.sp),
          hintText: ('0'),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.white,
          )),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.redAccent,
          )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xff5800FF),
          )),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.redAccent,
          )),
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String name;
  final String mail;
  final String phone;
  final String pass;
  final EmailOTP myauth;
  const OtpScreen(
      {super.key,
      required this.myauth,
      required this.name,
      required this.mail,
      required this.pass,
      required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  bool _isLoading = false;
  String otpController = "1234";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future submitDetail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _auth
          .createUserWithEmailAndPassword(
              email: widget.mail, password: widget.pass)
          .then((signedInUser) => {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(signedInUser.user?.uid)
                    .set({
                  "Id": FirebaseFirestore.instance
                      .collection("Users")
                      .doc(signedInUser.user?.uid),
                  "Name": widget.name,
                  "Email": widget.mail,
                  "Phone Number": widget.phone,
                  "User Image": "",
                  "Gender": "",
                  "About Me": "",
                  "Resume Url": "",
                  "Created At": Timestamp.now()
                }).then((signedInUser) => {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: const MainPage(),
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 500)))
                        })
              });
    } catch (e) {
      setState(() {
        _isLoading = true;
      });
      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verification Code',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'We send the Verification OTP code to your whatsapp with the number +62821 - 3948 - 9384 input to complete the last stage of registering',
                  style: GoogleFonts.dmSans(
                      color: const Color(0xffD1D1D1), fontSize: 14.sp),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: Wrap(
                    runSpacing: 25.h,
                    children: [
                      Otp(
                        otpController: otp1Controller,
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Otp(
                        otpController: otp2Controller,
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Otp(
                        otpController: otp3Controller,
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Otp(
                        otpController: otp4Controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 53.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r))),
                      onPressed: () async {
                        if (await widget.myauth.verifyOTP(
                                otp: otp1Controller.text +
                                    otp2Controller.text +
                                    otp3Controller.text +
                                    otp4Controller.text) ==
                            true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP is verified"),
                          ));
                          submitDetail();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Confirm',
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
