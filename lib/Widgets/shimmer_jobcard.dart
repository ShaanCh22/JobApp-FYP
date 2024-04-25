import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShimmerJobCard extends StatelessWidget {
  const ShimmerJobCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 107.h,
        color: const Color(0xff282837),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15.w),
              child: Wrap(
                runSpacing: 10.h,
                spacing: 10.w,
                children: [
                  FadeShimmer.round(
                    size:10.r,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                  FadeShimmer(
                    height: 10.h,
                    width: 120.w,
                    radius: 10.r,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                  const SizedBox(width: 10,),
                  FadeShimmer.round(
                    size:10.r,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                  FadeShimmer(
                    height: 10.h,
                    width: 100.w,
                    radius: 10.r,
                    highlightColor: const Color(0xff798EA5),
                    baseColor: const Color(0x27878787),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}