import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Home/home_screen.dart';
import '../Post/post_job_screen.dart';
import '../favorit/favorit_page.dart';
import '../job/job_page.dart';
import '../profile/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  final screens = [const HomeScreen(), const JobPage(),const PostJobScreen(), const FavoritePage(), const ProfilePage(),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            elevation: 0,
            height: 45,
            backgroundColor: const Color(0xff1D1D2F),
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(
                GoogleFonts.dmSans(color: Colors.grey))),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: [
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_home_onprimary.svg',
                    theme: const SvgTheme(
                        currentColor: Colors.grey
                    ),                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Home',
                    style: GoogleFonts.dmSans(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
              selectedIcon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_home.svg',
                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Home',
                    style: GoogleFonts.dmSans(
                        fontSize: 12.sp, color: const Color(0xff5800FF)),
                  )
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_jobs.svg',
                    theme: const SvgTheme(
                        currentColor: Colors.grey
                    ),                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Jobs',
                    style:
                    GoogleFonts.dmSans(fontSize: 12.sp, color: Colors.grey),
                  )
                ],
              ),
              selectedIcon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_jobs_primary.svg',
                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Jobs',
                    style: GoogleFonts.dmSans(
                        fontSize: 12.sp, color: const Color(0xff5800FF)),
                  )
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  const Icon(Icons.add_box_outlined,color: Colors.grey,size: 20,),
                  Text(
                    'Post',
                    style:
                    GoogleFonts.dmSans(fontSize: 12.sp, color: Colors.grey),
                  )
                ],
              ),
              selectedIcon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  const Icon(Icons.add_box,color: Color(0xff5800FF),size: 20,),
                  Text(
                    'Post',
                    style: GoogleFonts.dmSans(
                        fontSize: 12.sp, color: const Color(0xff5800FF)),
                  )
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_favorit.svg',
                    theme: const SvgTheme(
                        currentColor: Colors.grey
                    ),                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Favorit',
                    style:
                    GoogleFonts.dmSans(fontSize: 12.sp, color: Colors.grey),
                  )
                ],
              ),
              selectedIcon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_favorit_primary.svg',
                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Favorit',
                    style: GoogleFonts.dmSans(
                        fontSize: 12.sp, color: const Color(0xff5800FF)),
                  )
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_profile.svg',
                    theme: const SvgTheme(
                        currentColor: Colors.grey
                    ),                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Profile',
                    style:
                    GoogleFonts.dmSans(fontSize: 12.sp, color: Colors.grey),
                  )
                ],
              ),
              selectedIcon: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  SvgPicture.asset(
                    'assets/svg/img_nav_profile_primary.svg',
                    width: 22,
                    height: 20,
                  ),
                  Text(
                    'Profile',
                    style: GoogleFonts.dmSans(
                        fontSize: 12.sp, color: const Color(0xff5800FF)),
                  )
                ],
              ),
              label: '',
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:my_app/Home/home_screen.dart';
// import 'package:my_app/favorit/favorit_page.dart';
// import 'package:my_app/job/job_page.dart';
// import 'package:my_app/profile/profile_page.dart';
//
// class BottomNavBar extends StatelessWidget {
//   int currentIndex=0;
//
//   BottomNavBar({required this.currentIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBarTheme(
//       data: NavigationBarThemeData(
//           labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//           elevation: 0,
//           height: 50,
//           backgroundColor: Color(0xff1D1D2F),
//           indicatorColor: Colors.transparent,
//           labelTextStyle: MaterialStateProperty.all(
//               GoogleFonts.dmSans(
//                   color: Colors.grey
//               )
//           )
//       ),
//       child: NavigationBar(
//         selectedIndex: currentIndex,
//         onDestinationSelected: (index){
//           if(index==0){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
//           }
//           else if(index==1){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>JobPage()));
//           }
//           else if(index==2){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>FavoritePage()));
//           }
//           else if(index==3){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
//           }
//         },
//         destinations: [
//           NavigationDestination(
//             icon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_home_onprimary.svg',color: Colors.grey,),
//                 Text('Home',style: GoogleFonts.dmSans(
//                   color: Colors.grey,
//                   fontSize: 12.sp,
//                 ),)
//               ],
//             ),
//             selectedIcon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_home.svg',),
//                 Text('Home',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color: Color(0xff5800FF)
//                 ),)
//               ],
//             ),
//             label: '',
//           ),
//           NavigationDestination(
//             icon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_jobs.svg',color: Colors.grey,),
//                 Text('Jobs',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color: Colors.grey
//                 ),)
//               ],
//             ),
//             selectedIcon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_jobs_primary.svg',),
//                 Text('Jobs',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color:Color(0xff5800FF)
//                 ),)
//               ],
//             ),
//             label: '',
//           ),
//           NavigationDestination(
//             icon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_favorit.svg',color: Colors.grey,),
//                 Text('Favorit',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color: Colors.grey
//                 ),)
//               ],
//             ),
//             selectedIcon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_favorit_primary.svg',),
//                 Text('Favorit',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color: Color(0xff5800FF)
//                 ),)
//               ],
//             ),
//             label: '',
//           ),
//           NavigationDestination(
//             icon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_profile.svg',color: Colors.grey,),
//                 Text('Profile',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color: Colors.grey
//                 ),)
//               ],
//             ),
//             selectedIcon: Column(
//               children: [
//                 SizedBox(height: 8.h,),
//                 SvgPicture.asset('assets/svg/img_nav_profile_primary.svg',),
//                 Text('Profile',style: GoogleFonts.dmSans(
//                     fontSize: 12.sp,
//                     color: Color(0xff5800FF)
//                 ),)
//               ],
//             ),
//             label: '',
//           )
//         ],
//       ),);
//   }
// }
