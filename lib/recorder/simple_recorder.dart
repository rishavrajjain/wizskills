import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:wizskills/classes/speak_provider.dart';
import 'package:audio_session/audio_session.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class SimpleRecorder extends StatefulWidget {
  const SimpleRecorder({super.key});

  @override
  State<SimpleRecorder> createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String recordedUrl = 'tau_file.mp4';
  final selectedText = [];
  String tempSelectedText = '';

  String checkWordOrPhrase(String text) {
    // Split the text into words
    List<String> words = text.split(' ');
    // If there is only one word, it's a word; otherwise, it's a phrase
    if (words.length == 1) {
      return 'Add Word';
    } else {
      return 'Add Phrase';
    }
  }

  @override
  void initState() {
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
      setState(() {});
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    //makeApiCall(_mPath);
    print('path is $_mPath');
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
        print('@@@@@@@ path : -------- $recordedUrl');
        speakProvider.makeWhisperApiCall(recordedUrl: recordedUrl);

        _mplaybackReady = true;
      });
    });
  }

  _Fn? getRecorderFn(SpeakProvider speakProvider) {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    print('11111@@@@@@@ ${_mRecorder!.isStopped}');
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

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

// ----------------------------- UI --------------------------------------------

  @override
  Widget build(BuildContext context) {
    final speakProvider = Provider.of<SpeakProvider>(context);
    Widget makeBody() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              alignment: Alignment.center,
              width: kIsWeb ? 600 : null,
              margin: const EdgeInsets.only(bottom: 15 * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      speakProvider.whatYouSaid,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    SelectableText(
                      textAlign: TextAlign.center,
                      speakProvider.youCouldHavesaid,
                      style: const TextStyle(fontSize: 14),
                      onSelectionChanged: (selection, cause) async {
                        // Store the selected text when selection changes

                        await BrowserContextMenu.disableContextMenu();
                        setState(() {
                          tempSelectedText =
                              speakProvider.youCouldHavesaid.substring(
                            selection.base.offset,
                            selection.extent.offset,
                          );
                        });
                        print('Selected text: $tempSelectedText');
                      },
                      contextMenuBuilder: (context, editableTextState) {
                        return AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: editableTextState.contextMenuAnchors,
                          buttonItems: [
                            ContextMenuButtonItem(
                              onPressed: () {
                                // Check if text is selected
                                if (tempSelectedText.isNotEmpty) {
                                  // Print the selected word
                                  print('Selected word: $tempSelectedText');
                                  selectedText.add(tempSelectedText);
                                }
                                editableTextState.hideToolbar();
                              },
                              label: checkWordOrPhrase(tempSelectedText),
                            )
                          ],
                        );
                      },
                    )

                    // Text(youCouldHavesaid),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            // height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Column(
              children: [
                Row(children: [
                  ElevatedButton(
                    onPressed: getRecorderFn(speakProvider),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(_mRecorder!.isRecording
                      ? 'Recording in progress'
                      : 'Recorder is stopped'),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  ElevatedButton(
                    onPressed: getPlaybackFn(),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(_mPlayer!.isPlaying
                      ? 'Playback in progress'
                      : 'Player is stopped'),
                ]),
              ],
            ),
          ),
          Row(
            children: selectedText
                .map(
                  (str) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(str),
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    return makeBody();
  }
}
