import 'package:flutter/material.dart';
import '../../utility_methods.dart';

class MyTextWidget extends StatelessWidget {
  final double fontSize;
  final String text;
  final bool money;
  MyTextWidget({
    Key? key,
    required this.text,
    this.fontSize = 18.0,
    this.money = true,
  }) : super(key: key);

  final List<String> _myanmarNumbers = [
    '၀',
    '၁',
    '၂',
    '၃',
    '၄',
    '၅',
    '၆',
    '၇',
    '၈',
    '၉',
  ];

  final List<String> _tempNumbers = [];
  final List<int> _toAddComma = [
    2,
    5,
    8,
    11,
    14,
    17,
    20,
    23,
    26,
    29,
    32,
  ];

  @override
  Widget build(BuildContext context) {
    List<String> reversedTempNumbers = [];
    String formattedText = '';
    if (int.tryParse(text.trim()) != null) {
      for (int i = 0; i < text.length; i++) {
        _tempNumbers.add(text[i]);
      }
      reversedTempNumbers = _tempNumbers.reversed.toList();
      for (var i = _tempNumbers.length - 1; i >= 0; i--) {
        if (_toAddComma.contains(i)) {
          formattedText += ',';
        }
        formattedText += _myanmarNumbers[int.parse(reversedTempNumbers[i])];
      }
      if (formattedText[0] == ',') {
        formattedText = formattedText.substring(1, formattedText.length);
      }
    }
    String usedText = money ? '$formattedText ကျပ်' : '$formattedText ခု';
    return Text(
      usedText,
      style: kTextStyle(size: fontSize),
    );
  }
}
