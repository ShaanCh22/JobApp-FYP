import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JobDetailScreen extends StatefulWidget {
  JobDetailScreen({
    super.key,
    required this.userImage,
    required this.id,
    required this.userName,
    required this.jobTitle,
    required this.jobLocation,
    required this.postDate,
    required this.jobSalary,
    required this.jobExperience,
    required this.jobType,
    required this.jobDescription,
    required this.ownerEmail,
  });

  final String? userImage;
  final String? userName;
  final String? jobTitle;
  final String? jobLocation;
  final String? postDate;
  final String? jobSalary;
  final String? jobType;
  final String? jobExperience;
  final String? jobDescription;
  final String? ownerEmail;
  String id;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isFav=false;

  applyForJob(){
    final Uri params = Uri(
        scheme: 'mailto',
        path: widget.ownerEmail,
        query: 'subject=Applying for ${widget.jobTitle}&body=Hello, Please attach your Resume.'
    );
    final url = params.toString();
    launchUrlString(url);
  }
  checkIsFav(String jobid)async{
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid).collection("FavoriteJobs").doc(jobid)
        .get();
    setState(() {
      isFav=document.exists;
    });
  }
  favJobs(String jobid)async{
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid).collection("FavoriteJobs").doc(jobid)
        .get();
    if(document.exists){
      setState(() {
        isFav=false;
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).collection("FavoriteJobs").doc(jobid)
          .delete();
      Fluttertoast.showToast(
          msg: 'Removed from favorites', toastLength: Toast.LENGTH_SHORT);
    }
    else{
      setState(() {
        isFav=true;
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).collection("FavoriteJobs").doc(jobid)
          .set({});
      Fluttertoast.showToast(
          msg: 'Added to favorites', toastLength: Toast.LENGTH_SHORT);
    }
  }
  @override
  void initState() {
    super.initState();
    checkIsFav(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Detail Jobs',
          style:
          GoogleFonts.dmSans(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              onPressed: () {
                favJobs(widget.id);

              },
              icon: Icon(
                isFav ? Icons.bookmark :
                Icons.bookmark_border_outlined,
                color: Colors.white,
              ),
              iconSize: 24,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: const Color(0xff282837),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.jobTitle}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold)),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 25.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: widget.userImage == ""
                                  ? const Icon(
                                Icons.error,
                                size: 25,
                                color: Colors.red,
                              )
                                  : Image.network(widget.userImage!))),
                      title: Text(
                        '${widget.userName}',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${widget.jobLocation}',
                        style: GoogleFonts.dmSans(
                          color: const Color(0xffF6F8FE),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10.h,
                      children: [
                        const Icon(
                          Icons.work_outline,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          '  ${widget.jobExperience} Years Experience',
                          style: GoogleFonts.dmSans(
                            color: const Color(0xffF6F8FE),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10.h,
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          '  ${widget.jobType}',
                          style: GoogleFonts.dmSans(
                            color: const Color(0xffF6F8FE),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10.h,
                      children: [
                        const Icon(
                          Icons.currency_exchange_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          '  ${widget.jobSalary}',
                          style: GoogleFonts.dmSans(
                            color: const Color(0xffF6F8FE),
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 25.w,
                      runSpacing: 10.h,
                      children: [
                        SizedBox(
                          height: 52.h,
                          width: 245.w,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: const Color(0xff5800FF),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.r))),
                              onPressed: () {
                                applyForJob();
                              },
                              child: Text('ApplyNow',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ))),
                        ),
                        SizedBox(
                          height: 52.h,
                          width: 70.w,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: const Color(0xff1D1D2F),
                                  foregroundColor: const Color(0xff5800FF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.r))),
                              onPressed: () {},
                              child: const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                                size: 24,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                color: const Color(0xff282837),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Responsibilities: ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                        '${widget.jobDescription}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'DMSans',)),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                color: const Color(0xff282837),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recruitment: ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                        'Create delightful user interface based on our design system. Create interface elements such as menus, tabs, widgets, etc. Collaborate closely with UX Researchers, Product Manager / Product Owner, & Software Engineer. Help build design system with other designers. Build UI Component on Design System',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'DMSans',)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
