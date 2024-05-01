import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../job/job_detail_page.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> favJobsList = [];
  List favItemList = [];

  bool isLoading=false;
  getFavJobsKeys() async {
    var favoritJobDocument = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteJobs")
        .get();
    for (int i = 0; i < favoritJobDocument.docs.length; i++) {
      favJobsList.add(favoritJobDocument.docs[i].id);
    }
    getFavKeysData(favJobsList);
  }

  getFavKeysData(List<String> keysList) async {
    var allJobs = await FirebaseFirestore.instance.collection("Jobs").get();
    for (int i = 0; i < allJobs.docs.length; i++) {
      for (int k = 0; k < keysList.length; k++) {
        if (((allJobs.docs[i].data() as dynamic)['id']) == keysList[k]) {
          favItemList.add(allJobs.docs[i].data());
        }
      }
    }
    setState(() {
      favItemList;
    });
  }

  favJobs(String jobid) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("FavoriteJobs")
        .doc(jobid)
        .get();
    if (document.exists) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoriteJobs")
          .doc(jobid)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("FavoriteJobs")
          .doc(jobid)
          .set({});
    }
  }

  Future<void> refreshData()async{
    setState(() {
      favItemList.clear();
      favJobsList.clear();
    });
    getFavJobsKeys();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading=true;
    });
    getFavJobsKeys();
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              centerTitle: true,
              toolbarHeight: 50.h,
              backgroundColor: const Color(0xff1D1D2F),
              elevation: 0,
              title:Text('Favorit Jobs',style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ],
          body: favItemList.isEmpty
              ? Center(
            child: Text(
              'There is no Favorite job',
              style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20.sp),
            ),
          )
              : RefreshIndicator(
            backgroundColor: const Color(0xff1D1D2F),
            color: Colors.white,
            onRefresh: () => refreshData(),
            child: ListView.separated(
              itemCount: favItemList.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    String id = favItemList[index]['id'];
                    Navigator.push(
                        context,
                        PageTransition(
                            child: JobDetailScreen(
                              id: id,
                              uid:favItemList[index]['uid'],
                              ownerEmail: favItemList[index]['OwnerEmail'],
                              jobDescription: favItemList[index]
                              ['JobDescription'],
                              jobExperience: favItemList[index]
                              ['JobExperience'],
                              jobType: favItemList[index]['JobType'],
                              jobLocation: favItemList[index]['JobLocation'],
                              userImage: favItemList[index]['UserImage'],
                              userName: favItemList[index]['UserName'],
                              jobTitle: favItemList[index]['JobTitle'],
                              postDate: favItemList[index]['PostedAt'],
                              jobSalary: favItemList[index]['JobSalary'],
                            ),
                            type: PageTransitionType.rightToLeft));
                  },
                  style: const ButtonStyle(
                      splashFactory: InkRipple.splashFactory,
                      // splashColor: Color(0xff5800FF),
                      overlayColor: MaterialStatePropertyAll(Color(0x4d5800ff)),
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      backgroundColor:
                      MaterialStatePropertyAll(Color(0xff282837)),
                      shape: MaterialStatePropertyAll(
                          ContinuousRectangleBorder())),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 107.h,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 15.w),
                            leading: CircleAvatar(
                                radius: 22.r,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22.r),
                                    child: favItemList[index]['UserImage'] == ""
                                        ? const Icon(
                                      Icons.error,
                                      size: 25,
                                      color: Colors.red,
                                    )
                                        : Image.network(
                                        favItemList[index]['UserImage']))),
                            title: Text(
                              '${favItemList[index]['JobTitle']}',
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${favItemList[index]['UserName']} - ${favItemList[index]['PostedAt']}',
                              style: GoogleFonts.dmSans(
                                color: const Color(0xffF6F8FE),
                                fontSize: 12.sp,
                              ),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: const Icon(Icons.arrow_forward_ios_sharp,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xffd1d1d1),
                                  size: 18,
                                ),
                                Text(
                                  '${favItemList[index]['JobLocation']}',
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xffd1d1d1),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                const Icon(
                                  Icons.currency_exchange_outlined,
                                  color: Color(0xffd1d1d1),
                                  size: 15,
                                ),
                                Text(
                                  '${favItemList[index]['JobSalary']}',
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xffd1d1d1),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10.h,);
              },
            ),
          ),
        ),
      ),
    );
  }
}
