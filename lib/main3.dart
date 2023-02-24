import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gsheets/gsheets.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "barcode-378307",
  "private_key_id": "b7c7769800c1bb012a86210a5c1088747caeb880",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDRR5Ru4aZtoIws\nRVFON/ZjhR0GJT0CgJlq+JUdZI5Gpssq9qCZUKUeJ6b7MfIDEIFhPWvJBCN89tbO\ndJGcEeY4O0r7RpI+diuXLkiKeOcLh5+br0XdtejnGoeSFWjLYzB0bXn7NX2Lcpt6\n0mEAUiDuTmV7qpyEOey/ZBKR6rW9jCQ81SAYI43pjpiehqhstU7/3ecyaISku3xB\nR/H44M41qIQ5O1bafnsGPVtHsh+MEt30huPWUeMAVHJI9/QVvFYwJbL4RN4GhvTG\nFLs/nmr3eRw8OaQtB3n4THv9W4GchcJOKtwuDEqpZZ6a4hvY2eAetVbr4MHAAwxT\nIoeWXHb5AgMBAAECggEAJmzPGyDBTwWYVxSPHh52VcV+E7/ImOoFwTdNIa1x1hUP\n3p6T1DKTbpr3NM3x0pA4QSNm4+ynm20y+Ys7pP1AWPjCBqrpdSB7VnHADfSu71YC\nfzJKUK/yyGP9mlvl9toKboYfTHmAyJbNZ1qzRrzNoROx3Gfx/vEnv+he5H3Eyr1Y\nObJAgztsl8NfId4Y3ejDtLRbm9UQP8doYPLNiFbPcR1qt7kQpu7BhCdbL2gFtp3z\n6ww9xzdEjUvU5ldz/fKAsuyzBaf4fzbnYnJbgeRPx315R8YkmKqRTh6X8PJyU4jd\nJFUlh9VRfmUit96hwwTPl6rOU1+k7DI9V9f4XFebUQKBgQD5btlVsbgghxy9oP23\nWePPQiYhucxv+ITzsWmb+Eq3A1Db7iYForlc30L8oYY+Fft6UFZZRgJk2w3CI04p\n5J8BhnE73gSGAGgwdMqopqVvEuNVq31HQB2rCJTaitisWv6v0DO/gu1AtoA5KB5h\nx5RKLKFK0vojPHFsAPPEehgWDQKBgQDWyhn0Md9Fvt0E2qkdaP0/i4IGRSyT4NU9\nhKGr0mmhgYJRJgxlJwSdFG3Xn3Gzv9ZG4LaOG1yfz8kkIkBzd5ZpzQ4jyGLOSWdo\nXDrnmIeYm4WclbnzeF3HLYBmYHuoWF9sPxIc1s067ffcRKIe1R2eXDsxbkcCVr1F\nTjgIm891nQKBgQCnmL65YK9qU76Q/9JaVzDFuxmqAZCHD8Ith+CBJyT0sWqsS+kK\nUlsgNvdojhOINfcCKWbLl0nWgIVPE6/aYD4ipTYCVtxNOYrIPEFLbqWr61IK5y5H\nKKKGoD58VVze+kk00r1iidNmbvna7cT0SEiwSiqZ/waJlHxVaJJiSvNSJQKBgQDK\nLMHxUWBQTi/MeeXlgQWf4rkpHcOwDlmp5kYnbY9wLm9z4tSYAfodwTUDWVm1UEVp\nwesUKD0vUG6MTJFOHqq+O/2rQNuAQSfM28O2a6R2yS0jDuxReGMNMI9Dzl2XQFfR\nlCyAaNAVQBmmhBP14bRXc4lkJeFBGlReABpOQBsvIQKBgQCFAy4IjKPd7n7TRMRE\nmXjUndhQ9DGTaere0QjJpRZDfe3zyBbBuqalRwdIrLJY+fy8TjHMmmXMKN6dN0k0\nf7LzMeEd8d55vaCfxUDN/DjeK57tylfHWkP696YemBq3Z4FaHi11gg/nNcDs4RGA\nGusbxcsvQFlOkUA66HaEYbrlTg==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@barcode-378307.iam.gserviceaccount.com",
  "client_id": "101365794914088282572",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40barcode-378307.iam.gserviceaccount.com"
}
''';

const _spreadsheetId = '1UiIQMgN9W40ao4TOtwUa7AlwPSWzF8bFoTMyM2cwutk';

void main() async {
  final gsheets = GSheets(_credentials);
  final ss = await gsheets.spreadsheet(_spreadsheetId);

  var sheet1 = ss.worksheetByTitle('Sheet1');
  var sheet2 = ss.worksheetByTitle('Sheet2');

  final firstRow = ['index', 'letter', 'number', 'label'];
  await sheet2?.values.insertRow(1, firstRow);
  var barcode = MainWidget.getBarcode();
  runApp(const MainWidget());
}

// Main Widget

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();

  static getBarcode() {
    if (_scanBarcode != 'Unknown') {
      return _scanBarcode;
    }
  }
}

class _MainWidgetState extends State<MainWidget> {
  String _scanBarcode = 'Unknown';

  void startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  void scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Barcode Scanner')),
          body: Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () => scanBarcodeNormal(),
                        child: Text('Start barcode scan')),
                    Text('Scan result : $_scanBarcode\n',
                        style: TextStyle(fontSize: 20))
                  ]))),
    );
  }
}
