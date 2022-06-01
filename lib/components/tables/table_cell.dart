import 'package:flutter/material.dart';

class TableCellWidget extends StatelessWidget {
  const TableCellWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Center(
        //padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
