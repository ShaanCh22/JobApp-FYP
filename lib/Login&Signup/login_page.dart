// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/global_methods.dart';
import '../Widgets/bottom_navigation_bar.dart';
import 'ForgetPasswordScreen.dart';
import 'signup_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();

  final TextEditingController _emailTextControler =
  TextEditingController(text: '');
  final TextEditingController _passTextControler =
  TextEditingController(text: '');
  bool _obsecuretext = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextControler.text.trim().toLowerCase(),
            password: _passTextControler.text.trim());
        Fluttertoast.showToast(
            msg: 'Successfully Login', toastLength: Toast.LENGTH_SHORT);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()));
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailTextControler.dispose();
    _passTextControler.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text('Hey, There 👋\nfind your job here!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'Enter your email address and password\nto use the app',
                  style: GoogleFonts.dmSans(
                      color: const Color(0xffD1D1D1), fontSize: 14.sp),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextControler,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email should not be empty!';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email!';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.mail_outline_sharp,
                            size: 20,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff5800FF),
                              )),
                          enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        'Password',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _passFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextControler,
                        obscureText: !_obsecuretext,
                        //Change it dynamically
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password should not be empty!';
                          } else if (value.length < 8) {
                            return 'Password Should be at least 8 Characters';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obsecuretext = !_obsecuretext;
                              });
                            },
                            child: Icon(
                              _obsecuretext
                                  ? Icons.visibility_off_sharp
                                  : Icons.visibility_sharp,
                              color: Colors.grey,
                            ),
                          ),
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor: const Color(0xff282837),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_sharp,
                            size: 20,
                            color: Colors.grey,
                          ),
                          enabledBorder:
                          const UnderlineInputBorder(borderSide: BorderSide.none),
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
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const ForgetPasswordScreen()));
                      },
                      child: Text('Forget Password?',
                          style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500))),
                ),
                SizedBox(
                  height: 15.h,
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
                      onPressed: () => _submitFormOnLogin(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'Login',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 200.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Text(
                          "Don't have an account?",
                          style: GoogleFonts.dmSans(
                              color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()));
                          },
                          child: Text(
                            'Register Now',
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
