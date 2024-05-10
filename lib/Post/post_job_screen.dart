
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Services/global_methods.dart';
import '../presistent/presestent.dart';

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
  String? ownerEmail;


  Future _submitJobData() async {
    final isValid = _jobdataformkey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
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
          'UserName': userDoc.get('Name'),
          'UserImage': userDoc.get('User Image'),
          "PostedAt": dt,
          "OwnerEmail": userDoc.get('Email')
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
  _showJobCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: const Color(0xff1D1D2F),
              title: Text(
                'Job Category',
                style: GoogleFonts.dmSans(fontSize: 20.sp, color: Colors.white),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.jobCateegoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobcategorytext.text =
                            Presistent.jobCateegoryList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobCateegoryList[index],
                          style: GoogleFonts.dmSans(fontSize: 16.sp, color: Colors.grey),
                        )
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
        });
  }
  _showJobTypeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: const Color(0xff1D1D2F),
              title: Text(
                'Job Types',
                style: GoogleFonts.dmSans(fontSize: 20.sp, color: Colors.white),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.jobTypeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobtypetext.text =
                            Presistent.jobTypeList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobTypeList[index],
                          style: GoogleFonts.dmSans(fontSize: 16.sp, color: Colors.grey),
                        )
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.onSurface,
              statusBarIconBrightness: Theme.of(context).brightness
          ),
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
          centerTitle: true,
          title: Text(
              'Create Job Post',
              style:Theme.of(context).textTheme.labelMedium
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
                      style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                      'Please enter few details below.',
                      style: Theme.of(context).textTheme.titleMedium
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
                            style: Theme.of(context).textTheme.labelSmall
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobcategorytext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select job category!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.onTertiaryContainer,
                            hintText: 'Select job Category',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.category_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                          ),
                          onTap: () {
                            _showJobCategoryDialog();
                          },
                        ),
                        //Job Title
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                            'Job Title',
                            style: Theme.of(context).textTheme.labelSmall
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
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                            hintText: 'Enter job title',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
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
                            style: Theme.of(context).textTheme.labelSmall
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobtypetext,
                          onTap: (){
                            _showJobTypeDialog();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Type should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                            hintText: 'Enter job type',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
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
                            style: Theme.of(context).textTheme.labelSmall
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
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                            hintText: 'Experience Required',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
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
                            style: Theme.of(context).textTheme.labelSmall
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
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                            hintText: 'Enter job Salary',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
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
                            style:Theme.of(context).textTheme.labelSmall
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
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                            hintText: 'Enter job location',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
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
                            style: Theme.of(context).textTheme.labelSmall
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          controller: _jobdescription,
                          style: Theme.of(context).textTheme.titleSmall,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job description should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Enter Job Description',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                            prefixIcon: const Icon(
                              Icons.description_outlined,
                              color: Colors.grey,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5800FF),
                                )),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                )),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                showDragHandle: true,
                                isScrollControlled: true,
                                useSafeArea: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)
                                    )
                                ),
                                backgroundColor:Theme.of(context).colorScheme.background,
                                context: context,
                                builder: (BuildContext context) {
                                  return ListView(
                                    children: [
                                      TextFormField(
                                        minLines: 10,
                                        maxLines: 14,
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
                                        style: Theme.of(context).textTheme.titleSmall,
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          contentPadding: const EdgeInsets.all(15),
                                          filled: true,
                                          fillColor:Theme.of(context).colorScheme.onTertiaryContainer,
                                          hintText: 'Enter job title',
                                          hintStyle: Theme.of(context).textTheme.bodySmall,
                                          enabledBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          focusedErrorBorder:
                                          const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.redAccent,
                                              )),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff5800FF),
                                              )),
                                          errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.redAccent,
                                              )),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
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
