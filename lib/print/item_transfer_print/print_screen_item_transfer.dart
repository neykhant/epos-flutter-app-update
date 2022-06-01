import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/elements/my_button.dart';
import '../../components/modules/my_app_bar.dart';
import '../../models/item_transfer_model.dart';
import '../../models/shop_model.dart';
import '../../print/item_transfer_print/invoice_item_transfer.dart';
import '../../providers/shop_provider.dart';
import '../../utility_methods.dart';
import '../print_util.dart';

class PrintScreenItemTransfer extends StatefulWidget {
  final ItemTransferModel? itemTransfer;
  const PrintScreenItemTransfer({
    Key? key,
    this.itemTransfer,
  }) : super(key: key);
  @override
  _PrintScreenItemTransferState createState() =>
      _PrintScreenItemTransferState();
}

class _PrintScreenItemTransferState extends State<PrintScreenItemTransfer> {
  final globalKey = GlobalKey();

  Uint8List? bytes1;

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice _device = BluetoothDevice();
  String tips = 'No Printer!';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<dynamic> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Connected!';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Disconnected!';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShopProvider shopInfoProvider = Provider.of<ShopProvider>(context);
    ShopModel? shopModel = shopInfoProvider.shop;

    String shopName = shopModel?.shopName ?? '-';

    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: localizations.printer_screen,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 18.0,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      tips,
                      style: kTextStyle(size: 16.0),
                    ),
                  ),
                ],
              ),
              const Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name ?? ''),
                            subtitle: Text(d.address ?? ''),
                            onTap: () async {
                              setState(() {
                                _device = d;
                              });
                            },
                            trailing: _device.address == d.address
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : null,
                          ))
                      .toList(),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    MyButton(
                      label: localizations.printer_connect,
                      fontSize: 16.0,
                      onPressed: _connected
                          ? null
                          : () async {
                              if (_device.address != null) {
                                await bluetoothPrint.connect(_device);
                              } else {
                                setState(() {
                                  tips = localizations.select_printer;
                                });
                              }
                            },
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    MyButton(
                      label: localizations.printer_disconnect,
                      fontSize: 16.0,
                      onPressed: _connected
                          ? () async {
                              await bluetoothPrint.disconnect();
                            }
                          : null,
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 15.0),
                    MyButton(
                      label: localizations.print_receipt,
                      fontSize: 16.0,
                      onPressed: _connected
                          ? () async {
                              await PrintUtil.capture(
                                  globalKey, bluetoothPrint);
                            }
                          : null,
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    MyButton(
                      label: localizations.search_printer,
                      fontSize: 16.0,
                      onPressed: () => bluetoothPrint.startScan(
                        timeout: const Duration(seconds: 4),
                      ),
                      primary: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    RepaintBoundary(
                      key: globalKey,
                      child: InvoiceItemTransfer(
                        itemTransfer: widget.itemTransfer,
                        fromShopName: shopName,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.search),
      //   onPressed: () => bluetoothPrint.startScan(
      //     timeout: const Duration(seconds: 4),
      //   ),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
    );
  }
}
