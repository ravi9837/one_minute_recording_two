import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:one_minute_recording/audio_cutter.dart';
import 'package:one_minute_recording/methods/audioMethods.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';


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
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;


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

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds:100))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

  }

  @override
  void dispose() {
    bitRateController.dispose();
    sampleRateController.dispose();
    _amplitudeSub?.cancel();
    super.dispose();
  }

  /// function for playing recorded audio

  void playAudio(String filePath) async {
    await audioPlayer.play(filePath as Source);
  }

  /// function to start the audio recording

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

  /// Function for trimming the complete audio file in chunks according to the questions & answers

  double previous = 0;
  late double next;
  Future<void> audioTrim(id) async{
    /// initialization for variables
    List timeStamps =  nextPressed;
    /// splitting the audio file in chunks duration
    double dur = timeStamps[id+1].toDouble() - timeStamps[id].toDouble();
    next = dur/1000;
    next += previous;
    ///Give the file path in pathToFile variable
    String pathToFile = filePath;
    var result = await AudioCutter.cutAudio(pathToFile,previous,next);
    previous = next;
  }

  /// function for stopping the audio recording

  Future<void> stopRecord() async {
    _audioRecorder.stop();
  }
  var index =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Audio'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {

                    nextPressed.add(DateTime.now().millisecondsSinceEpoch);
                    print("${DateTime.now().millisecondsSinceEpoch}");
                    print("${DateTime.now()}");
                    print("Trim the audio function start");
                    audioTrim(index);
                    index+=1;
                    print("Index : $index");
                  },
                  child: const Text("Next"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // var endTime = getCurrentTime();
                    nextPressed.add(DateTime.now().millisecondsSinceEpoch);
                    print("${DateTime.now().millisecondsSinceEpoch}");
                    // print("${DateTime.now()}");
                    stopRecord();

                  },
                  child: const Text("Stop"),
                ),
                const SizedBox(height: 16),
                if (_amplitude != null) ...[
                  const SizedBox(height: 40),
                  Text('Current: ${_amplitude?.current ?? 0.0}'),
                  Text('Max: ${_amplitude?.max ?? 0.0}'),
                ],
              ],
            ),
          ),
          if (recordings.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Recorded Audio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recordings.length,
                    itemBuilder: (context, index) {
                      String recordingPath = recordings[index];
                      return ListTile(
                        title: Text(recordingPath),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
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