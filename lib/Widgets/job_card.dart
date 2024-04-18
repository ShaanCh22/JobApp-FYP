import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class JobCard extends StatefulWidget {
  const JobCard({
    super.key,
    required this.userImage,
    required this.userName,
    required this.jobTitle,
    required this.jobLocation,
    required this.postDate,
    required this.jobSalary,
    required this.iconBtn,
  });

  final String? userImage;
  final String? userName;
  final String? jobTitle;
  final String? jobLocation;
  final String? postDate;
  final String? jobSalary;
  final IconButton iconBtn;
  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  DateTime dt = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      child: widget.userImage == ""
                          ? const Icon(
                              Icons.error,
                              size: 25,
                              color: Colors.red,
                            )
                          : Image.network(widget.userImage!))),
              title: Text(
                '${widget.jobTitle}',
                style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${widget.userName} - ${widget.postDate}',
                style: GoogleFonts.dmSans(
                  color: const Color(0xffF6F8FE),
                  fontSize: 12.sp,
                ),
              ),
              trailing: Padding(
                padding: EdgeInsets.only(
                  bottom: 15.h,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Color(0xff292c47)),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    iconColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
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
                    '${widget.jobLocation}',
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
                    '${widget.jobSalary}',
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
    );
  }
}
