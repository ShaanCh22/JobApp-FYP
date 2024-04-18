import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../OnBoardingScreens/OnBoardScreen.dart';
import '../Widgets/bottom_navigation_bar.dart';

class SplashServiec {
  final user = FirebaseAuth.instance.currentUser;
  void isLogin(BuildContext context) {
    if (user != null) {
      Future.delayed(const Duration(seconds: 1)).then((value) => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()))
          });
    } else {
      Future.delayed(const Duration(seconds: 1)).then((value) => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const OnBoardScreen()))
          });
    }
  }
}

//  ************** Neat Code **
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../OnBoardingScreens/OnBoardScreen.dart';
// import '../Widgets/bottom_navigation_bar.dart';
// class SplashServiec{
//   final user= FirebaseAuth.instance.currentUser;
//   void isLogin(BuildContext context){
//     if(user!=null){
//       Future.delayed(const Duration(seconds:2)).then((value) => {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavBar()))
//       });
//     }else{
//       Future.delayed(const Duration(seconds:2)).then((value) => {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OnBoardScreen()))
//       });
//     }
//
//   }
// }
