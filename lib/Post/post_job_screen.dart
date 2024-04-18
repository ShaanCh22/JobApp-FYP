import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Services/global_methods.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final TextEditingController _jobcategorytext =
      TextEditingController(text: '');
  final TextEditingController _jobtitletext = TextEditingController(text: '');
  final TextEditingController _jobtypetext = TextEditingController(text: '');
  final TextEditingController _joblocationtext =
      TextEditingController(text: '');
  final TextEditingController _jobdescription = TextEditingController(text: '');
  final TextEditingController _jobsalarytext = TextEditingController(text: '');
  final TextEditingController _jobexperiencetext =
      TextEditingController(text: '');
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  final _jobdataformkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? userImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      userImage = userDoc.get('User Image');
      userName = userDoc.get('Name');
    });
  }

  Future _submitJobData() async {
    final isValid = _jobdataformkey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseFirestore.instance.collection('Jobs').doc(id).set({
          'uid': uid,
          'id': id,
          'JobCategory': _jobcategorytext.text,
          'JobTitle': _jobtitletext.text,
          'JobType': _jobtypetext.text,
          'JobSalary': _jobsalarytext.text,
          'JobExperience': _jobexperiencetext.text,
          'JobLocation': _joblocationtext.text,
          'JobDescription': _jobdescription.text,
          'UserName': userName,
          'UserImage': userImage,
          "PostedAt": dt
        });
        Future.delayed(const Duration(seconds: 1)).then((value) => {
              setState(() {
                _isLoading = false;
                Fluttertoast.showToast(
                    msg: 'Job Posted', toastLength: Toast.LENGTH_SHORT);
              })
            });
        Navigator.pop(context);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1D1D2F),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Create Job Post',
            style: GoogleFonts.dmSans(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tell us who you're hiring",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Please enter few details below.',
                    style: GoogleFonts.dmSans(
                        color: const Color(0xffD1D1D1), fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Form(
                    key: _jobdataformkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Job Category
                        Text(
                          'Job Category',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobcategorytext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select job category!';
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
                            hintText: 'Select job Category',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.category_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                        //Job Title
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Job Title',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobtitletext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job title should not be empty!';
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
                            hintText: 'Enter job title',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                        //Job Type
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Job Type',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobtypetext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Type should not be empty!';
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
                            hintText: 'Enter job type',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                        //Job Experience
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Required Experience',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.number,
                          controller: _jobexperiencetext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Experience should not be empty!';
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
                            hintText: 'Experience Required',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                        //Job Salary
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Job Salary',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobsalarytext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Salary should not be empty!';
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
                            hintText: 'Enter job Salary',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                        //Job Location
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Job Location',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _joblocationtext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job location should not be empty!';
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
                            hintText: 'Enter job location',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                        //Job Description
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Job Description',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          controller: _jobdescription,
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 15.sp),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job description should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            hintText: 'Enter Job Description',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.all(15),
                            filled: true,
                            fillColor: Color(0xff282837),
                            prefixIcon: Icon(
                              Icons.description_outlined,
                              color: Colors.grey,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.redAccent,
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
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: const Color(0xff1D1D2F),
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          maxLines: 50,
                                          maxLength: 1000,
                                          textInputAction: TextInputAction.done,
                                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                                          keyboardType: TextInputType.text,
                                          controller: _jobdescription,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Job description should not be empty!';
                                            } else {
                                              return null;
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: const InputDecoration(
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.all(15),
                                            filled: true,
                                            fillColor: Color(0xff282837),
                                            hintText: 'Enter job title',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide.none),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                              color: Colors.redAccent,
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
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 53.h,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                splashFactory:
                                                    InkRipple.splashFactory,
                                                backgroundColor:
                                                    const Color(0xff5800FF),
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r))),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: _isLoading
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    'Save',
                                                    style: GoogleFonts.dmSans(
                                                        color: Colors.white,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 53.h,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff5800FF),
                            foregroundColor: Colors.black,
                            splashFactory: InkRipple.splashFactory,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r))),
                        onPressed: () {
                          _submitJobData();
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Post',
                                style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
