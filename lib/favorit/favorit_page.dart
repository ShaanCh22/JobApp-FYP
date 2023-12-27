import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              toolbarHeight: 50,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title:Text('Favorit',style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500
              ),),
            ),
          ],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.h,),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: 8+1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      if(index<8) {
                        return SizedBox(
                          width: double.infinity,
                          height: 107.h,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                splashFactory: InkRipple.splashFactory,
                                // splashColor: Color(0xff5800FF),
                                overlayColor: MaterialStatePropertyAll(Color(
                                    0x4d5800ff)),
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.zero),
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xff282837)),
                                shape: MaterialStatePropertyAll(
                                    ContinuousRectangleBorder())
                            ),
                            onPressed: () {},
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 15.w),
                                  leading: const CircleAvatar(
                                      backgroundColor: Colors.white),
                                  title: Text(
                                    'UX Writing',
                                    style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Zain Design! - 1 Hours Ago',
                                    style: GoogleFonts.dmSans(
                                      color: const Color(0xffF6F8FE),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: EdgeInsets.only(bottom: 15.h,),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.bookmark,),
                                      style: const ButtonStyle(
                                        overlayColor: MaterialStatePropertyAll(
                                            Color(0xff292c47)),
                                        padding:
                                        MaterialStatePropertyAll(
                                            EdgeInsets.zero),
                                        iconColor:
                                        MaterialStatePropertyAll(
                                            Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                        color: Color(0xffd1d1d1), size: 18,),
                                      Text(
                                        'Solo, Indonesia',
                                        style: GoogleFonts.dmSans(
                                          color: const Color(0xffd1d1d1),
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      const Icon(Icons.currency_exchange_outlined,
                                        color: Color(0xffd1d1d1), size: 15,),
                                      Text(
                                        ' IDR 8.500.000',
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
                      }else{
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: CircularProgressIndicator(color: Color(0xff5800FF)),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15.h,),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


