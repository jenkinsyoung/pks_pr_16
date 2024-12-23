import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_12/src/resources/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(76, 23, 0, 1.0)),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoSansTextTheme(
              Theme.of(context).textTheme
          )
      ),
      home: const AuthGate()
    );
  }
}


