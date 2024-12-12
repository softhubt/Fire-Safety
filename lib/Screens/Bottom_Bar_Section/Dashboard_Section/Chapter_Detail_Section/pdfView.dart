import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:share_plus/share_plus.dart';

class CustomPdfView extends StatefulWidget {
  final String title;
  final String url;
  final bool needToDonloadPdf;

  const CustomPdfView(
      {super.key,
      required this.title,
      required this.url,
      required this.needToDonloadPdf});

  @override
  State<CustomPdfView> createState() => _CustomPdfViewState();
}

class _CustomPdfViewState extends State<CustomPdfView> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadFile();
  }

  // Method to download and show the PDF
  Future<void> _downloadFile() async {
    var response = await http.get(Uri.parse(widget.url));
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/temp_jesc101.pdf");

    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      localFilePath = file.path;
    });
  }

  // Method to download and save the PDF to phone storage
  Future<void> _savePdfToStorage() async {
    await Permission.storage.request();

    var response = await http.get(Uri.parse(widget.url));

    final outputFile = await _getOutputFile();
    final outputFilePath = outputFile.path;
    final file = File(outputFilePath);
    await file.writeAsBytes(response.bodyBytes);

    customToast(message: "PDF saved to $outputFilePath");

    Share.shareXFiles([XFile(file.path)]);
  }

  Future<File> _getOutputFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.title}.pdf';
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        isBack: true,
        action: [
          if (widget.needToDonloadPdf)
            IconButton(
              icon: const Icon(Icons.download_rounded,
                  color: ColorConstant.white),
              onPressed:
                  _savePdfToStorage, // Call save method when button is pressed
            ),
        ],
      ),
      body: (localFilePath != null)
          ? PDFView(filePath: localFilePath)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
