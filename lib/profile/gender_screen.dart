import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/global_methods.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  String? gender;
  final User? _user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _getGenderData();
  }

  Future _getGenderData() async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      gender = ref.get('Gender');
    });
  }

  Future _submitExpData() async {
    final isValid = _addExpFormKey.currentState!.validate();
    if (isValid) {
      try {
        final uid = _user!.uid;
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .update({'Gender': gender});
        const SnackBar(
          content: Text('Changes saved'),
        );
      } catch (error) {
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (gender != null) {
          _submitExpData();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Gender',
            style: GoogleFonts.dmSans(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _addExpFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gender
                        RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Male',
                              style: GoogleFonts.dmSans(color: Colors.white),
                            ),
                            activeColor: const Color(0xff5800FF),
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            }),
                        RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Female',
                              style: GoogleFonts.dmSans(color: Colors.white),
                            ),
                            activeColor: const Color(0xff5800FF),
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            }),
                        RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Others',
                              style: GoogleFonts.dmSans(color: Colors.white),
                            ),
                            activeColor: const Color(0xff5800FF),
                            value: 'Others',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
