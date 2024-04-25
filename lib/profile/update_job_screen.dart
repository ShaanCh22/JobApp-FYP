import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Services/global_methods.dart';
import '../presistent/presestent.dart';


class UpdateJobScreen extends StatefulWidget {
  String jobid;
  UpdateJobScreen({super.key,required this.jobid});

  @override
  State<UpdateJobScreen> createState() => _UpdateJobScreenState();
}

class _UpdateJobScreenState extends State<UpdateJobScreen> {
  final TextEditingController _jobcategorytext = TextEditingController(text: '');
  final TextEditingController _jobtitletext = TextEditingController(text: '');
  final TextEditingController _jobtypetext = TextEditingController(text: '');
  final TextEditingController _joblocationtext = TextEditingController(text: '');
  final TextEditingController _jobdescription = TextEditingController(text: '');
  final TextEditingController _jobsalarytext = TextEditingController(text: '');
  final TextEditingController _jobexperiencetext = TextEditingController(text: '');
  String dt=DateFormat('MMM d, y').format(DateTime.now());
  final _jobdataformkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? userImage;
  String? userName;

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
                  itemCount: Presistent.jobCategoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobcategorytext.text =
                            Presistent.jobCategoryList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobCategoryList[index],
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
  void initState() {
    super.initState();
    _getJobData();
  }
  Future _getJobData() async{
    DocumentSnapshot ref = await FirebaseFirestore.instance.collection('Jobs').doc(widget.jobid).get();
    setState(() {
      _jobtypetext.text=ref.get('JobType');
      _jobtitletext.text=ref.get('JobTitle');
      _jobsalarytext.text=ref.get('JobSalary');
      _joblocationtext.text=ref.get('JobLocation');
      _jobexperiencetext.text=ref.get('JobExperience');
      _jobdescription.text=ref.get('JobDescription');
      _jobcategorytext.text=ref.get('JobCategory');
    });
  }
  Future _updateJobData() async{
    final isValid =_jobdataformkey.currentState!.validate();
    if(isValid){
      setState(() {
        _isLoading=true;
      });
      try{
        FirebaseFirestore.instance.collection('Jobs').doc(widget.jobid).update({
          'JobType':_jobtypetext.text,
          'JobTitle':_jobtitletext.text,
          'JobSalary':_jobsalarytext.text,
          'JobLocation':_joblocationtext.text,
          'JobExperience':_jobexperiencetext.text,
          'JobDescription':_jobdescription.text,
          'JobCategory':_jobcategorytext.text,
        });
        Future.delayed(const Duration(seconds:1)).then((value) => {
          setState(() {
            _isLoading=false;
            Fluttertoast.showToast(
                msg: 'Changes saved', toastLength: Toast.LENGTH_SHORT);
          })
        });
        Navigator.pop(context);
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
  void _deleteJobData(){
    FirebaseFirestore.instance.collection('Jobs').doc(widget.jobid).delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1D1D2F),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text('Edit Job Post',style: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500
          ),),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton(
                onPressed: (){
                  _deleteJobData();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline,color: Colors.white,),
              ),
            )
          ],
        ),
        body:SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 25.h),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 30.h,),
                  Form(
                    key: _jobdataformkey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobcategorytext,
                          onTap: (){
                            _showJobCategoryDialog();
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please select job category!';
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
                            hintText: 'Select job Category',
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(Icons.category_outlined,size: 20,color: Colors.grey,),
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
                        //Job Title
                        SizedBox(height: 20.h,),
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Job title should not be empty!';
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
                            hintText: 'Enter job title',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.title_outlined,size: 20,color: Colors.grey,),
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
                        //Job Type
                        SizedBox(height: 20.h,),
                        Text(
                          'Job Type',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp),
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Job Type should not be empty!';
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
                            hintText: 'Enter job type',
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(Icons.title_outlined,size: 20,color: Colors.grey,),
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
                        //Job Experience
                        SizedBox(height: 20.h,),
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Experience should not be empty!';
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
                            hintText: 'Experience Required',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.title_outlined,size: 20,color: Colors.grey,),
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
                        //Job Salary
                        SizedBox(height: 20.h,),
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Job Salary should not be empty!';
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
                            hintText: 'Enter job Salary',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.title_outlined,size: 20,color: Colors.grey,),
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
                        //Job Location
                        SizedBox(height: 20.h,),
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Job location should not be empty!';
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
                            hintText: 'Enter job location',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.title_outlined,size: 20,color: Colors.grey,),
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
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          controller: _jobdescription,
                          style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 15.sp
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Job description should not be empty!';
                            }
                            else{
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
                            prefixIcon: Icon(Icons.description_outlined,color: Colors.grey,),
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
                          onTap: (){
                            showModalBottomSheet(
                                backgroundColor: const Color(0xff1D1D2F),
                                context: context,
                                builder: (BuildContext context){
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
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Job description should not be empty!';
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
                                            hintText: 'Enter job title',
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
                                      ),
                                      const SizedBox(height: 10,),
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
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                      const SizedBox(height: 10,)
                                    ],
                                  );
                                });
                          },
                        )
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
                          _updateJobData();
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
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}


