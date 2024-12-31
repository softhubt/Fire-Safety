import 'package:file_picker/file_picker.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/Chapter_Detail_Section/pdfView.dart';
import 'package:firesafety/Widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class MockExaminationView extends StatefulWidget {
  final String mockId;
  final String mockName;
  final String examTime;
  final String marks;
  final String chapterId;
  final String courseId;
  final String subcategoryid;
  final String categoryid;
  final String questionPdf;
  final String samplePdf;

  const MockExaminationView(
      {super.key,
      required this.mockId,
      required this.mockName,
      required this.examTime,
      required this.marks,
      required this.chapterId,
      required this.courseId,
      required this.subcategoryid,
      required this.categoryid,
      required this.questionPdf,
      required this.samplePdf});

  @override
  // ignore: library_private_types_in_public_api
  _MockExaminationViewState createState() => _MockExaminationViewState();
}

class _MockExaminationViewState extends State<MockExaminationView> {
  final List<String> _files = []; // To keep track of downloaded files
  String? localFilePath;

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      setState(() {
        _files.add(file.path);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('File uploaded: ${file.path}')));
    }
  }

  // Method to download and save the PDF to phone storage
  Future<void> _savePdfToStorage() async {
    await Permission.storage.request();

    var response = await http.get(Uri.parse(widget.questionPdf));

    final outputFile = await _getOutputFile();
    final outputFilePath = outputFile.path;
    final file = File(outputFilePath);
    await file.writeAsBytes(response.bodyBytes);

    customToast(message: "PDF saved to $outputFilePath");

    Share.shareXFiles([XFile(file.path)]);
  }

  Future<File> _getOutputFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.mockName}.pdf';
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: Column(
        children: [
          Expanded(
              child: CustomPdfView(
                  title: "Mock Test",
                  url: widget.samplePdf,
                  needToDonloadPdf: true,
                  needToShowAppbar: true)),
          Padding(
            padding: EdgeInsets.only(
                left: screenWidthPadding,
                right: screenWidthPadding,
                bottom: screenHeightPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _savePdfToStorage,
                    child: const Text('Download File')),
                ElevatedButton(
                    onPressed: _uploadFile, child: const Text('Upload File')),
              ],
            ),
          ),
          // ListView.builder(
          //   itemCount: _files.length,
          //   itemBuilder: (context, index) {
          //     final filePath = _files[index];
          //     return ListTile(
          //       title: Text(filePath.split('/').last),
          //       subtitle: Text(filePath),
          //       leading: const Icon(Icons.file_copy),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
