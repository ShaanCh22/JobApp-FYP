import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String resumeName;
  const PdfViewerScreen({super.key,required this.pdfUrl,required this.resumeName});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  initializePDF() async{
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    initializePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff1D1D2F),
        elevation: 1,
        title: Text(widget.resumeName,style: GoogleFonts.dmSans(
            color: Colors.white
        ),),
      ),
      body: document == null ?
      const Center(
        child: CircularProgressIndicator(),
      ) :
      PDFViewer(document: document!,),
    );
  }
}
