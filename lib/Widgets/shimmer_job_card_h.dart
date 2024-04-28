import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShimmerJobCardH extends StatelessWidget {
  const ShimmerJobCardH({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
          width: 202.w,
          height: 240.h,
          decoration: BoxDecoration(
              color: const Color(0xff282837),
              borderRadius: BorderRadius.circular(8.r)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: FadeShimmer.round(
                    size: 40.r,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                  trailing: const FadeShimmer(
                    width: 20,
                    height: 20,
                    radius: 8,
                    highlightColor: Color(0xff798EA5),
                    baseColor: Color(0x27878787),
                  ),
                ),
                SizedBox(height: 10.h,),
                FadeShimmer(
                  height: 10.h,
                  width: 100.w,
                  radius: 10.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
                SizedBox(
                  height: 15.h,
                ),
                FadeShimmer(
                  height: 10.h,
                  width: 150.w,
                  radius: 10.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
                SizedBox(
                  height: 15.h,
                ),
                FadeShimmer(
                  height: 10.h,
                  width: 50.w,
                  radius: 10.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
                SizedBox(
                  height: 15.h,
                ),
                FadeShimmer(
                  height: 28.h,
                  width: 70.w,
                  radius: 8.r,
                  highlightColor: const Color(0xff798EA5),
                  baseColor: const Color(0x27878787),
                ),
                SizedBox(height: 10.h,),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: FadeShimmer(
                    height: 10.h,
                    width: 60.w,
                    radius: 10.r,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                  trailing: FadeShimmer(
                    width: 70.w,
                    height: 30.h,
                    radius: 12,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}