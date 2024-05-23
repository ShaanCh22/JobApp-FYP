import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Services/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServiec splashServiec = SplashServiec();
  @override
  void initState() {
    super.initState();
    splashServiec.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.green,
        toolbarHeight: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: AutoSizeText('JobBook',
            style: GoogleFonts.dmSans(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onTertiary,
                letterSpacing: 1)),
      ),
    );
  }
}
