import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import '../Home/other_view_profile.dart';

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
    required this.uid,
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
  String uid;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isFav=false;
  String? utoken = '';
  String? cuser = '';
  String? ruid = '';
  String? userImage = '';
  applyForJob(){
    final Uri params = Uri(
        scheme: 'mailto',
        path: widget.ownerEmail,
        query: 'subject=Applying for ${widget.jobTitle}&body=Hello, Please attach your Resume.'
    );
    final url = params.toString();
    launchUrlString(url);
  }
  getUserToken()async{
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('UserTokens').doc(widget.uid).get();
    DocumentSnapshot uDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      utoken=snap['token'];
      ruid=snap['id'];
      cuser=uDoc['Name'];
      userImage=uDoc['User Image'];
    });
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

  void sendPushNotification(String token, String title, String body)async{
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAp9E4QOU:APA91bFI1JRCbbkbF3I3waysKwzZP7kPV2h0zz5XSxEes3VnWCL5zeICMpfWbK8bLbCGu7ONEJobFtg7UMu9-y78kTfcomEZOZ6kT6tYGLorHPvxeMLpF6mQont5t2FmIPbAoQiLHqpO',
        },
        body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              "notification" : <String, dynamic>{
                "title": title,
                "body": body,
                "android_channel_id": 'fyp'
              },
              "to":token
            }
        ),
      );
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore.instance.collection('Users').doc(widget.uid).collection('Notification').doc(id).set({
        'title' :title.toString(),
        'id' : id,
        'uid' : uid,
        'body' :body.toString(),
        'UserImage' : userImage,
        "Arrived": dt,
      });
    }catch(e){
      SnackBar(content: Text(e.toString()),);
    }
  }
  initInfo(){
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,onSelectNotification: (String? payload)async {
      try{
        if(payload !=null && payload.isNotEmpty){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>OthersViewProfileScreen(id: ruid!)));
          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          //   return OtherViewProfileScreen(id: widget.uid,);
          // }));
        } else{

        }
      }catch(e){
        SnackBar(content: Text(e.toString()),);
      }
      return;
    },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserToken();
    initInfo();
    checkIsFav(widget.id);
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
            'Detail Jobs',
            style:Theme.of(context).textTheme.labelMedium
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
                color: Theme.of(context).colorScheme.outline,
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
                color:Theme.of(context).colorScheme.tertiaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.jobTitle}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
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
                          style: Theme.of(context).textTheme.headlineMedium
                      ),
                      subtitle: Text(
                          '${widget.jobLocation}',
                          style: Theme.of(context).textTheme.titleMedium
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
                            style: Theme.of(context).textTheme.titleSmall
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
                            style: Theme.of(context).textTheme.titleSmall
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
                            style: Theme.of(context).textTheme.titleSmall
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
                                sendPushNotification(
                                    utoken!,
                                    '$cuser,',
                                    'applied your ${widget.jobTitle} job.');
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
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: const Color(0xff5800FF),
                                  side: const BorderSide(
                                      color: Color(0xff5800FF), width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r))),
                              onPressed: () {},
                              child:Icon(
                                Icons.share_outlined,
                                color: Theme.of(context).colorScheme.outline,
                                size: 24,
                              )
                          ),
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
                color:Theme.of(context).colorScheme.tertiaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Responsibilities: ',
                        style: GoogleFonts.dmSans(
                            color:Theme.of(context).colorScheme.outline,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                        '${widget.jobDescription}',
                        style: GoogleFonts.dmSans(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.normal,
                          fontSize: 16.sp, )),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                color:Theme.of(context).colorScheme.tertiaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recruitment: ',
                        style: GoogleFonts.dmSans(
                            color:Theme.of(context).colorScheme.outline,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                        'Create delightful user interface based on our design system. Create interface elements such as menus, tabs, widgets, etc. Collaborate closely with UX Researchers, Product Manager / Product Owner, & Software Engineer. Help build design system with other designers. Build UI Component on Design System',
                        style: GoogleFonts.dmSans(
                          color:Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.normal,
                          fontSize: 16.sp,)),
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
