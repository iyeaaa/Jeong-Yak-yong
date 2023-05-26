import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/network.dart';
import 'package:medicine_app/sub_pages/making_medi.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';
import 'package:medicine_app/util/loading_bar.dart';
import 'package:medicine_app/util/medicine_card.dart';
import '../medicine_data/medicine.dart';
import '../util/utils.dart';

class SearchPage extends StatefulWidget {
  final List<Medicine> mediList;

  const SearchPage({
    Key? key,
    required this.mediList,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var userEmail = "";
  String itemName = "";
  List<Medicine> mediList = [];

  @override
  void initState() {
    super.initState();
    userEmail = _firebaseAuth.currentUser!.email!;
    mediList = widget.mediList;
  }

  void showCustomDialog(BuildContext context, double fem, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: SizedBox(width: 300 * fem, child: loadImageExample(imageUrl)),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }

  Widget loadImageExample(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
      ),
      child: Image.network(
        imageUrl,
        width: 400,
      ),
    );
  }

  void readMedicineFromApi(double fem) async {
    showLoadingBar(context);

    List<Medicine> tempMediList = [];
    Network network = Network(itemName: itemName);
    List<dynamic> listjson = await network.fetchMediList();

    if (context.mounted && (itemName.isEmpty || listjson.isEmpty)) {
      showScaffold("검색결과가 없습니다.", context, fem);

      Navigator.pop(context);
      return;
    }

    for (Map<String, dynamic> jsMedi in listjson) {
      tempMediList.add(network.fetchMedicine(jsMedi));
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    setState(() {
      tempMediList.sort(((a, b) => a.itemName.compareTo(b.itemName)));
      mediList = tempMediList;
    });
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
          'Search',
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
        padding: EdgeInsets.fromLTRB(
          30 * fem,
          20 * fem,
          30 * fem,
          20 * fem,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              child: SizedBox(
                width: double.infinity,
                height: 72 * fem,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(color: const Color(0xff8a60ff)),
                      ),
                      width: 230 * fem,
                      height: double.infinity,
                      padding: EdgeInsets.only(left: 20 * fem),
                      child: Center(
                        child: TextFormField(
                          onChanged: (value) => itemName = value,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search..',
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ), // Search Bar
                    InkWell(
                      onTap: () {
                        readMedicineFromApi(fem);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            20 * fem, 20 * fem, 20 * fem, 20 * fem),
                        width: 75*fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xff8a60ff),
                          borderRadius: BorderRadius.circular(20 * fem),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.search,
                            size: 30 * fem,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ), // Search Button
                  ],
                ),
              ),
            ), // 검색 위젯
            SizedBox(height: 10 * fem),
            Expanded(
                child: mediList.isNotEmpty
                    ? ListView.builder(
                        itemCount: mediList.length,
                        itemBuilder: (context, idx) => Container(
                          padding: EdgeInsets.only(top: 10 * fem),
                          height: 95 * fem,
                          child: MedicineCard(
                            existEmage: mediList[idx].imageUrl != "No Image",
                            imageOntap: () {
                              if (mediList[idx].imageUrl == "No Image") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(milliseconds: 800),
                                    content: Text(
                                      "이미지가 없어요",
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Nunito',
                                        fontSize: 15 * fem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.3625 * fem / fem,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    backgroundColor: const Color(0xff8a60ff),
                                  ),
                                );
                              } else {
                                showCustomDialog(
                                    context, fem, mediList[idx].imageUrl);
                              }
                            },
                            isChecked: false,
                            fem: fem,
                            name: mediList[idx].itemName,
                            company: mediList[idx].entpName,
                            ontap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineSettingPage(
                                  medicine: mediList[idx],
                                  creating: true,
                                ),
                              ),
                            ),
                            buttonName: "보기",
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "결과 없음",
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 17 * fem,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffa07eff),
                          ),
                        ),
                      )), // 약 목록 리스트 위젯
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MakingMediPage(
                    userEmail: userEmail,
                  ),
                ),
              ),
              child: Text(
                '찾는 약이 없으신가요?',
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffa07eff),
                ),
              ),
            ) // 찾는 약이 없으신가요
          ],
        ),
      ),
    );
  }
}
