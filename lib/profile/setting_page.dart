// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Login&Signup/login_page.dart';
import '../Services/global_methods.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void logOut()async{
    try{
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
          msg: 'Successfully Logout', toastLength: Toast.LENGTH_SHORT);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Login()));
    }catch(error){
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Setting',style: GoogleFonts.dmSans(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500
        ),),
      ),
      body: ListView(
        children: [
          //Dark mode
          Container(
            color: const Color(0xff282837),
            child: ListTile(
              leading: Text('Dark Mode',style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                color: Colors.white
              ),),
            )
          ),
          ListTile(
            leading: Text('General',style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                color: Colors.grey
            ),),
          ),
          //General Section
          Container(
              color: const Color(0xff282837),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                      splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                      elevation: MaterialStatePropertyAll(0),
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                      shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Application History',
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          color: Colors.white
                      ),),
                      trailing: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Language',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white
                        ),),
                      trailing: Text('English',
                        style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            color: Colors.grey
                        ),),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Change Password',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white
                        ),),
                      trailing: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Notifications',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white
                        ),),
                      trailing: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ),
                ],
              )
          ),
          ListTile(
            leading: Text('Help',style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                color: Colors.grey
            ),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
              color: const Color(0xff282837),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Give Feedback',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white
                        ),),
                      trailing: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Privacy & Policy',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white
                        ),),
                      trailing: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor: MaterialStatePropertyAll(Color(
                            0x4d5800ff)),
                        elevation: MaterialStatePropertyAll(0),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff282837)),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder())
                    ),
                    child: ListTile(
                      leading: Text('Help Center',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white
                        ),),
                      trailing:const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ),
                  ListTile(
                    leading: Text('Version',
                      style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          color: Colors.white
                      ),),
                    trailing: Text('v2.12',
                      style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          color: Colors.grey
                      ),),
                  ),
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              height: 53.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      splashFactory: InkRipple.splashFactory,
                      backgroundColor: const Color(0xff5800FF),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r))),
                  onPressed: () => logOut(),
                  child:Text(
                    'Logout',
                    style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
