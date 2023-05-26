import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_minute_recording/const/constants.dart' as constant;
import 'package:one_minute_recording/record.dart';

import 'grid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

List questions=[];
Set group = {};


questionValues(){
  constant.questionList.forEach((element) {
    questions.add(element.values.first);
  });
}

groupValues(){
  constant.questionList.forEach((element) {
    group.add(element.values.last);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: ElevatedButton(
          child: const Text('Click me ❤️'),
          onPressed: () {
            groupValues();
            questionValues();
            // showQuestion = true;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AudioPage()),
            );
          },
        ),
      ),
    );
  }
}
