import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'confirm_forget.dart';
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final FocusNode _passFocusNode = FocusNode();
  final _forgetFormKey = GlobalKey<FormState>();
  final TextEditingController _forgetpassText = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future _forgetPassSubmitForm() async{
    final isValid = _forgetFormKey.currentState!.validate();
    try{
      if(isValid){
        setState(() {
          _isLoading=true;
        });
        await _auth.sendPasswordResetEmail(
            email: _forgetpassText.text.trim()
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ConfirmForget()));}
    }catch(error){
      setState(() {
        _isLoading= false;
      });
      Fluttertoast.showToast(msg: error.toString(),toastLength: Toast.LENGTH_LONG);
    }
    setState(() {
      _isLoading=false;
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
            padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 25.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Forget Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "Always keep your account secure and\ndon't forget to update it",
                  style: GoogleFonts.dmSans(
                      color: const Color(0xffD1D1D1), fontSize: 14.sp),
                ),
                SizedBox(height: 30.h,),
                Form(
                  key: _forgetFormKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Email Account',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _forgetpassText,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Email shuold not be empty!';
                          }
                          else if(!value.contains('@')){
                            return 'Please enter a valid email address!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.mail_outline_sharp,size: 20,color: Colors.grey,),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h,),
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
                      onPressed: () => _forgetPassSubmitForm(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'Reset Now',
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
