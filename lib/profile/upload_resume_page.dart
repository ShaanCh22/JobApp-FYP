import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/global_methods.dart';

class UploadResumePage extends StatefulWidget {
  const UploadResumePage({super.key});
  @override
  State<UploadResumePage> createState() => _UploadResumePageState();
}

class _UploadResumePageState extends State<UploadResumePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final bool _isLoading = false;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? resumeUrl;
  String? resumeName;

  @override
  void initState() {
    super.initState();
    _getResumeData();
  }

  Future _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;
    setState(() {
      pickedFile = result.files[0];
    });
  }

  Future _uploadFile() async {
    final path = 'userResumes/${pickedFile?.name}';
    final file = File(pickedFile!.path!);
    String fileName = pickedFile!.name;
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });
      final snapshot = await uploadTask?.whenComplete(() {});
      final urlDownload = await snapshot?.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'Resume Url': urlDownload,
        'ResumeName': fileName,
      });
      SnackBar(
        content: Text(
          'Resume uploaded',
          style: GoogleFonts.dmSans(color: Colors.white),
        ),
      );
      setState(() {
        uploadTask = null;
      });
    } catch (error) {
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }

  void _deletePdf() {
    try {
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'Resume Url': '',
        'ResumeName': '',
      });
      setState(() {
        resumeUrl = '';
        resumeName = '';
      });
    } catch (e) {
      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
    }
  }

  Future _getResumeData() async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      resumeUrl = ref.get('Resume Url');
      resumeName = ref.get('ResumeName');
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
        centerTitle: true,
        title: Text('Upload Resume',
            style: Theme.of(context).textTheme.labelMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          DottedBorder(
            color: const Color(0xff5800FF),
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            dashPattern: const [14, 7],
            strokeCap: StrokeCap.round,
            strokeWidth: 2,
            child: SizedBox(
              height: 165,
              width: 380,
              child: resumeUrl == ''
                  ? ElevatedButton(
                      style: ButtonStyle(
                          splashFactory: InkRipple.splashFactory,
                          // splashColor: Color(0xff5800FF),
                          padding:
                              const MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.tertiaryContainer),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {
                        _selectFile();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_rounded,
                            color: Theme.of(context).colorScheme.outline,
                            size: 25,
                          ),
                          Text(
                            'Drop Resume',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              height: 2,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          )
                        ],
                      ),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                          splashFactory: InkRipple.splashFactory,
                          // splashColor: Color(0xff5800FF),
                          padding:
                              const MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.tertiaryContainer),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: const Color(0xff1D1D2F),
                          elevation: 20,
                          content: Text(
                            "Resume already uploaded",
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                            ),
                          ),
                        ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_rounded,
                            color: Theme.of(context).colorScheme.outline,
                            size: 25,
                          ),
                          Text(
                            'Drop Resume',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              height: 2,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text('Resume', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8)),
            child: pickedFile == null
                ? resumeUrl == ''
                    ? const SizedBox()
                    : ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        title: Text('$resumeName',
                            style: Theme.of(context).textTheme.titleSmall),
                        trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                pickedFile = null;
                                _deletePdf();
                              });
                            },
                            style: const ButtonStyle(
                                shape: MaterialStatePropertyAll(CircleBorder()),
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.transparent),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                elevation: MaterialStatePropertyAll(0)),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.outline,
                            )),
                      )
                : ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    title: Text(
                      '${pickedFile?.name}',
                      style:
                          GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          pickedFile = null;
                          _deletePdf();
                        });
                      },
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(CircleBorder()),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent),
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          elevation: MaterialStatePropertyAll(0)),
                      child: SvgPicture.asset(
                        'assets/svg/cross.svg',
                        theme: const SvgTheme(currentColor: Colors.grey),
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            height: 250,
          ),
          uploadTask == null
              ? SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        _uploadFile();
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Upload',
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                )
              : buildProgress()
        ],
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            double progress = data!.bytesTransferred / data.totalBytes;
            return Container(
              decoration: BoxDecoration(
                  color: const Color(0xff1D1D2F),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xff5800FF),
                    width: 2,
                  )),
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xff1D1D2F),
                    color: const Color(0xff5800FF),
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 10,
            );
          }
        },
      );
}
