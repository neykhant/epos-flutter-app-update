import 'dart:ui' as ui;

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart';
import 'package:provider/provider.dart';

import '../../toast.dart';
import '../components/elements/my_button.dart';
import '../components/modules/my_app_bar.dart';
import '../models/credit_model.dart';
import '../models/shop_model.dart';
import '../providers/shop_provider.dart';
import 'big_invoice.dart';

class BigPrintScreen extends StatefulWidget {
  final List<dynamic> singles;
  final String name;
  final String total;
  final String extraCharges;
  final double discount;
  final dynamic finalTotal;
  final String paid;
  final dynamic credit;
  final String invoiceNumber;
  final String createdAt;
  final bool isBuy;
  final List<CreditModel>? credits;

  const BigPrintScreen({
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
    required this.createdAt,
    required this.isBuy,
    this.credits,
  }) : super(key: key);

  @override
  _BigPrintScreenState createState() => _BigPrintScreenState();
}

class _BigPrintScreenState extends State<BigPrintScreen> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  bool connected = false;
  List availableBluetoothDevices = [];

  Future<void> getBluetooth() async {
    final List? bluetooth = await BluetoothThermalPrinter.getBluetooths;
    setState(() {
      availableBluetoothDevices = bluetooth!;
    });
  }

  Future<void> setConnect(String mac) async {
    // print('setConnect');
    final String? result = await BluetoothThermalPrinter.connect(mac);
    if (result == "true") {
      setState(() {
        connected = true;
      });
    }
  }

  Future<void> printTicket(String shopName) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(shopName);
      await BluetoothThermalPrinter.writeBytes(bytes);
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getTicket(String shopName) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // ByteData data = await rootBundle.load('assets/images/escape.jpg');
    // final unit8Lint = data.buffer.asUint8List();
    // final result = decodeImage(unit8Lint);

    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final invoice = byteData!.buffer.asUint8List();
    final invoiceResult = decodeImage(invoice);

    // bytes += generator.image(result!);
    // bytes += generator.hr(len: 70);

    // bytes += generator.text(shopName,
    //     styles: const PosStyles(
    //       align: PosAlign.center,
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ),
    //     linesAfter: 1);

    bytes += generator.image(invoiceResult!);

    bytes += generator.hr(len: 70);

    bytes += generator.text(
      'Thank You, See You Again!!!',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopInfoProvider = Provider.of<ShopProvider>(context);
    ShopModel? shopModel = shopInfoProvider.shop;

    String shopName = shopModel?.shopName ?? '-';
    String phoneNoOne = shopModel?.phoneNoOne ?? '-';
    String phoneNoTwo = shopModel?.phoneNoTwo ?? '-';
    String address = shopModel?.address ?? '-';

    List<String> metadata = [
      shopName,
      address,
      phoneNoOne,
      phoneNoTwo,
    ];

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MyAppBar(
        title: localizations.printer_screen,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyButton(
                label: localizations.search_printer,
                fontSize: 14.0, //16
                onPressed: getBluetooth,
                primary: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: availableBluetoothDevices.isNotEmpty
                      ? availableBluetoothDevices.length
                      : 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        String select = availableBluetoothDevices[index];
                        List list = select.split("#");
                        // String name = list[0];
                        String mac = list[1];
                        showToast(
                            context, localizations.printer_connect_message);
                        await setConnect(mac);
                      },
                      title: Text('${availableBluetoothDevices[index]}'),
                      subtitle: Text(localizations.printer_connect),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                label: localizations.print_receipt,
                fontSize: 14.0, //16
                onPressed: () async {
                  showToast(context, 'Please wait...');
                  await printTicket(shopName);
                },
                primary: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                height: 10,
              ),
              RepaintBoundary(
                key: globalKey,
                child: BigInvoice(
                  singles: widget.singles,
                  metadata: metadata,
                  invoiceNumber: widget.invoiceNumber,
                  total: widget.total,
                  extraCharges: widget.extraCharges,
                  discount: widget.discount,
                  finalTotal: widget.finalTotal,
                  paid: widget.paid,
                  credit: widget.credit,
                  name: widget.name,
                  createdAt: widget.createdAt,
                  credits: widget.credits,
                  isBuy: widget.isBuy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
