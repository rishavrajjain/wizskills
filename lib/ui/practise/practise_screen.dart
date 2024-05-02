import 'package:flutter/material.dart';
import 'package:wizskills/ui/home/home_screen.dart';
import 'package:wizskills/provider/speak_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive_lib;

class PractiseScreen extends StatefulWidget {
  const PractiseScreen({super.key});

  @override
  State<PractiseScreen> createState() => _PractiseScreenState();
}

class _PractiseScreenState extends State<PractiseScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SpeakProvider>(context, listen: false).loadAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final speakProvider = Provider.of<SpeakProvider>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFB0E0E6),
                    Color(0xFF5F9EA0),
                  ], // Replace with your desired gradient colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: rive_lib.RiveAnimation.asset(
                        'assets/sparky.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Daily practice\nboosts streak!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                // Add functionality for Item 2 here
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.spatial_audio_off_rounded,
                color: Color(0xFF5F9EA0),
              ),
              title: const Text(
                'Practise',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PractiseScreen()),
                );
                // Add functionality for Item 1 here
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
        children: speakProvider.selectedText
            .map(
              (str) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(str),
              ),
            )
            .toList(),
      ),
    );
  }
}
