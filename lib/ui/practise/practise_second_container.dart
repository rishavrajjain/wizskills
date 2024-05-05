import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive_lib;

import 'package:wizskills/provider/speak_provider.dart';
import 'package:wizskills/ui/practise/components/chat_bubble.dart';

class PractiseSecondContainer extends StatefulWidget {
  const PractiseSecondContainer({super.key});

  @override
  State<PractiseSecondContainer> createState() =>
      _PractiseSecondContainerState();
}

class _PractiseSecondContainerState extends State<PractiseSecondContainer> {
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
// ----------------------------- UI --------------------------------------------

  @override
  Widget build(BuildContext context) {
    final speakProvider = Provider.of<SpeakProvider>(context);
    Widget makeBody() {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Verb conjugation in the',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: speakProvider.usedWord != null
                          ? (speakProvider.usedWord!
                              ? Colors.green
                              : Colors.red)
                          : Colors.black,
                    ),
                  ),
                  Text(
                    'past tense',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: speakProvider.usedWord != null
                          ? (speakProvider.usedWord!
                              ? Colors.green
                              : Colors.red)
                          : Colors.black,
                    ),
                  ),
                  // const Text(
                  //   'to feel respect and approval for (someone/something)',
                  //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  // ),
                  InkWell(
                    onTap: () {
                      speakProvider.startTalking();
                    },
                    child: const SizedBox(
                      height: 24,
                      width: 150,
                    ),
                  ),
                ],
              ),
              if (speakProvider.teddyArtboard != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: rive_lib.Rive(
                            artboard: speakProvider.teddyArtboard!,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: rive_lib.Rive(
                          artboard: speakProvider.secondTeddyArtboard!,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ],
                ),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Use the verb "to see"',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        ChatBubble(
                          message: 'Hey, did you watch the game last night?',
                          isMe: false,
                        ),
                        ChatBubble(
                          message:
                              'Yeah, I watched it. The team played really well.',
                          isMe: true,
                        )

                        // Text(youCouldHavesaid),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return makeBody();
  }
}
