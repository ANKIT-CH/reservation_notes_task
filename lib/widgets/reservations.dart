// import 'package:chat_app/widgets/new_res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'individual_res.dart';

class Reservations extends StatelessWidget {
  var ctx;
  Reservations(this.ctx);

  void _deleteNote(String id) async {
    try {
      await Firestore.instance.collection('notes').document(id).delete();
    } catch (error) {
      print(error);
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text('unble to delete this item'),
          backgroundColor: Theme.of(ctx).errorColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapShot) {
        if (futureSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('reservations')
              .where('userId', isEqualTo: futureSnapShot.data.uid)
              .orderBy('resTime', descending: false)
              .snapshots(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            ///
            ///
            if (snapShot.data.documents.length <= 0) {
              return Center(
                child: Text('no data available'),
              );
            }

            ///
            ///
            return ListView.builder(
              reverse: false,
              itemCount: snapShot.data.documents.length,
              itemBuilder: (ctx, index) {
                // if (snapShot.data.documents[index]['userId'] ==
                //     futureSnapShot.data.uid) return null;
                // setState(() {
                //   widget.sortByTime = !widget.sortByTime;
                // });
                return IndividualReservation(
                  snapShot.data.documents[index]['name'],
                  snapShot.data.documents[index]['phNumber'],
                  snapShot.data.documents[index]['email'],
                  // snapShot.data.documents[index]['resTime']
                  //     .toDate()
                  DateFormat('kk:mm')
                      .format(
                          snapShot.data.documents[index]['resTime'].toDate())
                      .toString(),
                  DateFormat('dd-MM-yyyy')
                      .format(
                          snapShot.data.documents[index]['resTime'].toDate())
                      .toString(),
                  snapShot.data.documents[index].documentID,
                  _deleteNote,
                  key: ValueKey(
                    snapShot.data.documents[index].documentID,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
