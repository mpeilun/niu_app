import 'package:flutter/material.dart';
import 'package:niu_app/components/pdfviwer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SchoolSchedule extends StatefulWidget {
  @override
  State<SchoolSchedule> createState() => _SchoolScheduleState();
}

class _SchoolScheduleState extends State<SchoolSchedule> {
  String pdfUrl =
      'https://academic.niu.edu.tw/bin/downloadfile.php?file=WVhSMFlXTm9Memt4TDNCMFlWOHhNamd3TVY4ME1qWTBNakl6WHpJMU9UVTVMbkJrWmc9PQ==&amp;fname=HDJHSTOPJDSTZTQPUTRPEDQPB1VTGHFDML01UWEHGHIHB5CHCDUTEDRPHDFDNLRPUTRPCDUTJDOPDGSXUTNL51RPKLVTRLEHCDA5HDFH15IHFDUXUTVT40B5RLMLOPOPHDJHWT45SXYXDGEH1501DG4014OPGHSTGHRPJDCH35NLTWCH14FDDGB551OPHDQPEDRPEH41UXYX5045STQP51EHKLVTB1EHGHDDOPDDJDFDDG4515B531PKIHIHCD40UXRPYXPKJDWX15OPUTWXKOPK';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewer(
      title: '學校行事曆',
      url: pdfUrl,
      showAppbar: false,
    );
  }
}
