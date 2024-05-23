import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobseek/presistent/prefrence.dart';
import 'package:jobseek/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDTCkgeoxw296lI82otTw0Z2gh6lFv3DRM",
            authDomain: "jobapp-9281b.firebaseapp.com",
            projectId: "jobapp-9281b",
            storageBucket: "jobapp-9281b.appspot.com",
            messagingSenderId: "700205892465",
            appId: "1:700205892465:web:3d60a83da0229892206cd0"));
  } else {
    await Firebase.initializeApp();
  }
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  var ref = await SharedPreferences.getInstance();
  String theme;
  if (ref.getString('theme') != null) {
    theme = ref.getString('theme')!;
  } else {
    theme = 'Light';
  }
  runApp(MyApp(
    theme: theme,
  ));
}

class MyApp extends StatefulWidget {
  final String theme;
  const MyApp({super.key, required this.theme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var pref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jobbook',
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: widget.theme == 'Light'
            ? ThemeMode.light
            : widget.theme == 'Dark'
                ? ThemeMode.dark
                : ThemeMode.system,
        home: const SplashScreen());
  }
}
