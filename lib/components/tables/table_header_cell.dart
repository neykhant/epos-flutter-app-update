import 'package:flutter/material.dart';
import '../../utility_methods.dart';

class TableHeadingCell extends StatelessWidget {
  const TableHeadingCell({
    Key? key,
    required this.label,
    this.borderRadius,
    this.tableHeight = 90.0,
    this.fontSize = 18.0,
  }) : super(key: key);

  final String label;
  final BorderRadiusGeometry? borderRadius;
  final double fontSize;
  final double tableHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: borderRadius,
      ),
      height: tableHeight,
      child: Center(
        child: Text(
          label,
          style: kTextStyle(size: fontSize).copyWith(
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
      ),
    );
  }
}
