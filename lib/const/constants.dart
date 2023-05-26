

import 'package:flutter/cupertino.dart';
import 'package:record/record.dart';

List<Map<String,dynamic>> questionList = [{'question':"What is your name","group":'personal'},{'question':"your age","group":'personal'},{'question':"birth date","group":'personal'},{'question':"height","group":'measurement'},{'question':"weight","group":'measurement'},{'question':"blood group","group":'clinical'},{'question':"vision","group":'screening'},{'question':"Mobile number","group":'personal'},{'question':"Drinking","group":'social'},{'question':"Tobacco","group":'social'},{'question':"any medical history","group":'clinical_history'},{'question':"Diabetes","group":'clinical_history'},{'question':"oral cancer screening","group":'screening'}];
// List personal = [];
// List measurement = [];
// List clinical = [];
// List screening = [];
// List social = [];
// List clinical_history = [];
// List group = [];
// Map<String, List<String>> newList = {};
String? category;
int i = 0;
TextEditingController ans = TextEditingController();
int bitRate = 32000;
int sampleRate = 16000;
List audioEncoders = [AudioEncoder.wav,AudioEncoder.aacEld,AudioEncoder.aacHe,AudioEncoder.aacLc,AudioEncoder.amrNb,AudioEncoder.flac,AudioEncoder.pcm8bit,AudioEncoder.pcm16bit];
TextEditingController bitRateController = TextEditingController();
TextEditingController sampleRateController = TextEditingController();



