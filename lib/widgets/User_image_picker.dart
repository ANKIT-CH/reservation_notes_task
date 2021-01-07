import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) submitImage;

  UserImagePicker(this.submitImage);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  bool _isCamera = true;
  File _pickedImage;
  void _pickImage(bool isCamera) async {
    final pickedImageFile = await ImagePicker().getImage(
      ///
      ///on the basis choice of the user by tapping corresponding button(camera or gallery)
      ///the sourse of image will be chosen
      ///
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });

    widget.submitImage(File(pickedImageFile.path));
    // widget.submitImage(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.black,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage),
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('are you sure?'),
                content: Text('select image from camera or gallery ?'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera),
                    // label: Text('camera'),
                    onPressed: () {
                      setState(() {
                        _isCamera = true;
                      });

                      // _isCamera = true;
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.photo),
                    // label: Text('Gallary'),
                    onPressed: () {
                      setState(() {
                        _isCamera = false;
                      });

                      // _isCamera = false;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
            _pickImage(_isCamera);
          },
        ),
      ],
    );
  }
}
