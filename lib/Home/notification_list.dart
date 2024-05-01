import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: Text(
          'Notifications',
          style: GoogleFonts.dmSans(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').doc(uid).collection('Notification').orderBy('Arrived',descending: true).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) => ListTile(
                leading: FadeShimmer.round(
                  size: 50.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
                title: FadeShimmer(
                  height: 15.h,
                  width: 100.w,
                  radius: 10.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
                subtitle: FadeShimmer(
                  height: 10.h,
                  width: 100.w,
                  radius: 10.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    // background: Container(color: Colors.red,),
                    key: Key(snapshot.data.docs[index]['id']),
                    onDismissed: (direction){
                      CollectionReference ref=FirebaseFirestore.instance.collection("Users").doc(uid).collection("Notification");
                      ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:CircleAvatar(
                          radius: 22.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.r),
                              child:snapshot.data.docs[index]['UserImage']=="" ?
                              const Icon(Icons.person,size:25,color:Colors.black12,) :
                              Image.network(snapshot.data.docs[index]['UserImage']))),
                      title: Text('${snapshot.data?.docs[index]['title']}',
                          style: GoogleFonts.dmSans(color: Colors.white)),
                      subtitle: Text('${snapshot.data?.docs[index]['body']}',
                          style: GoogleFonts.dmSans(color: Colors.grey)),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'There is no Notification!',
                  style:
                  GoogleFonts.dmSans(color: Colors.white, fontSize: 16.sp),
                ),
              );
            }
          }
          return Center(
            child: Text(
              'Something went wrong',
              style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16.sp),
            ),
          );
        },
      ),
    );
  }
}
















