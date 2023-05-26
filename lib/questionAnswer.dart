import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'main.dart';


class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // final List<String> questions = [    "What is your name?",    "What is your age?",    "Where do you live?",    "What is your favorite color?"  ];

  final _audioRecorder = Record();
  int _currentIndex = 0;
  List<String> _answers = List.filled(4, "");

  void _onAnswerSubmitted(String answer) {
    setState(() {
      _answers[_currentIndex] = answer;
      if (_currentIndex < 3) {
        _currentIndex++;
      }
    });
  }

  Future<String> startRecording() async {
    String filePath = await getFilePath();
    await _audioRecorder.start(path: filePath);
    return filePath;
  }

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  void stopRecord() {
    setState(() {
      _audioRecorder.stop();
    });
  }

  void _onSubmitPressed() {
    if (_currentIndex == questions.length) {
      // Submit answers and go back to previous page
      Navigator.pop(context, _answers);
      stopRecord();
    } else {
      // Go to the next question
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question and Answer Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "${_currentIndex + 1}. ${questions[_currentIndex]}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Your answer",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onAnswerSubmitted,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onSubmitPressed,
              child: Text(_currentIndex < questions.length ? "Submit" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}
