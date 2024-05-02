import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:wizskills/provider/speak_provider.dart';



class RecordedTextContainer extends StatefulWidget {
  const RecordedTextContainer({super.key});

  @override
  State<RecordedTextContainer> createState() => _RecordedTextContainerState();
}

class _RecordedTextContainerState extends State<RecordedTextContainer> {
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
      );
    }

    return makeBody();
  }
}
