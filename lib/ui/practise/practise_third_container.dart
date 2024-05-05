// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:wizskills/provider/speak_provider.dart';
// import 'package:appinio_video_player/appinio_video_player.dart';

// class PractiseThirdContainer extends StatefulWidget {
//   const PractiseThirdContainer({super.key});

//   @override
//   State<PractiseThirdContainer> createState() => _PractiseThirdContainerState();
// }

// class _PractiseThirdContainerState extends State<PractiseThirdContainer> {
//   String tempSelectedText = '';
//   late CustomVideoPlayerController _customVideoPlayerController;
//   String assetVideoPath = "assets/aiAssistant.mp4";

//   @override
//   void initState() {
//     super.initState();
//     CachedVideoPlayerController videoPlayerController;
//     videoPlayerController = CachedVideoPlayerController.asset(
//       assetVideoPath,
//     )..initialize().then((value) => setState(() {}));
//     _customVideoPlayerController = CustomVideoPlayerController(
//       context: context,
//       videoPlayerController: videoPlayerController,
//     );

//     // _customVideoPlayerWebController = CustomVideoPlayerWebController(
//     //   webVideoPlayerSettings: _customVideoPlayerWebSettings,
//     // );
//   }

//   @override
//   void dispose() {
//     _customVideoPlayerController.dispose();
//     super.dispose();
//   }

//   String checkWordOrPhrase(String text) {
//     // Split the text into words
//     List<String> words = text.split(' ');
//     // If there is only one word, it's a word; otherwise, it's a phrase
//     if (words.length == 1) {
//       return 'Add Word';
//     } else {
//       return 'Add Phrase';
//     }
//   }
// // ----------------------------- UI --------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     final speakProvider = Provider.of<SpeakProvider>(context);
//     Widget makeBody() {
//       return SizedBox(
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Verb conjugation in the',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                       color: speakProvider.usedWord != null
//                           ? (speakProvider.usedWord!
//                               ? Colors.green
//                               : Colors.red)
//                           : Colors.black,
//                     ),
//                   ),
//                   Text(
//                     'past tense',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                       color: speakProvider.usedWord != null
//                           ? (speakProvider.usedWord!
//                               ? Colors.green
//                               : Colors.red)
//                           : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               CustomVideoPlayer(
//                 customVideoPlayerController: _customVideoPlayerController,
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: kIsWeb ? 600 : null,
//                   margin: const EdgeInsets.only(bottom: 15 * 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Use the verb "to see"',
//                           style: TextStyle(
//                             fontSize: 12,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Divider(),

//                         // Text(youCouldHavesaid),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return makeBody();
//   }
// }
