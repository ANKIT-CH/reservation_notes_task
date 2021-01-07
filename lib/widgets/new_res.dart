// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../pages/reservations_page.dart';

class NewReservation extends StatefulWidget {
  static const routeName = '/new_res';
  bool isEdit;
  String docId;
  NewReservation([this.isEdit = false, this.docId = '']);

  // final Function _revert;
  // NewNotes(this._revert);
  @override
  _NewReservationState createState() => _NewReservationState();
}

class _NewReservationState extends State<NewReservation> {
  final _formkey = GlobalKey<FormState>();
  bool initstate = true;
  bool _isLoading = false;

  var _name = '';
  var _phNumber = '';
  var _email = '';
  var _time = '';
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void _presentDate() {
    showDatePicker(
      context: context,
      initialDate:
          // widget.isEdit ?  :
          DateTime.now(),
      firstDate: DateTime(2018, 1, 1),
      lastDate: DateTime(2200, 1, 1),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  void _trySubmit() async {
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState.save();

      var ttime = _date + ' ' + _time + ':00';

      print(_name);
      print(_phNumber);
      print(_email);
      print(ttime);

      try {
        setState(() {
          _isLoading = true;
        });
        final user = await FirebaseAuth.instance.currentUser();
        widget.isEdit
            ? Firestore.instance
                .collection('reservations')
                .document(widget.docId)
                .updateData(
                {
                  'name': _name.trim(),
                  'phNumber': _phNumber.trim(),
                  'email': _email.trim(),
                  'resTime': Timestamp.fromDate(DateTime.parse(ttime)),
                  'userId': user.uid,
                },
              )
            : Firestore.instance.collection('reservations').add(
                {
                  'name': _name.trim(),
                  'phNumber': _phNumber.trim(),
                  'email': _email.trim(),
                  'resTime': Timestamp.fromDate(DateTime.parse(ttime)),
                  'userId': user.uid,
                },
              );
      } catch (error) {
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('an error occured:- error'),
        //   ),
        // );
        print(error);
      }

      setState(() {
        _isLoading = false;
      });
    }
    Navigator.of(context).pushReplacement(
        (MaterialPageRoute(builder: (_) => ReservationsPage())));
  }

  void init() async {
    if (widget.isEdit) {
      try {
        // await Firestore.instance  .collection('notes').where(FieldPath.documentId, isEqualTo: 'docId')  .getDocuments() .then( (value) { if (value.documents.isNotEmpty) {Map<String, dynamic> docData = value.documents.single.data;print(docData['name']);}}, );
        var doc = await Firestore.instance
            .collection('reservations')
            .document(widget.docId)
            .get();

        _name = doc.data['name'];
        _phNumber = doc.data['phNumber'];
        _email = doc.data['email'];
        _date = DateFormat('dd-MM-yyyy')
            .format(doc.data['resTime'].toDate())
            .toString();
        _time =
            DateFormat('kk:mm').format(doc.data['resTime'].toDate()).toString();
      } catch (error) {
        print(error);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('an error occured'),
            backgroundColor: Theme.of(context).errorColor));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Reservation' : 'New Reservation'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      // keyboardType: TextInputType.text,
                      key: ValueKey('Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter a name';
                        }
                        if (value.length > 15) {
                          return 'max. name length 15';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: widget.isEdit ? '$_name' : 'Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    TextFormField(
                      // keyboardType: TextInputType.text,
                      key: ValueKey('phNumber'),
                      validator: (value) {
                        if (value.isEmpty || value.length != 10) {
                          return 'enter number with length 10';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:
                            widget.isEdit ? '$_phNumber' : 'phone number',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      obscureText: true,
                      onSaved: (value) {
                        _phNumber = value;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: widget.isEdit ? '$_email' : 'email address',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      key: ValueKey('Time'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter Time';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:
                            widget.isEdit ? '$_time' : 'Time (eg. hh:mm)',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        _time = value;
                      },
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'picked date: $_date',
                          ),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'choose date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _presentDate,
                        ),
                      ],
                    ),
                    // if (isLoading) CircularProgressIndicator(),
                    // if (!isLoading)
                    RaisedButton(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'submit',
                            ),
                      onPressed: _isLoading ? null : _trySubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
