// import 'package:flutter/material.dart';
//
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PDFScreen extends StatelessWidget {
//   final String pdfUrl;
//   final String pdfFileName;
//
//   PDFScreen({required this.pdfUrl, required this.pdfFileName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: FutureBuilder(
//         future: downloadPDF(pdfUrl, pdfFileName),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             }
//             return PDFView(
//               filePath: snapshot.data.toString(),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   // downloadPDF(String url, String fileName) async {
//   //   final savedDir =
//   //   await getExternalStorageDirectory(); // Directory where the PDF file will be saved
//   //   final taskId = await FlutterDownloader.enqueue(
//   //     url: url,
//   //     savedDir: savedDir!.path,
//   //     fileName: fileName,
//   //     showNotification: true,
//   //     openFileFromNotification: true,
//   //   );
//   //
//   //   FlutterDownloader.registerCallback((id, status, progress) {
//   //     // Handle download status and progress updates
//   //     if (status == DownloadTaskStatus.complete) {
//   //       // Download completed successfully
//   //       // You can display a message or trigger the PDF viewer here
//   //     }
//   //   });
//   //
//   //   return taskId;
//   // }
// }
