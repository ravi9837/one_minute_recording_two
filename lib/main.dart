import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:record/record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String recordFilePath;
  // late Timer _recordingTimer;
  final _audioRecorder = Record();
  int i = 0; // declare i as a class-level variable
  String _directoryPath = "";
  bool continueRecording = true;
  final FirebaseStorage storage = FirebaseStorage.instance;
  late String folderId; // variable to store the random folder ID


  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }


  Future<void> startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      // Generate a random ID for the folder name
      String folderId = generateRandomId();

      // Create the folder in Firebase Storage
      String folderPath = 'recordings/$folderId/';
      await storage.ref().child(folderPath).putData(Uint8List(0));

      // Initialize the counter for the audio file names
      int counter = 0;

      // Loop indefinitely to continuously record audio
      while (continueRecording) {
        // Get the file path for the recorded audio file
        String recordFilePath = await getFilePath();

        // Start recording audio
        await _audioRecorder.start(
          path: recordFilePath,
          encoder: AudioEncoder.wav,
          bitRate: 16000,
          samplingRate: 16000,
        );

        // Record audio for 1 minute
        await Future.delayed(Duration(seconds: 10));

        // Stop recording
        await _audioRecorder.stop();

        // Get the file name for the recorded audio file
        String fileName = '$folderId/${folderId}_audio_$counter.wav';
        counter++;

        // Upload the recorded audio file to Firebase Storage
        Reference ref = storage.ref().child('recordings/$fileName');
        File file = File(recordFilePath);
        await ref.putFile(file);
        await deleteRecordings();

        // Reset the recording file path for the next recording
        recordFilePath = '';

        // Wait for a short period before starting the next recording
        await Future.delayed(const Duration(seconds: 1));
      }

      // Delete the folder in Firebase Storage when recording is stopped
      await storage.ref().child(folderPath).delete();
    } else {
      Permission.microphone.request();
      startRecord();
    }

    setState(() {});
  }
  String generateRandomId() {
    Random random = Random();
    int randomNumber = random.nextInt(90000) + 10000;
    return randomNumber.toString();
  }

  void stopRecord() {
    setState(() {
      continueRecording = false;
    });
  }


  Future<String> getFilePath() async {
    if (_directoryPath.isEmpty) {
      Directory storageDirectory = await getApplicationDocumentsDirectory();
      _directoryPath = "${storageDirectory.path}/recordings";
      Directory(_directoryPath).createSync(recursive: true);
    }
    String fileName = 'audio_$i${DateTime
        .now()
        .millisecondsSinceEpoch}.wav';
    i++;
    return '$_directoryPath/$fileName';
  }

  deleteRecordings() async {
    Directory recordingsDir = Directory(_directoryPath);
    List<FileSystemEntity> files = recordingsDir.listSync();
    for (var file in files) {
      if (file is File) {
        await file.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Recorder"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(height: 32),
            Icon(
              Icons.mic,
              size: 128,
              color: Colors.red,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: startRecord,
            tooltip: 'Start recording',
            child: Icon(Icons.mic),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: stopRecord,
            tooltip: 'Stop recording',
            child: Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}