import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../datetime_util.dart';
import '../models/credit_model.dart';

class BigInvoice extends StatelessWidget {
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
  const BigInvoice({
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

      int id = 0;
      for (dynamic item in singles) {
        id++;
        tableRows.add(
          TableRow(
            children: <Widget>[
              TableCellWidget(
                child: Text(
                  '$id',
                  style: kInvoiceTextStyle(8.0),
                  textAlign: TextAlign.left,
                ),
              ),
              TableCellWidget(
                child: Text(
                  isBuy ? item.item.itemName : item.stock.itemModel.itemName,
                  style: kInvoiceTextStyle(8.0)
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${item.itemPrice}',
                  style: kInvoiceTextStyle(8.0),
                  textAlign: TextAlign.right,
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${item.quantity}',
                  style: kInvoiceTextStyle(8.0),
                  textAlign: TextAlign.right,
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${item.totalPrice}',
                  style: kInvoiceTextStyle(8.0),
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
                  style: kInvoiceTextStyle(8.0)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TableCellWidget(
                child: Text(
                  '${credit.amount}',
                  style: kInvoiceTextStyle(8.0),
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
      width: 250.0,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            convertDateToLocal(createdAt),
            style: kInvoiceTextStyle(8.7),
          ),
          Text(
            metadata[0],
            style: kInvoiceTextStyle(8.7),
            textAlign: TextAlign.center,
          ),
          Text(
            metadata[1],
            style: kInvoiceTextStyle(8.7),
            textAlign: TextAlign.center,
          ),
          Text(
            '${metadata[2]}, ${metadata[3]}',
            style: kInvoiceTextStyle(8.7),
            textAlign: TextAlign.center,
          ),
          isBuy
              ? Text(
                  '${localizations.merchant_name}-$name',
                  style: kInvoiceTextStyle(8.7),
                  textAlign: TextAlign.center,
                )
              : Text(
                  '${localizations.customer_name}-$name',
                  style: kInvoiceTextStyle(8.7),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${localizations.items} - ${singles.length}',
                style: kInvoiceTextStyle(8.7),
                textAlign: TextAlign.left,
              ),
              Text(
                '${localizations.invoice_number} - $invoiceNumber',
                style: kInvoiceTextStyle(8.7),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.8,
            height: 2.5,
          ),
          Table(
            // border: TableBorder.symmetric(
            //   outside: BorderSide.none,
            //   inside: const BorderSide(
            //       width: 1, color: Colors.grey, style: BorderStyle.solid),
            // ),
            // border: TableBorder(
            //   top: BorderSide(color: Colors.blue, width: 1),
            //   bottom: BorderSide(color: Colors.blue, width: 1),
            // ),
            border: TableBorder(
                horizontalInside: BorderSide(
                    width: 0.3, color: Colors.black, style: BorderStyle.solid)),
            // border: const TableBorder(
            //   horizontalInside: BorderSide(
            //     width: 1.0,
            //     color: Colors.black,
            //     style: BorderStyle.none,
            //   ),
            // ),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.5)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  const TableHeadingCell(
                    label: '#',
                    customTextAlign: TextAlign.left,
                  ),
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
            thickness: 0.8,
            height: 2.5,
          ),
          const SizedBox(height: 8.0),
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
                          '${localizations.total} ',
                          style: kInvoiceTextStyle(8.0).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          total,
                          style: kInvoiceTextStyle(8.0).copyWith(
                            fontWeight: FontWeight.w500,
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
                                '${localizations.discount}($discount) ',
                                style: kInvoiceTextStyle(8.0).copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                discountAmount.toStringAsFixed(2),
                                style: kInvoiceTextStyle(8.0).copyWith(
                                  fontWeight: FontWeight.w500,
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
                                '${localizations.final_total} ',
                                style: kInvoiceTextStyle(8.0).copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$finalTotal',
                                style: kInvoiceTextStyle(8.0).copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${localizations.paid_price} ',
                          style: kInvoiceTextStyle(8.0).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          paid,
                          style: kInvoiceTextStyle(8.0).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${localizations.credit} ',
                          style: kInvoiceTextStyle(8.0).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          credit,
                          style: kInvoiceTextStyle(8.0).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
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
                      style: kInvoiceTextStyle(8.0),
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
                      color: Colors.red,
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
        vertical: 2.5,
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
      height: 20.0,
      child: Text(
        label,
        textAlign: customTextAlign,
        style: const TextStyle(
          // fontFamily: 'Padauk',
          fontFamily: 'Pyidaungsu',
          fontSize: 8.0, //10
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}

//for header

// headerRow(List<dynamic> titleRowData) {
//   return Container(
//     // height: ScreenUtil().setHeight(100),
//     height: 100,
//     child: Row(
//       children: /* Add header cell data dynamically */,
//     ),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(10),
//         topRight: Radius.circular(10),
//       ),
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         stops: [0, 1],
//         colors: [],
//       ),
//     ),
//   );
// }
