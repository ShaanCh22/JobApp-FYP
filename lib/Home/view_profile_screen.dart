import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../OtherProfiles/education_page.dart';
import '../OtherProfiles/experience_page.dart';
import '../OtherProfiles/skills_page.dart';
import '../profile/pdf_viewer_screen.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final ScrollController scController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String resumeUrl = '';
  String resumeName = '';
  String name = '';
  @override
  void initState() {
    super.initState();
    _getResumeData();
  }

  Future _getResumeData() async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      resumeUrl = ref.get('Resume Url');
      resumeName = ref.get('ResumeName');
      name = ref.get('Name');
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _getResumeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        toolbarHeight: 50,
        centerTitle: true,
        // backgroundColor: Color(0xff282837),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(name, style: Theme.of(context).textTheme.displayMedium),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        color: Theme.of(context).colorScheme.onSecondary,
        onRefresh: () => refreshData(),
        child: ListView(
          children: [
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.hasError.toString()));
                          }
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                                radius: 30,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: snapshot.data!.get('User Image') ==
                                            ""
                                        ? const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 25,
                                            color: Colors.white,
                                          )
                                        : Image.network(
                                            '${snapshot.data!.get('User Image')}'))),
                            title: Text('${snapshot.data!.get('Name')}',
                                style: Theme.of(context).textTheme.labelMedium),
                            subtitle: Text(
                              '${snapshot.data!.get('Email')}',
                              style: GoogleFonts.dmSans(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Resumesection
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Resume',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    resumeUrl == ''
                        ? const SizedBox()
                        : ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewerScreen(
                                            pdfUrl: resumeUrl.toString(),
                                            resumeName: resumeName.toString(),
                                          )));
                            },
                            horizontalTitleGap: 10,
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              'assets/svg/img_frame_primary.svg',
                              theme: const SvgTheme(
                                  currentColor: Color(0xff8F00FF)),
                              width: 24,
                              height: 24,
                            ),
                            title: Text(resumeName,
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Aboutmesection
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('About Me',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.hasError.toString()));
                          }
                          return Text(
                            '${snapshot.data!.get('About Me')}',
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.outline),
                          );
                        })
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Expriencesection
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Experience',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(uid)
                            .collection("Experience")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.hasError.toString()));
                          }
                          return ListView.separated(
                            controller: scController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length > 2
                                ? 2
                                : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data!.docs[index]['Start Date']}-${snapshot.data!.docs[index]['End Date']}",
                                    style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff5800FF)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('${snapshot.data!.docs[index]['Title']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text(
                                    'At ${snapshot.data!.docs[index]['Company Name']}',
                                    style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[index]['Job Description']}',
                                    style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16,
                            ),
                          );
                        }),
                    const Divider(
                      thickness: 0.2,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(
                                Color(0x4d5800ff)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const ExperiencePage(),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Wrap(
                          children: [
                            Text('Show all experience  ',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Education-section
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Education',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(uid)
                            .collection("Education")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.hasError.toString()));
                          }
                          return ListView.separated(
                            controller: scController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length > 2
                                ? 2
                                : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data!.docs[index]['Start Date']}-${snapshot.data!.docs[index]['End Date']}',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff5800FF)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      '${snapshot.data!.docs[index]['School']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text(
                                    '${snapshot.data!.docs[index]['Degree']}',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16,
                            ),
                          );
                        }),
                    const Divider(
                      thickness: 0.2,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(
                                Color(0x4d5800ff)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const EducationPage(),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Wrap(
                          children: [
                            Text('Show all education  ',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //Skill section
            Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Skills',
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(uid)
                            .collection("Skills")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.hasError.toString()));
                          }
                          return Wrap(
                            spacing: 16,
                            runSpacing: 10,
                            children: List.generate(
                                snapshot.data!.docs.length > 3
                                    ? 3
                                    : snapshot.data!.docs.length, (index) {
                              return Chip(
                                color: MaterialStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                ),
                                elevation: 0,
                                label: Text(
                                    '${snapshot.data!.docs[index]['Title']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                backgroundColor: const Color(0xff282837),
                              );
                            }),
                          );
                        }),
                    const Divider(
                      thickness: 0.2,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(
                                Color(0x4d5800ff)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const SkillsPage(),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Wrap(
                          children: [
                            Text('Show all skills  ',
                                style: Theme.of(context).textTheme.titleLarge),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
