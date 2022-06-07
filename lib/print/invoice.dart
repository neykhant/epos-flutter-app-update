import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../datetime_util.dart';
import '../models/credit_model.dart';

class Invoice extends StatelessWidget {
  final List<dynamic> singles;
  final String name;
  final String total;
  final String extraCharges;
  final double discount;
  final dynamic finalTotal;
  final String paid;
  final dynamic credit;
  final String invoiceNumber;
  final List<String> metadata;
  final String createdAt;
  final bool isBuy;
  final List<CreditModel>? credits;
  const Invoice({
    Key? key,
    required this.singles,
    required this.name,
    required this.total,
    required this.extraCharges,
    required this.discount,
    required this.finalTotal,
    required this.paid,
    required this.credit,
    required this.invoiceNumber,
    required this.metadata,
    required this.createdAt,
    required this.isBuy,
    this.credits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    List<TableRow> _showInvoiceTableRow(BuildContext context) {
      List<TableRow> tableRows = [];

      for (dynamic item in singles) {
        tableRows.add(
          TableRow(
            children: <Widget>[
              TableCellWidget(
                child: Text(
                  isBuy ? item.item.itemName : item.stock.itemModel.itemName,
                  style: kInvoiceTextStyle(16.0)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${item.itemPrice}',
                  style: kInvoiceTextStyle(16.0),
                  textAlign: TextAlign.right,
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${item.quantity}',
                  style: kInvoiceTextStyle(16.0),
                  textAlign: TextAlign.right,
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${item.totalPrice}',
                  style: kInvoiceTextStyle(16.0),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }

      return tableRows;
    }

    List<TableRow> _showCreditTableRow(BuildContext context) {
      List<TableRow> tableRows = [];

      for (CreditModel credit in credits!) {
        tableRows.add(
          TableRow(
            children: <Widget>[
              TableCellWidget(
                child: Text(
                  convertDateToLocal(credit.createdAt),
                  style: kInvoiceTextStyle(16.0)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${credit.amount}',
                  style: kInvoiceTextStyle(16.0),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }

      return tableRows;
    }

    double discountAmount = finalTotal * (discount / 100);

    return Container(
      width: 340.0,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            convertDateToLocal(createdAt),
            style: kInvoiceTextStyle(18.0),
          ),
          Text(
            metadata[0],
            style: kInvoiceTextStyle(18.0),
            textAlign: TextAlign.center,
          ),
          Text(
            metadata[1],
            style: kInvoiceTextStyle(18.0),
            textAlign: TextAlign.center,
          ),
          Text(
            metadata[2],
            style: kInvoiceTextStyle(18.0),
            textAlign: TextAlign.center,
          ),
          Text(
            metadata[3],
            style: kInvoiceTextStyle(18.0),
            textAlign: TextAlign.center,
          ),

          //for brother shop no paid to sell

          // isBuy
          //     ? Text(
          //         '${localizations.merchant_name}-$name',
          //         style: kInvoiceTextStyle(18.0),
          //         textAlign: TextAlign.center,
          //       )
          //     : Text(
          //         '${localizations.customer_name}-$name',
          //         style: kInvoiceTextStyle(18.0),
          //         textAlign: TextAlign.center,
          //       ),

          //for brother shop no paid to sell end

          Text(
            '${localizations.items} - ${singles.length}',
            style: kInvoiceTextStyle(18.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${localizations.invoice_number} - $invoiceNumber',
                style: kInvoiceTextStyle(18.0),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
          Table(
            border: const TableBorder(
              horizontalInside: BorderSide(
                width: 1.0,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  TableHeadingCell(
                    label: localizations.items,
                    customTextAlign: TextAlign.left,
                  ),
                  TableHeadingCell(
                    label: localizations.price,
                    customTextAlign: TextAlign.right,
                  ),
                  TableHeadingCell(
                    label: localizations.invoice_quantity,
                    customTextAlign: TextAlign.right,
                  ),
                  TableHeadingCell(
                    label: localizations.total,
                    customTextAlign: TextAlign.right,
                  ),
                ],
              ),
              ..._showInvoiceTableRow(context),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${localizations.total} :',
                          style: kInvoiceTextStyle(18.0).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          total,
                          style: kInvoiceTextStyle(18.0).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       '${localizations.extra_charges} :',
                    //       style: kInvoiceTextStyle(18.0).copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Text(
                    //       extraCharges,
                    //       style: kInvoiceTextStyle(18.0).copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.right,
                    //     ),
                    //   ],
                    // ),
                    isBuy
                        ? Container()
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${localizations.discount}($discount) :',
                                style: kInvoiceTextStyle(18.0).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                discountAmount.toStringAsFixed(2),
                                style: kInvoiceTextStyle(18.0).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                    isBuy
                        ? Container()
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${localizations.final_total} :',
                                style: kInvoiceTextStyle(18.0).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$finalTotal',
                                style: kInvoiceTextStyle(18.0).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                    // for Brother shop details
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       '${localizations.paid_price} :',
                    //       style: kInvoiceTextStyle(18.0).copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Text(
                    //       paid,
                    //       style: kInvoiceTextStyle(18.0).copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.right,
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       '${localizations.credit} :',
                    //       style: kInvoiceTextStyle(18.0).copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Text(
                    //       credit,
                    //       style: kInvoiceTextStyle(18.0).copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.right,
                    //     ),
                    //   ],
                    // ),

                    // for Brother shop details end
                  ],
                ),
              )
            ],
          ),
          credits == null || credits!.isEmpty
              ? Container()
              : Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Text(
                      localizations.credits,
                      style: kInvoiceTextStyle(18.0),
                    ),
                    const SizedBox(height: 7.0),
                    Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        3: FlexColumnWidth(1)
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            TableHeadingCell(
                              label: localizations.date,
                              customTextAlign: TextAlign.left,
                            ),
                            TableHeadingCell(
                              label: localizations.amount,
                              customTextAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        ..._showCreditTableRow(context),
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
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
