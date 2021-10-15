import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TestFirebase extends StatefulWidget {

  const TestFirebase({Key? key}) : super(key: key);

  @override
  _TestFirebaseState createState() => _TestFirebaseState();
}

class _TestFirebaseState extends State<TestFirebase> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireBase理論測試'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //設定集合
          FirebaseFirestore.instance
              .collection("testing")
              .doc(prefs.getString("id"))
              .set({'timestamp' : Timestamp.fromDate(DateTime.now())});
          //設定集合為亂數
          FirebaseFirestore.instance
              .collection("testing")
              .add({'timestamp' : Timestamp.fromDate(DateTime.now())});
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('testing').snapshots(),
        builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
            if(!snapshot.hasData) return const SizedBox.shrink();
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context,int index){
                final Object? docData = snapshot.data!.docs[index].data();
                final DateTime dataTime = ((docData as Map)['timestamp'] as Timestamp).toDate();
                return ListTile(
                  title: Text(dataTime.toString()),
                );
              },
            );
        },
      ),
    );
  }
}
