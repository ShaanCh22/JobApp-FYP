import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobseek/profile/update_education_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'add_education_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});
  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final ScrollController scController = ScrollController();
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.onSurface,
              statusBarIconBrightness: Theme.of(context).brightness),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
          centerTitle: true,
          title: Text('Education',
              style: Theme.of(context).textTheme.displayMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                        child: const AddEducationScreen(),
                        type: PageTransitionType.bottomToTop,
                      ));
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.outline,
                ),
                iconSize: 28,
              ),
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('Education')
                .snapshots(),
            builder: (context, snapshot) {
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.hasError.toString()));
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        splashFactory: InkRipple.splashFactory,
                        // splashColor: Color(0xff5800FF),
                        overlayColor:
                            const MaterialStatePropertyAll(Color(0x4d5800ff)),
                        onTap: () {
                          String id = snapshot.data!.docs[index]['id'];
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: UpdateEducationScreen(id = id),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${snapshot.data!.docs[index]["School"]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                              Text('${snapshot.data!.docs[index]["Degree"]}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${snapshot.data!.docs[index]["Field of Study"]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${snapshot.data!.docs[index]["Start Date"]}-${snapshot.data!.docs[index]["End Date"]}',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                  '${snapshot.data!.docs[index]["Description"]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
              );
            }));
  }
}
