import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/Home/view_profile_screen.dart';
import '../Widgets/shimmer_job_card_h.dart';
import '../Widgets/shimmer_jobcard.dart';
import '../job/job_detail_page.dart';
import '../job/new_hiring.dart';
import '../job/recommended_jobs.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userImage = '';
  String userName = '';
  @override
  initState() {
    super.initState();
    getUserData();
  }
  getUserData()async{
    final DocumentSnapshot userDoc=await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      userImage=userDoc.get('User Image');
      userName=userDoc.get('Name');
    });
  }
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
              backgroundColor: const Color(0xff1D1D2F),
              elevation: 0,
              leadingWidth: 80,
              titleSpacing: 0,
              leading: Padding(
                  padding: EdgeInsets.only(top: 8.h,bottom: 5.h),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewProfileScreen()));
                    },
                    child: CircleAvatar(
                      radius: 22.r,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.r),
                          child:userImage=='' ?
                          const Icon(Icons.person,size:25,color:Colors.grey,) :
                          Image.network(userImage)),
                    ),
                  )),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewHiring()));
                          },
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Jobs').orderBy('PostedAt',descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return SizedBox(
                        height: 240.h,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const ShimmerJobCardH();
                            },
                            scrollDirection: Axis.horizontal,
                            // itemCount: snapshot.data.docs.length,
                            itemCount: 2
                        ),
                      );
                    }
                    else if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.data?.docs.isNotEmpty ==true){
                        return SizedBox(
                          height: 240.h,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: SizedBox(
                                    width: 202.w,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        String id=snapshot.data!.docs[index]['id'];
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetailScreen(
                                          id: id,
                                          ownerEmail: snapshot.data.docs[index]['OwnerEmail'],
                                          jobDescription: snapshot.data.docs[index]['JobDescription'],
                                          jobExperience: snapshot.data.docs[index]['JobExperience'],
                                          jobType: snapshot.data.docs[index]['JobType'],
                                          jobLocation: snapshot.data.docs[index]['JobLocation'],
                                          userImage: snapshot.data.docs[index]['UserImage'],
                                          userName: snapshot.data.docs[index]['UserName'],
                                          jobTitle: snapshot.data.docs[index]['JobTitle'],
                                          postDate: snapshot.data.docs[index]['PostedAt'],
                                          jobSalary: snapshot.data.docs[index]['JobSalary'],
                                        )));
                                      },
                                      style: ButtonStyle(
                                        overlayColor: const MaterialStatePropertyAll(Color(
                                            0xff1a288a)),
                                        splashFactory:InkRipple.splashFactory,
                                        elevation: const MaterialStatePropertyAll(0),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                                        backgroundColor: const MaterialStatePropertyAll(Color(0xff5800FF)),
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                      ),
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
                                                    child: CircleAvatar(
                                                        radius: 22.r,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(22.r),
                                                            child:snapshot.data.docs[index]['UserImage']=='' ?
                                                            const Icon(Icons.person,size:25,color:Colors.grey,) :
                                                            Image.network(snapshot.data.docs[index]['UserImage']))),
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
                                                EdgeInsets.symmetric(horizontal: 5.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapshot.data.docs[index]['UserName']}',
                                                      style: GoogleFonts.dmSans(
                                                        color: const Color(0xffF6F8FE),
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8.h,
                                                    ),
                                                    Text(
                                                      '${snapshot.data.docs[index]['JobTitle']}',
                                                      style: GoogleFonts.dmSans(
                                                          color: Colors.white,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "\$ ${snapshot.data.docs[index]['JobSalary']}",
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
                                                          '${snapshot.data.docs[index]['JobType']}',
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
                                                      '${snapshot.data.docs[index]['PostedAt']}',
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
                              // itemCount: snapshot.data.docs.length,
                              itemCount: snapshot.data.docs.length
                          ),
                        );
                      }
                      else{
                        return Center(
                          child: Text('There is no Job!',style: GoogleFonts.dmSans(
                              color: Colors.white,fontSize: 16.sp
                          ),),
                        );
                      }
                    }
                    return Center(
                      child: Text('Something went wrong',style: GoogleFonts.dmSans(
                          color: Colors.white,fontSize: 16.sp
                      ),),
                    );
                  },
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const RecommendedJobScreen()));
                          },
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Jobs').snapshots(),
                  builder: (context, AsyncSnapshot snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return SizedBox(
                        height: 240.h,
                        child: ListView.separated(
                          itemCount: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => const ShimmerJobCard(),
                          separatorBuilder: (context, index) => SizedBox(height: 10.h,),
                        ),
                      );
                    }
                    else if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.data?.docs.isNotEmpty ==true){
                        return SizedBox(height: 600.h,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
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
                                  onPressed: (){
                                    String id=snapshot.data!.docs[index]['id'];
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetailScreen(
                                      id: id,
                                      ownerEmail: snapshot.data.docs[index]['OwnerEmail'],
                                      jobDescription: snapshot.data.docs[index]['JobDescription'],
                                      jobExperience: snapshot.data.docs[index]['JobExperience'],
                                      jobType: snapshot.data.docs[index]['JobType'],
                                      jobLocation: snapshot.data.docs[index]['JobLocation'],
                                      userImage: snapshot.data.docs[index]['UserImage'],
                                      userName: snapshot.data.docs[index]['UserName'],
                                      jobTitle: snapshot.data.docs[index]['JobTitle'],
                                      postDate: snapshot.data.docs[index]['PostedAt'],
                                      jobSalary: snapshot.data.docs[index]['JobSalary'],
                                    )));
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.only(left: 15.w),
                                        leading: CircleAvatar(
                                            radius: 22.r,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(22.r),
                                                child:snapshot.data.docs[index]['UserImage']=="" ?
                                                const Icon(Icons.person,size:25,color:Colors.grey,) :
                                                Image.network(snapshot.data.docs[index]['UserImage']))),
                                        title: Text(
                                          '${snapshot.data.docs[index]['JobTitle']}',
                                          style: GoogleFonts.dmSans(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          '${snapshot.data.docs[index]['UserName']} - ${snapshot.data.docs[index]['PostedAt']}',
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
                                              '${snapshot.data.docs[index]['JobLocation']}',
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xffd1d1d1),
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(width: 10.w,),
                                            const Icon(Icons.currency_exchange_outlined,color: Color(0xffd1d1d1),size: 15,),
                                            Text(
                                              ' ${snapshot.data.docs[index]['JobSalary']}',
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
                        );
                      }
                      else{
                        return Center(
                          child: Text('There is no Job!',style: GoogleFonts.dmSans(
                              color: Colors.white,fontSize: 16.sp
                          ),),
                        );
                      }
                    }
                    return Center(
                      child: Text('Something went wrong',style: GoogleFonts.dmSans(
                          color: Colors.white,fontSize: 16.sp
                      ),),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

