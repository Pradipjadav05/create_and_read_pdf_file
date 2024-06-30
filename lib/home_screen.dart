import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read File Demo"),
        centerTitle: true,
      ),
      body: const Center(
        child: ElevatedButton(
          onPressed: _createPDF,
          child: Text("Print PDF"),
        ),
      ),
    );
  }
}

Future<void> _createPDF() async {
  // Create a PDF document.
  final PdfDocument document = PdfDocument();

  // Add a page and draw text on it.
  final PdfPage page = document.pages.add();
  final PdfGraphics graphics = page.graphics;
  graphics.drawString(
      'Hello, World!', PdfStandardFont(PdfFontFamily.helvetica, 12));

  // Save the document.
  final List<int> bytes = await document.save();

  // Dispose the document.
  document.dispose();

  // Get the document directory path.
  final Directory? directory = await getExternalStorageDirectory();

  // final String path = directory!.path;
  // /storage/emulated/0/Android/data/com.example.read_filr/files

  final Directory appDocDirFolder = Directory(directory!.path.replaceFirst("data", "media").replaceFirst("files", "read File"));
  // /storage/emulated/0/Android/media/com.example.read_filr/read_file_demos

  // const String path = "/storage/emulated/0/Download/";

  await createPdfFolderIfNotExists(appDocDirFolder);

  final File file = File('${appDocDirFolder.path}/output.pdf');

  // Save the file.
  await file.writeAsBytes(bytes);

  // Open the PDF document.
  await OpenFile.open('${appDocDirFolder.path}/output.pdf');
}

// used to check if folder exits or not, if not then create.
Future<void> createPdfFolderIfNotExists(Directory appDocDirFolder) async {
  if (!(await appDocDirFolder.exists())) {
    await createPdfFolder(appDocDirFolder);
  }
}

/*
  * createPdfFolder method is used to create a pdfFolder named 'read file'
  * Parameters - appDocDirFolder = Path for create pdf folder
  * */

Future<String> createPdfFolder(Directory appDocDirFolder) async {
  final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
  return appDocDirNewFolder.path;
}
