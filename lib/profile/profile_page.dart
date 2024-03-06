import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/profile/setting_page.dart';
import 'package:jobseek/profile/upload_resume_page.dart';
import 'package:page_transition/page_transition.dart';

import 'aboutme_screen.dart';
import 'edit_profile.dart';
import 'experience_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController scController=ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              toolbarHeight: 50,
              // backgroundColor: Color(0xff282837),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title:Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text('Profile',style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500
                ),),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(context, PageTransition(child:const SettingPage(),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300)));
                      },
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 22,
                      )),
                )
              ],
            ),
          ],
          body: ListView(
            children: [
              //User Info section
              Container(
                color: const Color(0xff282837),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(radius: 30.r,),
                        title: Text(
                          'Hassan Khalid',
                          style: GoogleFonts.dmSans(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),),
                        subtitle: Text(
                          user!.email.toString(),
                          style: GoogleFonts.dmSans(
                              fontSize: 16.sp,
                              color: Colors.grey
                          ),),
                      ),
                      SizedBox(height: 15.h,),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(
                          width: 160.w,
                          height: 45.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: const Color(0xff5800FF),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r))),
                              onPressed: (){
                                Navigator.push(context, PageTransition(child:const EditProfilePage(),
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300)));
                              },
                              child:Text(
                                  'Edit Profile',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 14.sp,)
                              )),
                        ),
                        trailing: SizedBox(
                          width: 160.w,
                          height: 45.h,
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xff5800FF),
                                  side: const BorderSide(
                                      color: Color(0xff5800FF),
                                      width: 1
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r))),
                              onPressed: (){
                                Navigator.push(context, PageTransition(child:const UploadResumePage(),
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300)));
                              },
                              child:Text(
                                  'Add Resume',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 14.sp,)
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
              //Resume section
              Container(
                color: const Color(0xff282837),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Resume',style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500
                        ),),
                        trailing:  IconButton(
                          onPressed: (){
                            Navigator.push(context, PageTransition(child:const UploadResumePage(),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 300)));
                          },
                          icon: SvgPicture.asset(
                            theme: const SvgTheme(
                                currentColor: Colors.white
                            ),
                            'assets/svg/img_icon_line_onprimary_24x24.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 10,
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          'assets/svg/img_frame_primary.svg',
                          theme: const SvgTheme(
                              currentColor: Colors.white
                          ),                          width: 24,
                          height: 24,
                        ),
                        title: Text('Curriculum Vitae.pdf',style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),),
                      ),
                      ListTile(
                        horizontalTitleGap: 10,
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          'assets/svg/img_frame_primary.svg',
                          theme: const SvgTheme(
                              currentColor: Colors.white
                          ),                          width: 24,
                          height: 24,
                        ),
                        title: Text('UI Design Portfolio.pdf',style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
              //About me section
              Container(
                color: const Color(0xff282837),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('About Me',style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500
                        ),),
                        trailing:  IconButton(
                          onPressed: (){
                            Navigator.push(context,
                                PageTransition(child: const AboutMeScreen(), type: PageTransitionType.rightToLeft));
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/img_icon_line_onprimary_24x24.svg',
                            theme: const SvgTheme(
                                currentColor: Colors.white
                            ),                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      Text('Hi guys! introduce my name is rehan, i am a fresh',
                        style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.grey
                        ),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
              //Experience section
              Container(
                color: const Color(0xff282837),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Experience',style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500
                        ),),
                        trailing:  IconButton(
                          onPressed: (){
                            Navigator.push(context, PageTransition(child: const ExperienceScreen(),
                                type: PageTransitionType.rightToLeft));
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/img_icon_line_onprimary_24x24.svg',
                            theme: const SvgTheme(
                                currentColor: Colors.white
                            ),                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      ListView.separated(
                        controller: scController,
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context,index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mey 2019 - Dec 2020',
                                style: GoogleFonts.dmSans(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff5800FF)
                                ),),
                              SizedBox(height: 5.h,),
                              Text('User Interface Design',
                                style: GoogleFonts.dmSans(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),),
                              Text('At Slab Design!',
                                style: GoogleFonts.dmSans(
                                    height: 1,
                                    fontSize: 14.sp,
                                    color: Colors.grey
                                ),),
                              SizedBox(height: 8.h,),
                              Text('1. Produce products with web views and apps.\n2. Complete some given real projects',
                                style: GoogleFonts.dmSans(
                                    fontSize: 16.sp,
                                    color: Colors.grey
                                ),),
                            ],
                          );
                        },
                        separatorBuilder:(context, index) => SizedBox(height: 16.h,),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
              //Education section
              Container(
                color: const Color(0xff282837),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Education',style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500
                        ),),
                        trailing:  IconButton(
                          onPressed: (){},
                          icon: SvgPicture.asset(
                            'assets/svg/img_icon_line_onprimary_24x24.svg',
                            theme: const SvgTheme(
                                currentColor: Colors.white
                            ),                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      ListView.separated(
                        controller: scController,
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context,index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mey 2019 - Dec 2020',
                                style: GoogleFonts.dmSans(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff5800FF)
                                ),),
                              SizedBox(height: 5.h,),
                              Text('University of Suzerain Jogjakarta',
                                style: GoogleFonts.dmSans(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),),
                              Text('S1 Informatics',
                                style: GoogleFonts.dmSans(
                                    height: 1,
                                    fontSize: 14.sp,
                                    color: Colors.grey
                                ),),
                            ],
                          );
                        },
                        separatorBuilder:(context, index) => SizedBox(height: 16.h,),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
              //Skill section
              Container(
                color: const Color(0xff282837),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('Skill',style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500
                        ),),
                        trailing:  IconButton(
                          onPressed: (){},
                          icon: SvgPicture.asset(
                            'assets/svg/img_icon_line_onprimary_24x24.svg',
                            theme: const SvgTheme(
                                currentColor: Colors.white
                            ),                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      Wrap(spacing: 10,
                        children: [
                          Chip(
                            label: Text('Research',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                            backgroundColor: const Color(0xff282837),
                          ),
                          Chip(
                            label: Text('UI Design',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                            backgroundColor: const Color(0xff282837),
                          ),
                          Chip(
                            label: Text('UX Design',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                            backgroundColor: const Color(0xff282837),
                          ),
                          Chip(
                            label: Text('Photoshop',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                            backgroundColor: const Color(0xff282837),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
            ],
          ),
        ),
      ),
    );
  }
}


