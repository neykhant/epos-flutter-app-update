import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../datetime_util.dart';
import '../../models/item_transfer_model.dart';

class InvoiceItemTransfer extends StatelessWidget {
  final ItemTransferModel? itemTransfer;
  final String fromShopName;

  const InvoiceItemTransfer({
    Key? key,
    this.itemTransfer,
    required this.fromShopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Container(
      width: 340.0,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            '$fromShopName -> ${itemTransfer!.shop.shopName}',
            style: kInvoiceTextStyle(18.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          Table(
            border: const TableBorder(
              horizontalInside: BorderSide(
                width: 0.5,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            columnWidths: const {
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  TableHeadingCell(
                    label: localizations.item_name,
                    customTextAlign: TextAlign.left,
                  ),
                  TableHeadingCell(
                    label: localizations.invoice_quantity,
                    customTextAlign: TextAlign.center,
                  ),
                  TableHeadingCell(
                    label: localizations.date,
                    customTextAlign: TextAlign.left,
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCellWidget(
                    child: Text(
                      itemTransfer!.item.itemName,
                      textAlign: TextAlign.left,
                      style: kInvoiceTextStyle(16.0),
                    ),
                  ),
                  TableCellWidget(
                    child: Text(
                      '${itemTransfer!.quantity}',
                      textAlign: TextAlign.center,
                      style: kInvoiceTextStyle(16.0),
                    ),
                  ),
                  TableCellWidget(
                    child: Text(
                      convertDateToLocal(itemTransfer!.createdAt),
                      textAlign: TextAlign.left,
                      style: kInvoiceTextStyle(16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle kInvoiceTextStyle(double fontSize) {
  return TextStyle(
    // fontFamily: 'Padauk',
    fontFamily: 'Pyidaungsu',
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}

class TableCellWidget extends StatelessWidget {
  const TableCellWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: child,
    );
  }
}

class TableHeadingCell extends StatelessWidget {
  const TableHeadingCell(
      {Key? key, required this.label, this.customTextAlign = TextAlign.center})
      : super(key: key);

  final String label;
  final TextAlign customTextAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39.0,
      child: Text(
        label,
        textAlign: customTextAlign,
        style: const TextStyle(
          // fontFamily: 'Padauk',
          fontFamily: 'Pyidaungsu',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class MyInvoiceTextWidget extends StatelessWidget {
  final String text;
  MyInvoiceTextWidget({Key? key, required this.text}) : super(key: key);

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
    return Text(
      formattedText,
      style: kInvoiceTextStyle(18.0).copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    );
  }
}
