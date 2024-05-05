import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PronunciationCard extends StatefulWidget {
  const PronunciationCard({
    super.key,
  });

  @override
  State<PronunciationCard> createState() => _PronunciationCardState();
}

class _PronunciationCardState extends State<PronunciationCard> {
  bool isExpanded = false;
  //final bool _isChecked = false;
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
      dense: true,
      horizontalTitleGap: 12.0,
      minLeadingWidth: 0,
      shape: RoundedRectangleBorder(
          borderRadius: isExpanded
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))
              : const BorderRadius.all(Radius.circular(15)),
          side: const BorderSide(
            color: Colors.white,
          )),
      child: ExpansionTile(
        iconColor: Colors.black,
        tilePadding: const EdgeInsets.only(left: 16, right: 16),
        childrenPadding: const EdgeInsets.all(0),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            side: BorderSide(
              color: Color(0xFFFAF0E6),
            )),
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text(
          'Scores',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: 0.8,
                  center: const Text("80%"),
                  progressColor: Colors.green[700],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pronunciation Score',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Accuracy Score: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('98/100   '),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Fluency Score: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('98/100'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: 0.8,
                  center: const Text("53%"),
                  progressColor: Colors.red[700],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Content Score',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Vocabulary Score: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('54/100'),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Grammar Score: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('46/100'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // LinearPercentIndicator(
          //   barRadius: const Radius.circular(20),
          //   width: 100.0,
          //   lineHeight: 8.0,
          //   percent: 0.9,
          //   progressColor: Colors.green,
          // ),
        ],
      ),
    );
  }
}
