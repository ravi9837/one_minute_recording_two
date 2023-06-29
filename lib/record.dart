import 'dart:async';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:one_minute_recording/const/toastMessage.dart';
import 'package:one_minute_recording/methods/audioMethods.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import 'audio_cutter.dart';


class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late final RecorderController recorderController;
  Duration updateFrequency = const Duration(milliseconds: 100);
  final StreamController<Duration> _currentDurationController = StreamController.broadcast();
  TextEditingController bitRateController = TextEditingController();
  TextEditingController sampleRateController = TextEditingController();
  int bitRate = 32000;
  int sampleRate = 16000;
  final _audioRecorder = Record();
  var encoder = AudioEncoder.wav;
  List recordings = [];
  AudioPlayer audioPlayer = AudioPlayer();
  String filePath = '';


  ///needed for storing the time stamps
  double normalizationFactor = Platform.isAndroid ? 60 : 40;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;
  final List<double> _waveData = [];  List<double> get waveData => _waveData;
  List nextPressed = [];
  double previous = 0;
  late double fnext;
  late double snext;
  var index =0;
  Duration recordedDuration = Duration.zero;
  bool _isDisposed = false;
  Duration elapsedDuration = Duration.zero;
  List signalValues = [];



  // int lowCounter3 = 0;
  // int highCounter3 = 0;
  // int threshold3 = 3;
  //
  // int lowCounter5 = 0;
  // int highCounter5 = 0;
  // int threshold5 = 4;
  // int audioCount = 0;
  //
  // bool flag = false;

  TextEditingController textController = TextEditingController();


  int audio = 0;
  int noAudio = 0;




  @override
  void initState() {
    super.initState();

    /// start recording in the initial state
    startRecording();

    /// Get the amplitude of the audio
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(seconds: 1
    ))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });
  }


  void notifyListeners() {
    if (_isDisposed) return;
  }


  // noAudioError(){
  //   /// TODO: Don't implement this function for vitals
  //   var currAmp = _amplitude?.current;
  //   print("This is curr amp $currAmp");
  //   if( lowCounter3 == threshold3 || highCounter3 == threshold3 ) {
  //     print('matched');
  //     // showToast('Audio is too low Please repeat again', ToastGravity.SNACKBAR);
  //     lowCounter3 = 0;
  //     highCounter3 = 0;
  //   }
  //   else if( highCounter3 == threshold3) {
  //     print('matched');
  //     showToast('Audio is too high Please repeat again', ToastGravity.SNACKBAR);
  //     highCounter3 = 0;
  //   }
  //
  //   else if( currAmp != null && currAmp > -5){
  //     highCounter3 += 1;
  //     print('this is counter high 3 $highCounter3');
  //   }
  //   else if(currAmp != null && currAmp < -5 && highCounter3 > 0){
  //     highCounter3= 0 ;
  //     print('counter high 3 $highCounter3');
  //   }
  //   else if( currAmp != null && currAmp <= -15){
  //     lowCounter3 += 1;
  //     print('this is counter low 3 $lowCounter3');
  //   }
  //   else if(currAmp != null && currAmp > -15 && lowCounter3 > 0){
  //     lowCounter3 = 0 ;
  //     print('low counter 3 $lowCounter3');
  //   }
  // }
  //
  // forFiveSec(){
  //   var currAmp = _amplitude?.current;
  //   print("This is curr amp $currAmp");
  //   if((lowCounter5 == threshold5 && flag == true) || (highCounter5 == threshold5 && flag == true)){
  //     // showToast('in last 5 sec. for 4 sec the audio was not audioble', ToastGravity.CENTER);
  //     showAlertDialog(context);
  //     lowCounter5 = 0;
  //     highCounter5 = 0;
  //     flag = false;
  //     print(lowCounter5);
  //     print(flag);
  //   }
  //   else if( (lowCounter5 == 2 && currAmp != null && currAmp > -30 && currAmp < -5) ||
  //       (highCounter5 == 2 && currAmp != null && currAmp < -5 && currAmp > -30)){
  //     flag = true;
  //     print("flag $flag");
  //   }
  //   else if (currAmp != null && currAmp < -30){
  //     lowCounter5 += 1;
  //   }
  //
  //   else if (currAmp != null && currAmp > -5){
  //     highCounter5 += 1;
  //     print("highCounter 1 $highCounter5");
  //
  //   }
  //   else if (currAmp != null && currAmp > -30 && currAmp < -5){
  //     audioCount +=1;
  //     print('audio count $audioCount');
  //   }
  //   else if(audioCount == 2 && lowCounter5 > 1 && highCounter5 > 1 && flag == true){
  //     lowCounter5 =0;
  //     highCounter5 = 0 ;
  //     flag = false;
  //   }
  // }


  /// ///////////////////////////////////////// error on audio 3 or 5 sec \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


  bool flag5 = false;
  bool flag3 = false;
  int c = 0;
  int ac = 0;

  Errorsignals() {
    var currAmp = _amplitude?.current;
    print(currAmp);
    if ((currAmp != null && currAmp > -5) ||
    (currAmp != null && currAmp < -20)) {
    c += 1;
    print('c $c');
    }
    if (flag5 == true && c == 2) {
      // showToast('There was no relevent audio for last 7 sec.', ToastGravity.CENTER);

      showAlertDialog(context , "audio is not proper please repeat the process again for this Question.","Alert");
      c = 0;
      flag5 = false;
      ac = 0;
      print('ac $ac');
    }
    else if (c == 3 && flag3 == true) {
      setState(() {
        Vibration.vibrate();
      });
      // showToast('There was no relevent audio for last 5 sec.', ToastGravity.CENTER);
      showAlertDialog(context , "audio is not proper please repeat the process again for this Question.","Alert");

      c = 0;
      flag3 = false;
      ac = 0;
      print('ac $ac');
    }
    else if ((ac == 2 && c >= 0 && (flag3 == true || flag3 == false)) ||
        (ac == 2 && c >= 0 && (flag5 == true || flag5 == false))) {
      ac = 0;
      c = 0;
      flag3 = false;
      flag5 = false;
      print('ac == $ac');
      print('c == $c');
      print('ac == $ac');
      print('flag3 == $flag3');
      print('flag5 == $flag5');
    }
    else if (c == 2 && flag3 == false) {
      flag3 = true;

      print('falg3 $flag3');
    }
    else if (c == 2 && flag3 == true && flag5 == false && currAmp != null &&
        currAmp > -20 && currAmp < -5) {
      flag5 = true;
      flag3 = false;
      c = 0;
    }
    else if ((currAmp != null && currAmp < -5) ||
        (currAmp != null && currAmp > -20)) {
      ac += 1;
      print('ac $ac');
    }
  }
  /// ///////////////////////////////////////// error on audio 3 or 5 sec \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




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
      isRecording = true;
      nextPressed.add(DateTime.now().millisecondsSinceEpoch);
      filePath = await getFilePath();
      bitRate = int.tryParse(bitRateController.text) ?? 32000;
      sampleRate = int.tryParse(sampleRateController.text) ?? 16000;

      await _audioRecorder.start(
        path: filePath,
        encoder: encoder,
        bitRate: bitRate,
        samplingRate: sampleRate,
      );


      ///    ///    ///    ///
    while(isRecording){
      // noAudioError();
      // forFiveSec();
      Errorsignals();
      await Future.delayed(Duration(milliseconds: 1000));
    }
      ///   ///   ///   ///


    } else {
      // Handle the case where permission is not granted
      print('Permission not granted to record audio.');
      return null;
    }
    return null;
  }




  /// Function for trimming the complete audio file in chunks according to the questions & answers

  // Future<void> audioTrim(id) async{
  //   /// initialization for variables
  //   List timeStamps =  nextPressed;
  //   nextPressed.add(DateTime.now().millisecondsSinceEpoch);
  //   /// splitting the audio file in chunks duration
  //   double dur = timeStamps[id+1].toDouble() - timeStamps[id].toDouble();
  //   next = dur/1000;
  //   next += previous;
  //   ///Give the file path in pathToFile variable
  //   String pathToFile = filePath;
  //   var result = await AudioCutter.cutAudio(pathToFile,previous,next);
  //   previous = next;
  // }

  Future<void> audioTrim(id) async{
    /// initialization for variables
    List timeStamps =  nextPressed;
    nextPressed.add(DateTime.now().millisecondsSinceEpoch);
    /// splitting the audio file in chunks duration
    double dur = timeStamps[id+1].toDouble() - timeStamps[id].toDouble();
    fnext = dur/1000;
    print('fnext $fnext');
    snext = fnext + previous;
    print('snext $snext');
    ///Give the file path in pathToFile variable
    if(textController.text.isNotEmpty || fnext > 3){
      String pathToFile = filePath;
      var result = await AudioCutter.cutAudio(pathToFile,previous,snext);
      print(result);
      previous = snext;
    }else if(textController.text.isEmpty || fnext <= 3){
      showToast("Audio duration is very less may be no audio there go to previous question and ask properly!", ToastGravity.CENTER);
      previous = snext;
    }
  }

  /// function for stopping the audio recording
  Future<void> stopRecord() async {
    nextPressed.add(DateTime
        .now()
        .millisecondsSinceEpoch);
    _audioRecorder.stop();
    isRecording = false;
  }
  ///initialization of first question index


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
                    // ///calling the trim function
                    // audioTrim(index);
                    // ///on tap on next button for each question the index must be incremented
                    // index+=1;
                    // print("Index : $index");
                    Vibration.vibrate();
                  },
                  child: const Text("Next"),
                ),
                ElevatedButton(
                  onPressed: () {
                    stopRecord();
                  },
                  child: const Text("Stop"),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // noAudioError();
                //   },
                //   child: const Text("amp"),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     // addSignals();
                //   },
                //   child: const Text("Stop"),
                // ),

                const SizedBox(height: 16),
                if (_amplitude != null) ...[

                  const SizedBox(height: 40),
                  Text('Current: ${_amplitude?.current ?? 0.0}'),
                  Text('Max: ${_amplitude?.max ?? 0.0}'),

                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "enter Something"
                    ),
                  )
                ],

                // showToast(("${_amplitude!.current}" !=20),ToastGravity.BOTTOM);
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