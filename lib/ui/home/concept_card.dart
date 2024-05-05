import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class ConceptsCard extends StatefulWidget {
  const ConceptsCard({
    super.key,
  });

  @override
  State<ConceptsCard> createState() => _ConceptsCardState();
}

class _ConceptsCardState extends State<ConceptsCard> {
  bool isExpanded = false;
  bool _isChecked = false;
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
          'Concepts',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: Colors.green,
                focusColor: Colors.green,
                checkColor: Colors.white,
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0XFFE5DAE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Verb conjugation in the past tense.',
                    style: TextStyle(color: Colors.pink[900]),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 12, right: 8),
            child: Text(
                'Verb conjugation in the past tense involves changing the verb form to indicate actions or states that occurred in the past.',
                style: TextStyle(color: Colors.black, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
