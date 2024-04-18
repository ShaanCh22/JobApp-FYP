import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../Widgets/job_card.dart';
import '../Widgets/shimmer_jobcard.dart';
import 'job_detail_page.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  refreshData() {
    setState(() {});
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
              centerTitle: true,
              backgroundColor: const Color(0xff1D1D2F),
              elevation: 0,
              title: Text(
                'Jobs',
                style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Jobs').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.separated(
                  itemCount: 7,
                  itemBuilder: (context, index) => const ShimmerJobCard(),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10.h,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data?.docs.isNotEmpty == true) {
                  return RefreshIndicator(
                    backgroundColor: const Color(0xff1D1D2F),
                    color: Colors.white,
                    onRefresh: () => refreshData(),
                    child: ListView.separated(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            String id = snapshot.data!.docs[index]['id'];
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: JobDetailScreen(
                                      id: id,
                                      jobDescription: snapshot.data.docs[index]
                                          ['JobDescription'],
                                      jobExperience: snapshot.data.docs[index]
                                          ['JobExperience'],
                                      jobType: snapshot.data.docs[index]
                                          ['JobType'],
                                      jobLocation: snapshot.data.docs[index]
                                          ['JobLocation'],
                                      userImage: snapshot.data.docs[index]
                                          ['UserImage'],
                                      userName: snapshot.data.docs[index]
                                          ['UserName'],
                                      jobTitle: snapshot.data.docs[index]
                                          ['JobTitle'],
                                      postDate: snapshot.data.docs[index]
                                          ['PostedAt'],
                                      jobSalary: snapshot.data.docs[index]
                                          ['JobSalary'],
                                    ),
                                    type: PageTransitionType.rightToLeft));
                          },
                          style: const ButtonStyle(
                              splashFactory: InkRipple.splashFactory,
                              // splashColor: Color(0xff5800FF),
                              overlayColor:
                                  MaterialStatePropertyAll(Color(0x4d5800ff)),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff282837)),
                              shape: MaterialStatePropertyAll(
                                  ContinuousRectangleBorder())),
                          child: JobCard(
                            iconBtn: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border_outlined),
                            ),
                            jobLocation: snapshot.data.docs[index]
                                ['JobLocation'],
                            userImage: snapshot.data.docs[index]['UserImage'],
                            userName: snapshot.data.docs[index]['UserName'],
                            jobTitle: snapshot.data.docs[index]['JobTitle'],
                            postDate: snapshot.data.docs[index]['PostedAt'],
                            jobSalary: snapshot.data.docs[index]['JobSalary'],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10.h,
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'There is no Job!',
                      style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 16.sp),
                    ),
                  );
                }
              }
              return Center(
                child: Text(
                  'Something went wrong',
                  style:
                      GoogleFonts.dmSans(color: Colors.white, fontSize: 16.sp),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Container(
// color: Color(0xff1D1D2F),
// child: ListTile(
// leading: Text('102,548 Available',style: GoogleFonts.dmSans(
// color: Colors.white,
// fontSize: 16.sp
// ),),
// trailing: IconButton(
// onPressed: (){},
// icon: Icon(Icons.filter_list_outlined,color: Colors.white,),
// ),
// ),
// ),
// SizedBox(height: 10.h,),
