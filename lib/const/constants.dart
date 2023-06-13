

import 'package:flutter/cupertino.dart';
import 'package:record/record.dart';

List<Map<String,dynamic>> questionList = [{'id': 0,'question':"What is your name","group":'personal'},{'id': 1,'question':"your age","group":'personal'},{'question':"birth date","group":'personal'},{'question':"height","group":'measurement'},{'question':"weight","group":'measurement'},{'question':"blood group","group":'clinical'},{'question':"vision","group":'screening'},{'question':"Mobile number","group":'personal'},{'question':"Drinking","group":'social'},{'question':"Tobacco","group":'social'},{'question':"any medical history","group":'clinical_history'},{'question':"Diabetes","group":'clinical_history'},{'question':"oral cancer screening","group":'screening'}];
// List personal = [];
// List measurement = [];
// List clinical = [];
// List screening = [];
// List social = [];
// List clinical_history = [];
// List group = [];
// Map<String, List<String>> newList = {};
String? category;
List ques = [0,1,2,3,4,5,6,7];
TextEditingController ans = TextEditingController();
int bitRate = 32000;
int sampleRate = 16000;
List audioEncoders = [AudioEncoder.wav,AudioEncoder.aacEld,AudioEncoder.aacHe,AudioEncoder.aacLc,AudioEncoder.amrNb,AudioEncoder.flac,AudioEncoder.pcm8bit,AudioEncoder.pcm16bit];
TextEditingController bitRateController = TextEditingController();
TextEditingController sampleRateController = TextEditingController();
List mp3Bit = [45-85,70-105,100-130,120-150,140-185,150-195,170-210,190-250,220-260];


