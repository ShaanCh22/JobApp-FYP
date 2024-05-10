// ignore_for_file: use_build_context_synchronously

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/Login&Signup/verify_email_page.dart';
import 'package:page_transition/page_transition.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _signupFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();

  final TextEditingController _nametext = TextEditingController(text: '');
  final TextEditingController _phonenumbertext = TextEditingController(text: '');
  final TextEditingController _emailText = TextEditingController(text: '');
  final TextEditingController _passText = TextEditingController(text: '');
  bool _obsecuretext =false;
  bool _isLoading = false;
  EmailOTP myauth = EmailOTP();

  Future _submitFormOnSignup() async{
    final isValid = _signupFormKey.currentState!.validate();
    if(isValid) {
      setState(() {
        _isLoading = true;
      });
      myauth.setConfig(
          appEmail: "contact@jobseek.com",
          appName: "Email OTP",
          userEmail: _emailText.text,
          otpLength: 4,
          otpType: OTPType.digitsOnly);
      if (await myauth.sendOTP() == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content: Text("OTP has been sent"),
        ));
        Navigator.push(context, PageTransition(child:OtpScreen(
          myauth: myauth,
          name: _nametext.text,
          mail: _emailText.text,
          phone: _phonenumbertext.text,
          pass: _passText.text,
        ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content: Text("Oops, OTP send failed"),
        ));
      }
    }
    setState(() {
      _isLoading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 25.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Register 👌',
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                    'Please enter few details below.',
                    style: Theme.of(context).textTheme.titleMedium
                ),
                SizedBox(height: 30.h,),
                Form(
                  key: _signupFormKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Name
                      Text(
                          'Name',
                          style: Theme.of(context).textTheme.labelSmall
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _nametext,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Name should not be empty!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Enter Your Name/ Company Name',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(Icons.person_outline_sharp,size: 20,color: Colors.grey,),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),

                      ),
                      //Email
                      SizedBox(height: 20.h,),
                      Text(
                          'Email',
                          style: Theme.of(context).textTheme.labelSmall
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailText,
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
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Enter Email',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(Icons.mail_outline_sharp,size: 20,color: Colors.grey,),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),

                      ),
                      //Phone Number
                      SizedBox(height: 20.h,),
                      Text(
                          'Phone Number',
                          style: Theme.of(context).textTheme.labelSmall
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.phone,
                        controller: _phonenumbertext,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Phone Number should not be empty';
                          }
                          else{
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Enter Phone Number',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(Icons.phone,size: 20,color: Colors.grey,),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),

                      ),
                      //Password
                      SizedBox(height: 20.h,),
                      Text(
                          'Password',
                          style: Theme.of(context).textTheme.labelSmall
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _passFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passText,
                        obscureText: !_obsecuretext,//Change it dynamically
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Password should not be empty!';
                          }
                          else if(value.length<8){
                            return 'Password should be at least 8 characters!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          suffixIcon:GestureDetector(
                            onTap: (){
                              setState(() {
                                _obsecuretext = !_obsecuretext;
                              });
                            },
                            child: Icon(
                              _obsecuretext ? Icons.visibility_off_sharp :
                              Icons.visibility_sharp,color: Colors.grey,
                            ),
                          ),
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Enter Password',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          prefixIcon: const Icon(Icons.lock_outline_sharp,size: 20,color: Colors.grey,),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: const OutlineInputBorder(
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
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r))),
                      onPressed: () => _submitFormOnSignup(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'Register',
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
