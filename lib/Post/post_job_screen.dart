import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final TextEditingController _nametext = TextEditingController(text: '');
  final TextEditingController _phonenumbertext = TextEditingController(text: '');
  final TextEditingController _emailText = TextEditingController(text: '');
  final TextEditingController _passText = TextEditingController(text: '');
  final bool _isLoading = false;
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title:Text('Post a free job',style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500
              ),),
            ),
          ],
          body: SingleChildScrollView(
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
                      // key: _signupFormKey,
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
                            textInputAction: TextInputAction.done,
                            // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                            keyboardType: TextInputType.text,
                            controller: _nametext,
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
                            controller: _emailText,
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
                            maxLines: 3,
                            maxLength: 100,
                            textInputAction: TextInputAction.done,
                            // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                            keyboardType: TextInputType.multiline,
                            controller: _phonenumbertext,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Job description should not be empty';
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
                              hintText: 'Enter job description',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(bottom: 50),
                                child: Icon(Icons.description_outlined,size: 20,color: Colors.grey,),
                              ),
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
                          //Job Deadline date
                          SizedBox(height: 20.h,),
                          Text(
                            'Job Deadline Date',
                            style: GoogleFonts.dmSans(
                                color: Colors.white, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            controller: _passText,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please enter deadline date!';
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
                              hintText: 'Enter job deadline date',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.date_range_outlined,size: 20,color: Colors.grey,),
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
                    SizedBox(height: 30.h,),
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
                          onPressed: (){},
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
        ),
      ),
    );
  }
}


