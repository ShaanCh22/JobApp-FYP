import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Post/post_job_screen.dart';
import '../Widgets/job_card.dart';
import '../Widgets/shimmer_jobcard.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1D1D2F),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'My Jobs',
            style: GoogleFonts.dmSans(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const PostJobScreen(),
                          type: PageTransitionType.bottomToTop,
                          duration: const Duration(milliseconds: 300)));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                iconSize: 28,
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Jobs')
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerJobCard();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          splashFactory: InkRipple.splashFactory,
                          // splashColor: Color(0xff5800FF),
                          overlayColor:
                              MaterialStatePropertyAll(Color(0x4d5800ff)),
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff282837)),
                          shape: MaterialStatePropertyAll(
                              ContinuousRectangleBorder())),
                      child: JobCard(
                        iconBtn: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert_outlined),
                        ),
                        jobLocation: snapshot.data.docs[index]['JobLocation'],
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
                style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16.sp),
              ),
            );
          },
        ));
  }
}
