import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../const/constants.dart';
import '../main.dart';



  bool showQuestion = false;
  final _audioRecorder = Record();
  String _directoryPath = "";
  bool continueRecording = true;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> listOfData = ['what is your name','what is your age','what is your number','what is your height','what is your weight','what is your DOB','your mother name','your father name'];
  List<String> listOfAns = [];

  ///

void addToCategory(){
  for (String groupName in group) {
    print('Group: $groupName');
    for (Map<String, dynamic> question in questionList) {
      if (question.containsValue(groupName)) {

      }
    }
    print('---');
  }
}

///

// Future<String?> startRecording() async {
//   bool hasPermission = await checkPermission();
//   if (hasPermission) {
//     String filePath = await getFilePath();
//     await _audioRecorder.start(
//       path: filePath,
//       encoder: AudioEncoder.wav,
//       bitRate: bitRate,
//       samplingRate: sampleRate,
//     );
//     print(filePath);
//     return filePath;
//   } else {
//     // Handle the case where permission is not granted
//     print('Permission not granted to record audio.');
//     return null;
//   }
// }


/// for getting file path

  Future<String> getFilePath() async {
    final Directory directory = await getTemporaryDirectory();
    return '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
  }

///

// Future<String> getFilesPath() async {
//   if (_directoryPath.isEmpty) {
//     Directory storageDirectory = await getApplicationDocumentsDirectory();
//     _directoryPath = "${storageDirectory.path}/recordings";
//     Directory(_directoryPath).createSync(recursive: true);
//   }
//   String fileName = 'audio_$i${DateTime
//       .now()
//       .millisecondsSinceEpoch}.wav';
//   i++;
//   return '$_directoryPath/$fileName';
// }

///

  deleteRecordings() async {
    Directory recordingsDir = Directory(_directoryPath);
    List<FileSystemEntity> files = recordingsDir.listSync();
    for (var file in files) {
      if (file is File) {
        await file.delete();
    }
  }
}

///

Future<bool> checkPermission() async {
  if (!await Permission.microphone.isGranted) {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}
  String generateRandomId() {
    Random random = Random();
    int randomNumber = random.nextInt(90000) + 10000;
    return randomNumber.toString();
  }


  ///

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
          bitRate: 32000,
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
  }


  ///

Future<void> startRecordd() async {
  bool hasPermission = await checkPermission();
  if (hasPermission) {
    String folderPath = 'recordings';
    await storage.ref().child(folderPath).putData(Uint8List(0));

    // Initialize the counter for the audio file names
    int counter = 0;

    // Loop indefinitely to continuously record audio
    while (continueRecording) {
      // Get the file path for the recorded audio file
      String recordFilePath = await getFilePath();

      // const config = RecordConfig(encoder: encoder,noiseSuppress: true);
      // Start recording audio
      await _audioRecorder.start(
        path: recordFilePath,
        encoder: AudioEncoder.wav,
        bitRate: 32000,
        samplingRate: 16000,
      );

      String fileName = '_audio_$counter.wav';
      counter++;

      // Upload the recorded audio file to Firebase Storage
      Reference ref = storage.ref().child('recordings/$fileName');
      File file = File(recordFilePath);
      await ref.putFile(file);
      await deleteRecordings();
    }
  } else {
    stopRecord();
  }
}

///


void stopRecord() {
  _audioRecorder.stop();
}





