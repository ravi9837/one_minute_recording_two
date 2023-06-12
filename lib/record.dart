import 'dart:core';
import 'package:flutter/material.dart';
import 'package:one_minute_recording/methods/audioMethods.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_trimmer/flutter_audio_trimmer.dart';


class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  TextEditingController bitRateController = TextEditingController();
  TextEditingController sampleRateController = TextEditingController();
  int bitRate = 32000;
  int sampleRate = 16000;
  final _audioRecorder = Record();
  var encoder = AudioEncoder.wav;
  List recordings = [];
  AudioPlayer audioPlayer = AudioPlayer();
  String filePath = '';
  List nextPressed = [];
  // DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    startRecording();
    // var startTime = getCurrentTime();
    DateTime.now();
    nextPressed.add(DateTime.now().millisecondsSinceEpoch);
    print("${DateTime.now().millisecondsSinceEpoch}");
    print("${DateTime.now()}");
    // print(DateTime.now().millisecondsSinceEpoch);
    bitRateController.text = bitRate.toString();
    sampleRateController.text = sampleRate.toString();
  }

  @override
  void dispose() {
    bitRateController.dispose();
    sampleRateController.dispose();
    super.dispose();
  }



  void playAudio(String filePath) async {
    await audioPlayer.play(filePath as Source);
  }

  Future<String?> startRecording() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      filePath = await getFilePath();
      bitRate = int.tryParse(bitRateController.text) ?? 32000;
      sampleRate = int.tryParse(sampleRateController.text) ?? 16000;

      await _audioRecorder.start(
        path: filePath,
        encoder: encoder,
        bitRate: bitRate,
        samplingRate: sampleRate,
      );
      print(filePath);
      recordings.add(filePath);
      setState(() {});
      print(recordings);
      return filePath;
    } else {
      // Handle the case where permission is not granted
      print('Permission not granted to record audio.');
      return null;
    }
  }


  Future<void> _onTrimAudioFile() async {
    try {
      if (_file != null) {
        Directory directory = await getApplicationDocumentsDirectory();

        File? trimmedAudioFile = await FlutterAudioTrimmer.trim(
          inputFile: _file!,
          outputDirectory: directory,
          fileName: DateTime.now().millisecondsSinceEpoch.toString(),
          fileType: Platform.isAndroid ? AudioFileType.mp3 : AudioFileType.m4a,
          time: AudioTrimTime(
            start: const Duration(seconds: 50),
            end: const Duration(seconds: 100),
          ),
        );
        setState(() {
          _outputFile = trimmedAudioFile;
        });
      } else {
        _showSnackBar('Select audio file for trim');
      }
    } on AudioTrimmerException catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> stopRecord() async {
    _audioRecorder.stop();
    int i = 0;
    List l =  nextPressed;
    print(nextPressed);
    int j = 1;
    List l1 = [];
    List l2 = [0];
    late int start;
    late int end;
    int a = 0;
    int b = 1;

    for(i ; i < l.length-1;i++){
      int c = l[j] - l[i];
      int d = (c/1000).floor();
      l1.add(d);
      l2.add(l2[i]+d);
      j++;
    }
    print('l1 : $l1');
    print('l2 : $l2');


    for (a;a<l2.length-1;a++){
      start = l2[a];
      end = l2[b];
      print('hii');
      // print('result : $result');
      print('start : $start');
      print('end : $end');
      b++;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Audio'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {

                    nextPressed.add(DateTime.now().millisecondsSinceEpoch);
                    print("${DateTime.now().millisecondsSinceEpoch}");
                    print("${DateTime.now()}");
                    // startRecording();
                  },
                  child: Text("Next"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // var endTime = getCurrentTime();
                    nextPressed.add(DateTime.now().millisecondsSinceEpoch);
                    print("${DateTime.now().millisecondsSinceEpoch}");
                    // print("${DateTime.now()}");
                    stopRecord();
                    print(nextPressed);
                  },
                  child: Text("Stop"),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          if (recordings.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recorded Audio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recordings.length,
                    itemBuilder: (context, index) {
                      String recordingPath = recordings[index];
                      return ListTile(
                        title: Text(recordingPath),
                        trailing: IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {
                            playAudio;
                            // Implement audio playback for the selected recordingPath
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

}