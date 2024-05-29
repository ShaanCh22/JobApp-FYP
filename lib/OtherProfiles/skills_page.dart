import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
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
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        toolbarHeight: 50,
        centerTitle: true,
        title: Text('Skills', style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(uid)
                .collection("Skills")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              }
              return Wrap(
                spacing: 10,
                runSpacing: 5,
                children: List.generate(snapshot.data!.docs.length, (index) {
                  return Chip(
                    color: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    label: Text('${snapshot.data!.docs[index]['Title']}',
                        style: Theme.of(context).textTheme.headlineSmall),
                    backgroundColor: const Color(0xff282837),
                  );
                }),
              );
            }),
      ),
    );
  }
}
