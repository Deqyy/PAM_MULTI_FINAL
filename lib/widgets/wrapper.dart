import 'package:app_resep_makanan/pages/home_page.dart';
import 'package:app_resep_makanan/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }else if(snapshot.hasError) {
        return Center(child: Text(snapshot.error.toString()),);
      }else {
        if(snapshot.data == null) {
          return LandingPage();
        }else {
          return HomePage();
        }
      }
    }),);
  }
}
