import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchTextControler =
  TextEditingController(text: '');
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              toolbarHeight: 50,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              titleSpacing: 0,
              leading: Padding(
                padding: EdgeInsets.only(top: 8.h,bottom: 5.h),
                child: GestureDetector(
                  onTap: (){
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user!.email.toString(),
                    style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Find your job here',
                    style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_sharp,
                        color: Colors.white,
                        size: 22,
                      )),
                )
              ],
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Search TextField and Filter
                SizedBox(
                  height: 25.h,
                ),
                ListTile(
                  // minLeadingWidth: 0,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  title: TextFormField(
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    controller: _searchTextControler,
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
                      hintText: 'Search Job',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff282837),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                    ),
                  ),
                  trailing: SizedBox(
                    height: 52.h,
                    width: 52.h,
                    child: IconButton(
                        style: ButtonStyle(
                          splashFactory: InkRipple.splashFactory,
                          overlayColor: const MaterialStatePropertyAll(Color(0xff9333FF)),
                          backgroundColor:
                          const MaterialStatePropertyAll(Color(0xff5800FF)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        )),
                  ),
                ),
                //New Hiring Buttons
                SizedBox(
                  height: 35.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Hiring',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: GoogleFonts.dmSans(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ))
                    ],
                  ),
                ),
                // Horizontal jobs section
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                  height: 240.h,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SizedBox(
                          width: 202.w,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              overlayColor: const MaterialStatePropertyAll(Color(
                                  0xff1a288a)),
                              splashFactory:InkRipple.splashFactory,
                              elevation: const MaterialStatePropertyAll(0),
                              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: const MaterialStatePropertyAll(Color(0xff5800FF)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            ),
                            onPressed: (){},
                            child: SizedBox(
                              width: 202.w,
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.w, top: 10.h),
                                          child: const CircleAvatar(
                                              backgroundColor: Colors.white),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.bookmark_border_sharp),
                                          style: const ButtonStyle(
                                            splashFactory: InkSplash.splashFactory,
                                            overlayColor: MaterialStatePropertyAll(
                                                Color(0xff292c47)),
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.zero),
                                            iconColor: MaterialStatePropertyAll(
                                                Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Spotofy USA Inc',
                                            style: GoogleFonts.dmSans(
                                              color: const Color(0xffF6F8FE),
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            'Sr. UX Designer',
                                            style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '\$1100 - \$12.000/Month',
                                            style: GoogleFonts.dmSans(
                                              color: const Color(0xffF6F8FE),
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Container(
                                            width: 70.w,
                                            height: 28.h,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff9333FF),
                                                borderRadius:
                                                BorderRadius.circular(8.r)),
                                            child: Center(
                                              child: Text(
                                                'Full Time',
                                                style: GoogleFonts.dmSans(
                                                    color: Colors.white,
                                                    fontSize: 12.sp),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '2 Day ago',
                                            style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            width: 80.w,
                                            height: 30.h,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    splashFactory: InkRipple.splashFactory,
                                                    padding: EdgeInsets.zero,
                                                    backgroundColor: Colors.white,
                                                    foregroundColor:
                                                    const Color(0xff292c47),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12.r))),
                                                onPressed: () {},
                                                child: Text(
                                                  'Apply',
                                                  style: GoogleFonts.dmSans(
                                                      color: const Color(0xff5800FF),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700),
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                  ),
                ),
                // Recommended section
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: GoogleFonts.dmSans(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ))
                    ],
                  ),
                ),
                // Recommended jobs
                SizedBox(height: 600.h,
                  child: ListView.separated(
                    itemCount: 5,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      return SizedBox(
                        width: double.infinity,
                        height: 107.h,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              splashFactory: InkRipple.splashFactory,
                              // splashColor: Color(0xff5800FF),
                              overlayColor: MaterialStatePropertyAll(Color(
                                  0x4d5800ff)),
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.zero),
                              backgroundColor: MaterialStatePropertyAll(
                                  Color(0xff282837)),
                              shape: MaterialStatePropertyAll(
                                  ContinuousRectangleBorder())
                          ),
                          onPressed: (){},
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.only(left: 15.w),
                                leading: const CircleAvatar(backgroundColor: Colors.white),
                                title: Text(
                                  'UX Writing',
                                  style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  'Zian Design! - 1 Hours Ago',
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xffF6F8FE),
                                    fontSize: 12.sp,
                                  ),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(bottom: 15.h,),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.bookmark_border_sharp),
                                    style: const ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(
                                          Color(0xff292c47)),
                                      padding:
                                      MaterialStatePropertyAll(EdgeInsets.zero),
                                      iconColor:
                                      MaterialStatePropertyAll(Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,color: Color(0xffd1d1d1),size: 18,),
                                    Text(
                                      'Solo, Indonesia',
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xffd1d1d1),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 10.w,),
                                    const Icon(Icons.currency_exchange_outlined,color: Color(0xffd1d1d1),size: 15,),
                                    Text(
                                      ' IDR 8.500.000',
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xffd1d1d1),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15.h,),
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

