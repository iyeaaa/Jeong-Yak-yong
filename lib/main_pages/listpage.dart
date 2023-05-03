import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var name = "??";
  var userEmail = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userEmail = firebaseAuth.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        title: const Text("List Page"),
      ),
      // firestore test
      body: Center(
        child: Column(
          children: [
            Text(name),
            ElevatedButton(
              onPressed: () async {
                var testData = await firestore.collection(userEmail).doc('mediInfo').get();
                setState(() {
                  name = testData['itemName'];
                });
              },
              child: const Text("불러오기"),
            ),
          ],
        ),
      ),
    );
  }
}
