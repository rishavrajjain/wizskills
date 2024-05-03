import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:wizskills/api/azure_api.dart';

class SpeakProvider extends ChangeNotifier {
  // Define variables to hold the triggers and booleans
  SMITrigger? successTrigger;
  SMITrigger? failTrigger;
  SMIBool? isHandsUp, isChecking, isTalking, isHearing;
  SMINumber? numLook;
  StateMachineController? stateMachineController;
  Artboard? _teddyArtboard;
  Artboard? _secondTeddyArtboard;
  String whatYouSaid = 'Select any topic';
  String youCouldHavesaid =
      'Eg: Share about a movie or TV show you enjoy watching.';
  List<String> selectedText = [];
  String yourAnswer = 'Answer: Use the word';
  String betterAnswer = '';
  bool? usedWord;

  // Constructor to initialize the triggers and booleans
  SpeakProvider({
    this.successTrigger,
    this.failTrigger,
    this.isHandsUp,
    this.isChecking,
  });

  Artboard? get teddyArtboard => _teddyArtboard;
  Artboard? get secondTeddyArtboard => _secondTeddyArtboard;




  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }

  void addToSelectedText(String text) {
    selectedText.add(text);
    notifyListeners();
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void startHearing() {
    isHearing?.change(true);
  }

  void stopHearing() {
    isHearing?.change(false);
  }

  void moveEyeBalls(val) {
    numLook?.change(val.length.toDouble());
  }

  void login() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (true) {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
  }

  Future<void> loadAnimation() async {
    const animationURL = 'assets/bear_1.riv';

    try {
      final data = await rootBundle.load(animationURL);
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      // ... (remaining parsing logic from initState can go here)

      stateMachineController =
          StateMachineController.fromArtboard(artboard, "State Machine 1");
      if (stateMachineController != null) {
        artboard.addController(stateMachineController!);

        for (var e in stateMachineController!.inputs) {
          debugPrint(e.runtimeType.toString());
          debugPrint("name${e.name}End");
        }

        for (var element in stateMachineController!.inputs) {
          if (element.name == "success") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "fail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "Check") {
            isChecking = element as SMIBool;
          } else if (element.name == "Talk") {
            isTalking = element as SMIBool;
          } else if (element.name == "Hear") {
            isHearing = element as SMIBool;
          } else if (element.name == "Look") {
            numLook = element as SMINumber;
          }
        }
      }

      _teddyArtboard = artboard;
      notifyListeners();
    } catch (error) {
      print('Error loading animation: $error');
    }
  }


    Future<void> loadSecondAnimation() async {
    const animationURL = 'assets/bear_2.riv';

    try {
      final data = await rootBundle.load(animationURL);
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      // ... (remaining parsing logic from initState can go here)

      stateMachineController =
          StateMachineController.fromArtboard(artboard, "State Machine 1");
      if (stateMachineController != null) {
        artboard.addController(stateMachineController!);

        for (var e in stateMachineController!.inputs) {
          debugPrint(e.runtimeType.toString());
          debugPrint("name${e.name}End");
        }

        for (var element in stateMachineController!.inputs) {
          if (element.name == "success") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "fail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "Check") {
            isChecking = element as SMIBool;
          } else if (element.name == "Talk") {
            isTalking = element as SMIBool;
          } else if (element.name == "Hear") {
            isHearing = element as SMIBool;
          } else if (element.name == "Look") {
            numLook = element as SMINumber;
          }
        }
      }

      _secondTeddyArtboard = artboard;
      notifyListeners();
    } catch (error) {
      print('Error loading animation: $error');
    }
  }

  // Method to change the isChecking and isHandsUp booleans to false
  void resetBooleans() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    notifyListeners();
  }

  // Method to trigger success
  void triggerSuccess() {
    successTrigger?.fire();
    notifyListeners();
  }

  // Method to trigger failure
  void triggerFailure() {
    failTrigger?.fire();
    notifyListeners();
  }

  Future<String> makeGptApiCall(
      {required String userContent, required String prompt}) async {
    try {
      final String response = await AzureApi()
          .makeGptApiCall(userContent: userContent, prompt: prompt);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> makeWhisperApiCall({required String recordedUrl}) async {
    try {
      final String response =
          await AzureApi().makeWhisperApiCall(recordedUrl: recordedUrl);
      whatYouSaid = response;
      notifyListeners();
      String messageContent = await makeGptApiCall(
          userContent: response,
          prompt:
              "You are an AI assistant that helps people speak things in a better more articulate way using simple plain words.");
      triggerSuccess();
      youCouldHavesaid = messageContent;
      notifyListeners();
      return messageContent;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> makePractiseWhisperApiCall(
      {required String recordedUrl}) async {
    try {
      final String response =
          await AzureApi().makeWhisperApiCall(recordedUrl: recordedUrl);
      yourAnswer = response;
      usedWord = yourAnswer.split(' ').contains('replicate');
      notifyListeners();
      String messageContent = await makeGptApiCall(
          userContent: response,
          prompt:
              "You are an AI assistant that helps people speak things in a better more articulate way using simple plain words.");
      betterAnswer = messageContent;
      notifyListeners();
      return messageContent;
    } catch (e) {
      rethrow;
    }
  }
}
