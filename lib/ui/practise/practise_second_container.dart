import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive_lib;

import 'package:wizskills/provider/speak_provider.dart';

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
              if (speakProvider.teddyArtboard != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
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
                            artboard: speakProvider.secondTeddyArtboard!,
                            fit: BoxFit.fitWidth,
                          ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          speakProvider.yourAnswer,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        SelectableText(
                          textAlign: TextAlign.center,
                          speakProvider.betterAnswer,
                          style: const TextStyle(fontSize: 14),
                          onSelectionChanged: (selection, cause) async {
                            // Store the selected text when selection changes
                            if (kIsWeb) {
                              await BrowserContextMenu.disableContextMenu();
                            }

                            setState(() {
                              tempSelectedText =
                                  speakProvider.youCouldHavesaid.substring(
                                selection.base.offset,
                                selection.extent.offset,
                              );
                            });
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
                                      speakProvider
                                          .addToSelectedText(tempSelectedText);
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
            ],
          ),
        ),
      );
    }

    return makeBody();
  }
}
