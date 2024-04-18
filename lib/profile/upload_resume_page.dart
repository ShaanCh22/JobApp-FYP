import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadResumePage extends StatefulWidget {
  const UploadResumePage({super.key});
  @override
  State<UploadResumePage> createState() => _UploadResumePageState();
}

class _UploadResumePageState extends State<UploadResumePage> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Upload Resume',
          style:
              GoogleFonts.dmSans(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        children: [
          DottedBorder(
            color: const Color(0xff5800FF),
            borderType: BorderType.RRect,
            radius: Radius.circular(8.r),
            dashPattern: const [14, 7],
            strokeCap: StrokeCap.round,
            strokeWidth: 2.w,
            child: SizedBox(
              height: 165.h,
              width: 380.w,
              child: ElevatedButton(
                style: ButtonStyle(
                    splashFactory: InkRipple.splashFactory,
                    // splashColor: Color(0xff5800FF),
                    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/upload_resume.svg',
                      theme: const SvgTheme(currentColor: Colors.grey),
                      width: 24.h,
                      height: 24.h,
                    ),
                    Text(
                      'Drop Resume',
                      style: GoogleFonts.dmSans(
                          fontSize: 16.sp, height: 2.h, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            'Queue',
            style: GoogleFonts.dmSans(color: Colors.white, fontSize: 18.sp),
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xff282837),
                borderRadius: BorderRadius.circular(8.r)),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 10.w, top: 5.h, bottom: 5),
              title: Text(
                'File Name.pdf',
                style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16.sp),
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(CircleBorder()),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    elevation: MaterialStatePropertyAll(0)),
                child: SvgPicture.asset(
                  'assets/svg/cross.svg',
                  theme: const SvgTheme(currentColor: Colors.grey),
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xff282837),
                borderRadius: BorderRadius.circular(8.r)),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 10.w, top: 5.h, bottom: 5),
              title: Text(
                'File Name.docx',
                style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16.sp),
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(CircleBorder()),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    elevation: MaterialStatePropertyAll(0)),
                child: SvgPicture.asset(
                  'assets/svg/cross.svg',
                  theme: const SvgTheme(currentColor: Colors.grey),
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 250.h,
          ),
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
                onPressed: () {},
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Upload',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      )),
          ),
        ],
      ),
    );
  }
}
