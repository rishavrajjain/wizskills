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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SpeakProvider>(context, listen: false).loadAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final speak = Provider.of<SpeakProvider>(context);
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
          if (speak.teddyArtboard != null)
            SizedBox(
              width: 400,
              height: 300,
              child: Rive(
                artboard: speak.teddyArtboard!,
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
