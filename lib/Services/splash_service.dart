// import 'dart:async';
// import 'package:flutter/material.dart';
//
// import '../OnBoardingScreens/onboard_screen.dart';
// class SplashService{
//   void isLogin(BuildContext context){
//   //   Timer(Duration(seconds: 2),() =>
//   //     Navigator.push(context, MaterialPageRoute(builder: (context)=>OnBoardScreen())));
//   //
//     Future.delayed(const Duration(seconds:2)).then((value) => {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OnBoardScreen()))
//     });
// }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../OnBoardingScreens/OnBoardScreen.dart';
import '../Widgets/bottom_navigation_bar.dart';
class SplashService{
  final user= FirebaseAuth.instance.currentUser;
  void isLogin(BuildContext context){
    if(user!=null){
      Future.delayed(const Duration(seconds:1)).then((value) => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavBar()))
      });
    }else{
      Future.delayed(const Duration(seconds:1)).then((value) => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OnBoardScreen()))
      });
    }

  }
}
// void isLogin(BuildContext context){
//   if(user!=null){
//     Future.delayed(const Duration(seconds:2)).then((value) => {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavBar()))
//     });
//   }else{
//     Future.delayed(const Duration(seconds:2)).then((value) => {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OnBoardScreen()))
//     });
//   }
//
// }