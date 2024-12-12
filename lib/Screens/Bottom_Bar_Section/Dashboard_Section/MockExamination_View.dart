import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class MockExaminationView extends StatefulWidget {
  const MockExaminationView({super.key});

  @override
  _MockExaminationViewState createState() => _MockExaminationViewState();
}

class _MockExaminationViewState extends State<MockExaminationView> {
  final List<String> _files = []; // To keep track of downloaded files

  Future<void> _downloadFile() async {
    // Example URL (You would replace this with the actual file URL)
    const url = 'https://www.example.com/sample.pdf';
    final response = await HttpClient().getUrl(Uri.parse(url));
    final file = await _saveFile(await response.close(), 'sample.pdf');
    if (file != null) {
      setState(() {
        _files.add(file.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded: ${file.path}')),
      );
    }
  }

  Future<File?> _saveFile(HttpClientResponse response, String filename) async {
    final dir = await getExternalStorageDirectory();
    if (dir == null) return null;

    final file = File('${dir.path}/$filename');
    await response.pipe(file.openWrite());
    return file;
  }

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      setState(() {
        _files.add(file.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File uploaded: ${file.path}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _downloadFile,
              child: const Text('Download File'),
            ),
            ElevatedButton(
              onPressed: _uploadFile,
              child: const Text('Upload File'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _files.length,
                itemBuilder: (context, index) {
                  final filePath = _files[index];
                  return ListTile(
                    title: Text(filePath.split('/').last),
                    subtitle: Text(filePath),
                    leading: const Icon(Icons.file_copy),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
