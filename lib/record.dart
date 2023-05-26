import 'dart:core';
import 'package:flutter/material.dart';
import 'package:one_minute_recording/methods/audioMethods.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';


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

  @override
  void initState() {
    super.initState();
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

  void setNextSampleRate() {
    setState(() {
      sampleRate = int.tryParse(sampleRateController.text) ?? 16000;
      sampleRate += 1000; // Increase the sample rate by 1000 Hz
      sampleRateController.text = sampleRate.toString();
    });
  }

  void setNextBitRate() {
    setState(() {
      bitRate = int.tryParse(bitRateController.text) ?? 32000;
      bitRate += 10000; // Increase the bit rate by 10000 bps
      bitRateController.text = bitRate.toString();
    });
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
                    startRecording();
                  },
                  child: Text("Start"),
                ),
                ElevatedButton(
                  onPressed: () {
                    stopRecord();
                  },
                  child: Text("Stop"),
                ),
                SizedBox(height: 16),
                Text(
                  'Bit Rate: $bitRate bps',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Sample Rate: $sampleRate Hz',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'encoder: ${encoder}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: bitRateController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Bit Rate (bps)',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: setNextBitRate,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sampleRateController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Sample Rate (Hz)',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: setNextSampleRate,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
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