import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() async {
  runApp(const MainWidget());
}

// Main Widget
class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String scanBarcode = 'Unknown';
  String currState = '';
  String currStyle = '';
  List weGot = [];

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    bool isFound = false;
    setState(() {
      scanBarcode = barcodeScanRes;
      for (var valuee in weGot) {
        if (valuee == scanBarcode) {
          isFound = true;
          currState = 'Do Not Allow';
          break;
        }
      }
      if (isFound == false) {
        weGot.add(scanBarcode);
        currState = 'Allow';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        Text('Scan result : $scanBarcode\n',
                            style: TextStyle(fontSize: 20)),
                        Text('Status : $currState\n',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 121, 221)))
                      ]));
            })));
  }
}
