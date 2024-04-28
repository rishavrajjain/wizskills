import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:wizskills/recorder/simple_recorder.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:wizskills/classes/speak_provider.dart';

void main() {
  runApp(
    // Wrap your MaterialApp with Provider
    ChangeNotifierProvider(
      create: (context) => SpeakProvider(), // Initialize SpaekProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late String animationURL;
  Artboard? _teddyArtboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isChecking, isTalking, isHearing;
  SMINumber? numLook;

  StateMachineController? stateMachineController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationURL = defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/bear_1.riv'
        : 'assets/bear_1.riv';
    print('hahahha');
    rootBundle.load(animationURL).then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        stateMachineController =
            StateMachineController.fromArtboard(artboard, "State Machine 1");
        print('ok $stateMachineController');
        if (stateMachineController != null) {
          print('ok');
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

        setState(() => _teddyArtboard = artboard);
      },
    );
  }

  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void moveEyeBalls(val) {
    numLook?.change(val.length.toDouble());
  }

  void login() {
    print('object');
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (_emailController.text == "admin" &&
        _passwordController.text == "admin") {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff5F9EA0),
              ),
              child: Column(
                children: [
                  Text(
                    'Streak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Center(
                      child: RiveAnimation.asset(
                        'assets/sparky.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.spatial_audio_off_rounded),
              title: const Text('Practise'),
              onTap: () {
                // Add functionality for Item 1 here
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_rounded),
              title: const Text('Community'),
              onTap: () {
                // Add functionality for Item 2 here
              },
            ),
            // Add more ListTiles for additional items
          ],
        ),
      ),
      appBar: AppBar(
//        backgroundColor: Colors.transparent,
        backgroundColor: const Color(0xffd6e2ea),
        elevation: 0,
      ),
      backgroundColor: const Color(0xffd6e2ea),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_teddyArtboard != null)
            SizedBox(
              width: 400,
              height: 300,
              child: Rive(
                artboard: _teddyArtboard!,
                fit: BoxFit.fitWidth,
              ),
            ),
          const SimpleRecorder(),
          // const SimpleRecorder()
        ],
      ),
    );
  }
}
