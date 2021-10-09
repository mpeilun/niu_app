import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/components/downloader.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String title;
  final String url;
  final String? fileName;

  const PdfViewer({
    Key? key,
    required this.title,
    required this.url,
    this.fileName,
  }) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () {
                    if (widget.fileName == null) {
                      download(Uri.parse(widget.url), context, null);
                    } else {
                      download(Uri.parse(widget.url), context, widget.fileName);
                    }
                  },
                  icon: Icon(Icons.arrow_downward))
            ],
          ),
          body: SfPdfViewer.network(
            widget.url,
            key: _pdfViewerKey,
          ),
        ),
      ),
    );
  }
}
