import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import '../Services/global_methods.dart';
import 'education_screen.dart';


class AddEducationScreen extends StatefulWidget {
  const AddEducationScreen({super.key});

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  final Uuid _educationid =const Uuid();
  final TextEditingController _schoolTextController = TextEditingController(text: '');
  final TextEditingController _degreeTextController = TextEditingController(text: '');
  final TextEditingController _fieldTextController = TextEditingController(text: '');
  final TextEditingController _startDateController = TextEditingController(text: '');
  final TextEditingController _endDateController = TextEditingController(text: '');
  final TextEditingController _descriptionTextController = TextEditingController(text: '');
  bool _isLoading = false;
  final User? _user=FirebaseAuth.instance.currentUser;

  Future _submitEduData() async{
    final isValid = _addExpFormKey.currentState!.validate();
    if(isValid) {
      setState(() {
        _isLoading=true;
      });
      try{
        FirebaseFirestore.instance.collection('Users').doc(_user?.uid).collection('Education').doc(_educationid.v1()).set({
          'School':_schoolTextController.text,
          'Degree':_degreeTextController.text,
          'Field of Study':_fieldTextController.text,
          'Start Date':_startDateController.text,
          'End Date':_endDateController.text,
          'Description':_descriptionTextController.text
        });
        const SnackBar(
          content: Text('Changes saved'),
        );
        Navigator.pushReplacement(context, PageTransition(
            child: const EducationScreen(),
            type: PageTransitionType.topToBottom,
            duration: const Duration(milliseconds: 500)
        ));
      }catch(error){
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
      Fluttertoast.showToast(
          msg: 'Submitted', toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Add Education',style: GoogleFonts.dmSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500
        ),),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 25.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _addExpFormKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // School
                      Text(
                        'School',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _schoolTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'School is required!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: 'Ex: Boston University',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),
                      ),
                      //Degree
                      SizedBox(height: 20.h,),
                      Text(
                        'Degree',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _degreeTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Degree is required!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: "Ex: Bachelor's",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),

                      ),
                      //Field of Study
                      SizedBox(height: 20.h,),
                      Text(
                        'Field of Study',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _fieldTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Field is required!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: 'Ex: Computer Science',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),

                      ),
                      //Start & End Date
                      SizedBox(height: 20.h,),
                      Wrap(
                        spacing: 20.w,
                        runSpacing: 20.h,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: GoogleFonts.dmSans(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(width: 175.w,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.none,
                                  style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 15.sp
                                  ),
                                  controller: _startDateController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Start date required!';
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Select date',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.all(15),
                                    filled: true,
                                    fillColor: Color(0xff282837),
                                    suffixIcon: Icon(Icons.date_range_outlined,color: Colors.grey,),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent,)
                                    ),
                                    focusedBorder:OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xff5800FF),)
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent,)
                                    ),
                                  ),
                                  onTap: ()async{
                                    DateTime? pickedDate=await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if(pickedDate!=null){
                                      setState(() {
                                        _startDateController.text=DateFormat('y').format(pickedDate);
                                      });
                                    }
                                  },
                                ),)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: GoogleFonts.dmSans(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(width: 175.w,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.none,
                                  style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 15.sp
                                  ),
                                  controller: _endDateController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'End date required!';
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Select date',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.all(15),
                                    filled: true,
                                    fillColor: Color(0xff282837),
                                    suffixIcon: Icon(Icons.date_range_outlined,color: Colors.grey,),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent,)
                                    ),
                                    focusedBorder:OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xff5800FF),)
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent,)
                                    ),
                                  ),
                                  onTap: ()async{
                                    DateTime? pickedDate=await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if(pickedDate!=null){
                                      setState(() {
                                        _endDateController.text=DateFormat('y').format(pickedDate);
                                      });
                                    }
                                  },
                                ),)
                            ],
                          ),
                        ],
                      ),
                      //Description
                      SizedBox(height: 20.h,),
                      Text(
                        'Description',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        maxLength: 150,
                        maxLines: 8,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _descriptionTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter description!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: 'description',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
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
                      onPressed: (){
                        _submitEduData();
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
          ),
        ),
      ),
    );
  }
}

