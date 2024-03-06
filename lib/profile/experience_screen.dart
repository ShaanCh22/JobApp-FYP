import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/global_methods.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});
  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final _experienceformkey = GlobalKey<FormState>();
  final TextEditingController _experiencecontroller = TextEditingController(text: '');
  final TextEditingController _companycontroller = TextEditingController(text: '');
  final TextEditingController _locationcontroller = TextEditingController(text: '');
  String? gender;
  bool _isLoading = false;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future uploadAboutData() async{
    final isValid =_experienceformkey.currentState!.validate();
    if(isValid){
      setState(() {
        _isLoading=true;
      });
      try{
        final User? user=_auth.currentUser;
        final uid=user!.uid;
        FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'Experience':_experiencecontroller.text
        });
        Future.delayed(const Duration(seconds:1)).then((value) => {
          setState(() {
            _isLoading=false;
            Fluttertoast.showToast(
                msg: 'Changes saved', toastLength: Toast.LENGTH_SHORT);
          })
        });
      }catch(error){
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(
            error: error.toString(),
            ctx: context);
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Experience',style: GoogleFonts.dmSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500
        ),),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading:Text('Summary',style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
            ),),
            trailing: Text('Maximum 150 words',style: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 15.sp
            ),),
          ),
          SizedBox(height: 24.h,),
          Form(
            key: _experienceformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  enabled: false,
                  textInputAction: TextInputAction.next,
                  // onEditingComplete: () =>
                  //     FocusScope.of(context).requestFocus(_passFocusNode),
                  keyboardType: TextInputType.emailAddress,
                  controller: _companycontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Company name should not be empty!';
                    }else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: Color(0xff282837),
                    hintText: 'company name',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff5800FF),
                        )),
                    enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Location',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  // focusNode: _passFocusNode,
                  keyboardType: TextInputType.phone,
                  controller: _locationcontroller,
                  //Change it dynamically
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Location should not be empty!';
                    }else {
                      return null;
                    }
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: Color(0xff282837),
                    hintText: 'location',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
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
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h,),
          SizedBox(
            width: double.infinity,
            height: 53.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    splashFactory: InkRipple.splashFactory,
                    backgroundColor: const Color(0xff5800FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r))),
                onPressed: (){
                  uploadAboutData();
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  'Submit',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                )),
          ),

        ],
      ),
    );
  }
}
