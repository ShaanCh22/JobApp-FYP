import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobseek/splash_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xff1D1D2F),
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double dwidth= MediaQuery.of(context).size.width;
    double dheight= MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      builder: (_,child)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jobseek',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xff1D1D2F),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyApplication()),
      designSize:  Size(dwidth, dheight),
    );
  }
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Something wrong'),
              ),
            );
          } else if (snapshot.hasData) {
            return const SplashScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
