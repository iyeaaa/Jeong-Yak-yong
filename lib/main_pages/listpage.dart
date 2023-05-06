import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_app/medicine_data/medicine.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';

import '../util/medicine_card.dart';
import '../util/utils.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var name = "??";
  var userEmail = "";

  Future<List<Medicine>> getMediData() async {
    var list = await _firestore.collection(userEmail).doc('mediInfo').get();
    List<Medicine> mediList = [];
    for (var v in list.data()!['medicine']) {
      try {
        mediList.add(
          Medicine(
            itemName: v['itemName'],
            entpName: v['entpName'],
            effect: v['effect'],
            itemCode: v['itemCode'],
            useMethod: v['useMethod'],
            warmBeforeHave: v['warmBeforeHave'],
            warmHave: v['warmHave'],
            interaction: v['interaction'],
            sideEffect: v['sideEffect'],
            depositMethod: v['depositMethod'],
          ),
        );
      } catch (e) {
        if (context.mounted) {
          debugPrint("medi load ERROR");
        }
      }
    }
    return mediList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userEmail = _firebaseAuth.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          'My List',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 26 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20 * fem, 20 * fem, 20 * fem, 20 * fem),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getMediData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                if (snapshot.hasData == false) {
                  return const Center(
                    child: Text("Loading.."),
                  );
                }
                //error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return const Center(
                    child: Text("ERROR!"),
                  );
                }
                // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                else {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Replace this delay with the code to be executed during refresh
                        // and return asynchronous code
                        setState(() {});
                        return Future<void>.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, idx) => Container(
                          margin: EdgeInsets.only(top: 10 * fem),
                          child: MedicineCard(
                            fem: fem,
                            name: snapshot.data[idx].itemName,
                            company: snapshot.data[idx].entpName,
                            buttonName: '보기',
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineSettingPage(
                                    medicine: snapshot.data[idx],
                                    creating: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
