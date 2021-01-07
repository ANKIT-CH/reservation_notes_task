// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'new_res.dart';

class IndividualReservation extends StatelessWidget {
  final String name;
  final String phNumber;
  final String email;
  final String docId;
  final String resTime;
  final String resDate;

  final Function(String id) deleteNote;
  final Key key;

  IndividualReservation(this.name, this.phNumber, this.email, this.resTime,
      this.resDate, this.docId, this.deleteNote,
      {this.key});
  @override
  Widget build(BuildContext context) {
    // print(createdTime);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.greenAccent,
      ),
      width: (MediaQuery.of(context).size.width -
          MediaQuery.of(context).size.width * 0.03),
      // height: 100,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Column(
        crossAxisAlignment:
            // isMe ? CrossAxisAlignment.end :
            CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Name:- $name',
                // DateTime.parse(createdTime).toString(),
                // .toDate().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  deleteNote(docId);
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => (NewReservation(true, docId))));
                  // NewNotes(true, docId);
                  // print(' hello        ');
                },
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ],
          ),
          Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phone Number:-  $phNumber',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                // textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
          Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Email:-  $email',
                // DateTime.parse(createdTime).toString(),
                // .toDate().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Time:-  $resTime     Date:  $resDate',
                // DateTime.parse(createdTime).toString(),
                // .toDate().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
