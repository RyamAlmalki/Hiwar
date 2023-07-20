import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/screens/home/home_screen.dart';
import 'package:chatapp/screens/authenticate/login_screen.dart';
import 'package:chatapp/screens/home/message_screen.dart';
import 'package:chatapp/screens/authenticate/register_screen.dart';
import 'package:chatapp/screens/home/profile_screen.dart';
import 'package:chatapp/screens/spalsh_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/wrapper.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
         // "/" defines which route the app should start with
        '/': (context) => const SplashScreen(),
        'auth': (context) => const Wrapper(),
        'homeScreen':(context) => const HomeScreen(),
        'registerScreen':(context) => const RegisterScreen(),
        'loginScreen':(context) => const LoginScreen(),
        'messageScreen':(context) => const MessageScreen(),
        'profileScreen':(context) => const ProfileScreen(),
      },
    );
  }
}


