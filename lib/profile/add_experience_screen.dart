import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../Services/global_methods.dart';
import 'experience_screen.dart';


class AddExperienceScreen extends StatefulWidget {
  const AddExperienceScreen({super.key});

  @override
  State<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  final TextEditingController _titletext = TextEditingController(text: '');
  final TextEditingController _companytext = TextEditingController(text: '');
  final TextEditingController _locationtext = TextEditingController(text: '');
  final TextEditingController _startDateController = TextEditingController(text: '');
  final TextEditingController _endDateController = TextEditingController(text: '');
  final TextEditingController _jobdescText = TextEditingController(text: '');
  bool _isLoading = false;
  final User? _user=FirebaseAuth.instance.currentUser;

  Future _submitExpData() async{
    final isValid = _addExpFormKey.currentState!.validate();
    if(isValid) {
      setState(() {
        _isLoading=true;
      });
      try{
        String id=DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseFirestore.instance.collection('Users').doc(_user?.uid).collection('Experience').doc(id).set({
          'id':id,
          'Title':_titletext.text,
          'Company Name':_companytext.text,
          'Location':_locationtext.text,
          'Start Date':_startDateController.text,
          'End Date':_endDateController.text,
          'Job Description':_jobdescText.text
        });
        const SnackBar(
          content: Text('Changes saved'),
        );
        Navigator.pushReplacement(context, PageTransition(
            child: const ExperienceScreen(),
            type: PageTransitionType.topToBottom,
            duration: const Duration(milliseconds: 300)
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
        title: Text('Add Experience',style: GoogleFonts.dmSans(
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
                      // Title
                      Text(
                        'Title',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _titletext,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter title!';
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
                          hintText: 'Ex: UI/UX Designer',
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
                      //Company Name
                      SizedBox(height: 20.h,),
                      Text(
                        'Company',
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
                        controller: _companytext,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter company name!';
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
                          hintText: 'Ex: Microsoft',
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
                      //Location
                      SizedBox(height: 20.h,),
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
                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _locationtext,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter location!';
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
                          hintText: 'Ex: London, United Kingdom',
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
                                        _startDateController.text=DateFormat('yMMMM').format(pickedDate);
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
                                        _endDateController.text=DateFormat('yMMMM').format(pickedDate);
                                      });
                                    }
                                  },
                                ),)
                            ],
                          ),
                        ],
                      ),
                      //Job Description
                      SizedBox(height: 20.h,),
                      Text(
                        'Job Description',
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
                        controller: _jobdescText,
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
                          hintText: 'job description',
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
                        _submitExpData();
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


