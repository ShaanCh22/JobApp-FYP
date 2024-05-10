import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobseek/profile/profile_page.dart';
import 'package:jobseek/search_user.dart';
import 'Home/home_screen.dart';
import 'favorit/favorit_page.dart';
import 'job/job_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController? pageController;
  int getPageIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController?.dispose();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  onTapChange(int pageIndex) {
    pageController?.animateToPage(pageIndex,
        duration: const Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: getPageIndex,
        children: const [HomeScreen(), JobPage(), FavoritPage(), SearchUser(),ProfilePage()],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: (value) {
          setState(() {
            getPageIndex = value;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        activeColor: const Color(0xff5800FF),
        inactiveColor: Theme.of(context).colorScheme.secondaryContainer,
        iconSize: 22,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/img_nav_home_onprimary.svg',),
            activeIcon: SvgPicture.asset('assets/svg/img_nav_home.svg',),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/img_nav_jobs.svg',),
            activeIcon: SvgPicture.asset('assets/svg/img_nav_jobs_primary.svg',),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/img_nav_favorit.svg',),
            activeIcon: SvgPicture.asset('assets/svg/img_nav_favorit_primary.svg',),
            label: 'Favorit',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_search_outlined,size: 28,),
            activeIcon: Icon(Icons.person_search_rounded,size: 28,),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/img_nav_profile.svg',),
            activeIcon: SvgPicture.asset('assets/svg/img_nav_profile_primary.svg',),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
