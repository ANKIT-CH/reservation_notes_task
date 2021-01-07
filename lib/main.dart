import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/reservations_page.dart';
import './pages/auth_page.dart';
import 'widgets/new_res.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue,
        accentColor: Colors.greenAccent,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      routes: {
        NewReservation.routeName: (ctx) => NewReservation(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userLoginSnapshot) {
          ///
          ///if user is already logedin then authentication is not needed everytime
          ///
          if (userLoginSnapshot.hasData) {
            return ReservationsPage();
          }

          ///
          ///if authentication instnance shows not logged in then the authentication screen will be shown
          ///

          return AuthPage();
        },
      ),
    );
  }
}
