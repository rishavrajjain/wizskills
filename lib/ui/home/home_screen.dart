import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive_lib;
import 'package:wizskills/ui/home/concept_card.dart';
import 'package:wizskills/ui/home/pronunciation_card.dart';
import 'package:wizskills/ui/practise/practise_screen.dart';
import 'package:wizskills/ui/home/recorded_text_container.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:wizskills/provider/speak_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

const theSource = AudioSource.microphone;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String recordedUrl = 'tau_file.mp4';
  String tempSelectedText = '';

  @override
  void initState() {
    Provider.of<SpeakProvider>(context, listen: false).loadAnimation();
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {

      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  void stopRecorder(SpeakProvider speakProvider) async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        recordedUrl = value!;
        speakProvider.makeWhisperApiCall(recordedUrl: recordedUrl);

        _mplaybackReady = true;
      });
    });
  }

  void Function()? getRecorderFn(SpeakProvider speakProvider) {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped
        ? () {
            speakProvider.startHearing();
            record();
          }
        : () async {
            stopRecorder(speakProvider);
            speakProvider.stopHearing();
          };
  }

  void Function()? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
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
                Icons.home_rounded,
                color: Color(0xFF5F9EA0),
              ),
              title: const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                // Add functionality for Item 2 here
              },
            ),
            ListTile(
              leading: const Icon(Icons.spatial_audio_off_outlined),
              title: const Text('Practise'),
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
      bottomNavigationBar: Container(
        // margin: const EdgeInsets.all(3),
        // padding: const EdgeInsets.all(3),
        // height: 80,
        width: double.infinity,
        //alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFFAF0E6),
          // border: Border.all(
          //   color: Colors.indigo,
          //   width: 3,
          // ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              ElevatedButton(
                onPressed: getRecorderFn(speak),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Icon(
                  _mRecorder!.isRecording ? Icons.stop : Icons.mic_rounded,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(_mRecorder!.isRecording
                  ? 'Recording...'
                  : 'Recorder Stopped'),
            ]),
            const SizedBox(
              height: 36,
            ),
            // Row(children: [
            //   ElevatedButton(
            //     onPressed: getPlaybackFn(),
            //     //color: Colors.white,
            //     //disabledColor: Colors.grey,
            //     child: Icon(_mPlayer!.isPlaying
            //         ? Icons.stop
            //         : Icons.play_arrow_rounded),
            //   ),
            //   const SizedBox(
            //     width: 20,
            //   ),
            //   Text(_mPlayer!.isPlaying
            //       ? 'Playback in progress'
            //       : 'Player is stopped'),
            // ]),
          ],
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (speak.teddyArtboard != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(''),
                SizedBox(
                  width: 380,
                  height: 300,
                  child: rive_lib.Rive(
                    artboard: speak.teddyArtboard!,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const Text(''),
              ],
            ),
          const RecordedTextContainer(),
          Visibility(
            visible: speak.showConcepts,
            child: const Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: PronunciationCard(),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConceptsCard(),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
