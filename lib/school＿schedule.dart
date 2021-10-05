import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:niu_app/components/niu_icon_loading.dart';

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
        title: Text('教務處行事曆'),
      ),
      body: Center(
          child: isLoading
              ? PDFViewer(document: document)
              : NiuIconLoading(
                  size: 80.0,
                )),
    );
  }

  Future<void> getPDF() async {
    document = await PDFDocument.fromURL(
            'https://academic.niu.edu.tw/bin/downloadfile.php?file=WVhSMFlXTm9Memt4TDNCMFlWOHhNamd3TVY4ME1qWTBNakl6WHpJMU9UVTVMbkJrWmc9PQ==&amp;fname=HDJHSTOPJDSTZTQPUTRPEDQPB1VTGHFDML01UWEHGHIHB5CHCDUTEDRPHDFDNLRPUTRPCDUTJDOPDGSXUTNL51RPKLVTRLEHCDA5HDFH15IHFDUXUTVT40B5RLMLOPOPHDJHWT45SXYXDGEH1501DG4014OPGHSTGHRPJDCH35NLTWCH14FDDGB551OPHDQPEDRPEH41UXYX5045STQP51EHKLVTB1EHGHDDOPDDJDFDDG4515B531PKIHIHCD40UXRPYXPKJDWX15OPUTWXKOPK')
        .whenComplete(() => {
              setState(() {
                isLoading = true;
              })
            });
  }
}
