// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../pages/reservations_page.dart';

class NewReservation extends StatefulWidget {
  static const routeName = '/new_res';
  final bool isEdit;
  final String docId;
  NewReservation([this.isEdit = false, this.docId = '']);

  // final Function _revert;
  // NewNotes(this._revert);
  @override
  _NewReservationState createState() => _NewReservationState();
}

class _NewReservationState extends State<NewReservation> {
  final _formkey = GlobalKey<FormState>();
  bool initstate = true;
  // bool _isLoaded = false;

  var nameController = new TextEditingController();
  var phNumberController = new TextEditingController();
  var emailController = new TextEditingController();
  var timeController = new TextEditingController();
  var dateController = new TextEditingController(
      text: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

  ///
  ///Function to pick date from calender
  ///
  void _presentDate() {
    showDatePicker(
      context: context,
      initialDate:
          // widget.isEdit ?  :
          DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200, 1, 1),
    ).then((value) {
      if (value == null) {
        print('problem');
        return;
      }

      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  void _trySubmit() async {
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState.save();

      var ttime = dateController.text + ' ' + timeController.text + ':00';

      print(nameController.text);
      print(phNumberController.text);
      print(emailController.text);
      print(ttime);

      try {
        final user = await FirebaseAuth.instance.currentUser();
        widget.isEdit
            ? Firestore.instance
                .collection('reservations')
                .document(widget.docId)
                .updateData(
                {
                  'name': nameController.text.trim(),
                  'phNumber': phNumberController.text.trim(),
                  'email': emailController.text.trim(),
                  'resTime': Timestamp.fromDate(DateTime.parse(ttime)),
                  'userId': user.uid,
                },
              )
            : Firestore.instance.collection('reservations').add(
                {
                  'name': nameController.text.trim(),
                  'phNumber': phNumberController.text.trim(),
                  'email': emailController.text.trim(),
                  'resTime': Timestamp.fromDate(DateTime.parse(ttime)),
                  'userId': user.uid,
                },
              );
      } catch (error) {
        //in case if we want to show a snackbar ion occurence of any error
        //
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('an error occured:- error'),
        //   ),
        // );
        print(error);
      }

      // setState(() {
      //   _isLoading = false;
      // });
      //

      //when we have filled the data and uploaded it to database or
      // any error occured then we will navigate to all reservations page
      //
      Navigator.of(context).pushReplacement(
          (MaterialPageRoute(builder: (_) => ReservationsPage())));
    }
  }

  void init() async {
    ///
    ///when we have to edit the given document then
    /// first we need to provide initial value to every [TextFormField]
    ///
    if (widget.isEdit) {
      try {
        // await Firestore.instance  .collection('notes').where(FieldPath.documentId, isEqualTo: 'docId')  .getDocuments() .then( (value) { if (value.documents.isNotEmpty) {Map<String, dynamic> docData = value.documents.single.data;print(docData['name']);}}, );
        var doc = await Firestore.instance
            .collection('reservations')
            .document(widget.docId)
            .get();

        nameController.text = doc.data['name'];
        phNumberController.text = doc.data['phNumber'];
        emailController.text = doc.data['email'];
        dateController.text = DateFormat('yyyy-MM-dd')
            .format(doc.data['resTime'].toDate())
            .toString();
        timeController.text =
            DateFormat('kk:mm').format(doc.data['resTime'].toDate()).toString();
        print(nameController.text);
        setState(() {
          initstate = false;
        });
      } catch (error) {
        print(error);
        //in case if we want to show a snackbar ion occurence of any error
        //
        // Scaffold.of(context).showSnackBar(SnackBar(
        //     content: Text('an error occured'),
        //     backgroundColor: Theme.of(context).errorColor));
      }
    }
  }

//to dispose all the controllers
  @override
  void dispose() {
    nameController.dispose();
    phNumberController.dispose();
    emailController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initstate) init();

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
                    ///
                    ///[TextFormField] for Name
                    ///
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
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
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        nameController.text = value;
                      },
                    ),

                    ///
                    ///[TextFormField] for Phone Number
                    ///
                    TextFormField(
                      controller: phNumberController,
                      keyboardType: TextInputType.number,
                      key: ValueKey('phNumber'),
                      validator: (value) {
                        if (value.isEmpty || value.length != 10) {
                          return 'enter number with length 10';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'phone number(max length 10)',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        phNumberController.text = value;
                      },
                    ),

                    ///
                    ///[TextFormField] for Email
                    ///
                    TextFormField(
                      controller: emailController,
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'email address',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        emailController.text = value;
                      },
                    ),

                    ///
                    ///[TextFormField] for Reservation Time
                    ///
                    TextFormField(
                      controller: timeController,
                      keyboardType: TextInputType.datetime,
                      key: ValueKey('Time'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter Time';
                        }
                        if (value.length > 5 ||
                            value[2] != ':' ||
                            double.parse(value[0] + value[1]) > 24 ||
                            (double.parse(value[0] + value[1]) == 24 &&
                                double.parse(value[3] + value[4]) > 0) ||
                            double.parse(value[3] + value[4]) > 59) {
                          return 'enter valid Time format';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Time (eg. format hh:mm)',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onSaved: (value) {
                        timeController.text = value;
                      },
                    ),
                    SizedBox(height: 10),

                    ///
                    ///we can also use [InputDatePickerFormField] to pick date
                    ///
                    //  InputDatePickerFormField(
                    // firstDate: DateTime.now(), lastDate: DateTime.now()),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'picked date: ${dateController.text}',
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
                    RaisedButton(
                      child:
                          //  _isLoading  ? CircularProgressIndicator() :
                          Text(
                        'submit',
                      ),
                      onPressed:
                          //  _isLoading ? null :
                          _trySubmit,
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
