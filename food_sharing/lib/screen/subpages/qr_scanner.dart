import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:food_sharing/theme/app_theme.dart';

class QRScanner extends StatefulWidget{
  final String expectedPostId;

  const QRScanner({super.key, required this.expectedPostId});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner>{
  bool _hasScanned = false;   //to prevent multiple rapid scans

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR to claim'),
        backgroundColor: BrandColors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: MobileScanner(
        onDetect: (capture){
          if(_hasScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          for(final barcode in barcodes){
            if(barcode.rawValue == widget.expectedPostId){  //if matching QR code generated from post:
              _hasScanned = true;
              Navigator.pop(context, true);
              return;
            } else if(barcode.rawValue != null){            //if existing but not matching QR code:
              _hasScanned = true;
              Navigator.pop(context, false);
              return;
            }
          }
        },
      )
    );
  }
}