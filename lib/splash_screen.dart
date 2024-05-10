import 'package:flutter/material.dart';
import 'Services/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServiec splashServiec= SplashServiec();
  @override
  void initState() {
    super.initState();
    splashServiec.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'Jobseek',
            style: Theme.of(context).textTheme.bodyLarge
        ),
      ),
    );
  }
}
