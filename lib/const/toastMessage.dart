import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:record/record.dart';
import 'package:vibration/vibration.dart';



final _audioRecorder = Record();
bool isRecording = false;



///SHOWS A TOAST MESSAGE
showToast(String message, ToastGravity gravity) {
  return Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.blue,
    gravity: gravity,
    textColor: Colors.white,
    fontSize: 15,
    toastLength: Toast.LENGTH_SHORT,
  );
}

/// shows a alert dialog box
showAlertDialog(BuildContext context , String content , String title) {
  _audioRecorder.pause();
  isRecording = false;

  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}