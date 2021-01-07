// import 'dart:html';

import 'package:chat_app/widgets/new_res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/reservations.dart';
import '../widgets/new_res.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  // bool _sortByTime = false;

  // void revert() {
  //   setState(() {
  //     // _sortByTime = !_sortByTime;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Reservations'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              ////
              ///
              ///
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Signout'),
                    ],
                  ),
                ),
                value: 'Signout',
              ),

              ///
              ///
              ///
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add),
                      SizedBox(
                        width: 5,
                      ),
                      Text('AddNew'),
                    ],
                  ),
                ),
                value: 'AddNew',
              ),
            ],
            onChanged: (itemValue) {
              if (itemValue == 'Signout') {
                FirebaseAuth.instance.signOut();

                ///
              }
              if (itemValue == 'AddNew') {
                Navigator.of(context)
                    .pushReplacementNamed(NewReservation.routeName); /////
              }
            },
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Reservations(context), ////
            ),
          ],
        ),
      ),
    );
  }
}
