import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class PrintUtil {
  static Future capture(GlobalKey key, bluetoothPrint) async {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Map<String, dynamic> config = {};
    List<LineText> list1 = [];

    // invoice image
    List<int> imageBytes = byteData!.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    String base64Image = base64Encode(imageBytes);

    // logo image
    // ByteData data = await rootBundle.load("assets/images/syw_logo.jpg");
    // List<int> imageBytesLogo =
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // String base64ImageLogo = base64Encode(imageBytesLogo);
    //
    // list1.add(
    //   LineText(
    //     type: LineText.TYPE_IMAGE,
    //     content: base64ImageLogo,
    //     linefeed: 1,
    //   ),
    // );
    list1.add(
      LineText(
        type: LineText.TYPE_IMAGE,
        content: base64Image,
        linefeed: 1,
      ),
    );
    list1.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Thank You, See You Again!!!',
        align: 1,
        linefeed: 1,
      ),
    );
    await bluetoothPrint.printLabel(config, list1);
  }
}
