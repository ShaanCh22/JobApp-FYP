import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Login&Signup/login_page.dart';
import 'intro_contents.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 50.h, horizontal: 25.w),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(contents[i].image),
                              radius: 150.r,
                              backgroundColor: Color(contents[i].color),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Text(
                              contents[i].title,
                              style: TextStyle(
                                  fontSize: 30.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              contents[i].description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xffF6F8FE)),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40.h, right: 30.w),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: contents.length,
                  effect: WormEffect(
                    dotWidth: 10.w,
                    dotHeight: 10.h,
                    dotColor: Colors.white,
                    activeDotColor: const Color(0xff5800FF),
                  ),
                  onDotClicked: (index) {
                    _controller.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Wrap(
        children: [
          SizedBox.fromSize(
            size: const Size.square(60),
            child: FloatingActionButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                } else {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              shape: const CircleBorder(),
              backgroundColor: const Color(0xff5800FF),
              child: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: TextButton(
                style: const ButtonStyle(
                  splashFactory: InkRipple.splashFactory,
                ),
                onPressed: () {
                  // _controller.animateToPage(3, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )),
          )
        ],
      ),
    );
  }
}
