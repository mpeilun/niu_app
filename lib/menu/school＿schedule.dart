import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class SchoolSchedule extends StatefulWidget {
  @override
  State<SchoolSchedule> createState() => _SchoolScheduleState();
}

class _SchoolScheduleState extends State<SchoolSchedule> {
  bool isLoading = false;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    getPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );
  }

  Future<void> getPDF() async {
    document = await PDFDocument.fromURL(
            'https://academic.niu.edu.tw/bin/downloadfile.php?file=WVhSMFlXTm9Memt4TDNCMFlWOHhNak13TjE4eE9ESTFOamN4WHpjeE1UZ3dMbkJrWmc9PQ==&fname=HDJHSTOPJDSTZTQPUTRPEDQPB1VTGHFDML01UWEHGHIHB5CHCDUTEDRPHDFDNLRPUTRPCDUTJDOPDGSXUTNL51RPKLVTRLEHCDA5HDFH15IHFDUXUTVT40B5RLMLOPOPHDJHWT45SXYXDGEH1501DG4014OPGHSTGHRPJDCH35NLTWCH14FDDGB551OPHDQPEDRPEH41UXYX5045STQP40B5SXOPSXQPHDED55FDUX11KOKO')
        .whenComplete(() => {
              setState(() {
                isLoading = true;
              })
            });
  }
}
