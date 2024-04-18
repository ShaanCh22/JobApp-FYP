import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'add_skill_screen.dart';

class SkillScreen extends StatefulWidget {
  const SkillScreen({super.key});
  @override
  State<SkillScreen> createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
  final ScrollController scController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Skills',
          style:
              GoogleFonts.dmSans(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: const AddSkillScreen(),
                      type: PageTransitionType.bottomToTop,
                    ));
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(uid)
                .collection("Skills")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              }
              return Wrap(
                spacing: 10.w,
                runSpacing: 5.h,
                children: List.generate(snapshot.data!.docs.length, (index) {
                  return Chip(
                    deleteIcon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onDeleted: () {
                      CollectionReference ref = FirebaseFirestore.instance
                          .collection("Users")
                          .doc(uid)
                          .collection("Skills");
                      ref
                          .doc(snapshot.data!.docs[index]['id'].toString())
                          .delete();
                    },
                    label: Text(
                      '${snapshot.data!.docs[index]['Title']}',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    backgroundColor: const Color(0xff282837),
                  );
                }),
              );
            }),
      ),
    );
  }
}
