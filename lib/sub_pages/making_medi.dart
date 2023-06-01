import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import '../medicine_data/medicine.dart';
import '../util/medicine_list.dart';
import '../util/utils.dart';

class MakingMediPage extends StatefulWidget {
  final String userEmail;

  const MakingMediPage({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<MakingMediPage> createState() => _MakingMediPageState();
}

class _MakingMediPageState extends State<MakingMediPage> {
  final _firestore = FirebaseFirestore.instance;
  List<String> variName = [
    "effect", // 효능
    "useMethod", // 사용법
    "warmBeforeHave", // 약 먹기전 알아야할 사항
    "warmHave", // 약 사용상 주의사항
    "interaction", // 상호작용
    "sideEffect", // 부작용
    "depositMethod", // 보관법
  ];
  List<String> titleList = [
    "다음과 같은 효능이 있어요",
    "다음과 같이 사용해야 해요",
    "의약품 복용 전 참고하세요",
    "주의해야하는 사항이에요",
    "주의가 필요한 음식이에요",
    "이러한 부작용이 있어요",
    "다음과같이 보관해야 해요",
  ];
  List<IconData> iconList = [
    MaterialSymbols.stars,
    MaterialSymbols.settings,
    MaterialSymbols.back_hand,
    Icons.health_and_safety_outlined,
    Icons.no_food_outlined,
    MaterialSymbols.sick,
    MaterialSymbols.desk,
  ];
  Map<String, Object> mediInfo = {
    'imageUrl': "No Image",
    'itemCode': "알아야 할 내용이 없어요.",
    'entpName': "알아야 할 내용이 없어요.",
    "effect": "알아야 할 내용이 없어요.", // 효능
    "useMethod": "알아야 할 내용이 없어요.", // 사용법
    "warmBeforeHave": "알아야 할 내용이 없어요.", // 약 먹기전 알아야할 사항
    "warmHave": "알아야 할 내용이 없어요.", // 약 사용상 주의사항
    "interaction": "알아야 할 내용이 없어요.", // 상호작용
    "sideEffect": "알아야 할 내용이 없어요.", // 부작용
    "depositMethod": "알아야 할 내용이 없어요.", // 보관법
    "count": 0, // 약 개수
  };

  // 데이터베이스에 약 추가
  Future<void> appendToArray(double fem) async {
    _firestore.collection(widget.userEmail).doc('mediInfo').update({
      'medicine': FieldValue.arrayUnion([mediInfo]),
    });
  }

  Future<List<Medicine>> getMediData() async {
    var list =
        await _firestore.collection(widget.userEmail).doc('mediInfo').get();
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
            imageUrl: v['imageUrl'],
            count: v['count'],
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

  Widget myTextField(int idx) => TextFormField(
        onChanged: (value) => mediInfo[variName[idx]] = value,
        style: const TextStyle(color: Color(0xff3600CA)),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff3600CA)),
            borderRadius: BorderRadius.circular(5.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff8559FF),
            ),
          ),
          prefixIcon: Icon(
            iconList[idx],
            color: const Color(0xff8559FF),
          ),
          filled: true,
          fillColor: const Color(0xffDFD3FF),
          labelText: titleList[idx],
          labelStyle: const TextStyle(color: Color(0xff6B35FF)),
        ),
      );

  void showMySnackBar(double fem, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        content: Text(
          body,
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
  }

  Widget settingCount(double fem) => Padding(
    padding: EdgeInsets.only(top: 10 * fem),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "남은 약 개수: ",
          overflow: TextOverflow.ellipsis,
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 22 * fem,
            fontWeight: FontWeight.w700,
            height: 1.5,
            color: const Color(0xffa98aff),
          ),
        ),
        Container(
          width: 120 * fem,
          height: 50 * fem,
          padding: EdgeInsets.fromLTRB(12 * fem, 0, 12 * fem, 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() {
                  mediInfo['count'] = max(0, (mediInfo['count'] as int) - 1);
                }),
                child: Text(
                  "-",
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 20 * fem,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
              Text(
                mediInfo['count'].toString(),
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 22 * fem,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              InkWell(
                onTap: () => setState(() {
                  mediInfo['count'] = max(0, (mediInfo['count'] as int) + 1);
                }),
                child: Text(
                  "+",
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 20 * fem,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          "Register",
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 23 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30 * fem),
            child: InkWell(
              onTap: () async {
                if (!mediInfo.containsKey('itemName')) {
                  showMySnackBar(fem, '약 이름을 설정해주세요.');
                  return;
                }
                await appendToArray(fem);
                MediList().update();
                if (context.mounted) {
                  debugPrint("약 추가 성공");
                  showMySnackBar(fem, "${mediInfo['itemName']}을 추가했습니다.");
                }
              },
              child: Icon(
                Icons.playlist_add,
                size: 40 * fem,
              ),
            ),
          ),
        ],
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
          children: [
            Container(
              width: double.infinity,
              height: 100 * fem,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20 * fem)),
                border: Border.all(color: const Color(0xff8559FF)),
              ),
              child: Padding(
                padding: EdgeInsets.all(8 * fem),
                child: Row(
                  children: [
                    Container(
                      width: 80 * fem,
                      height: 80 * fem,
                      decoration: BoxDecoration(
                        color: const Color(0xffA07EFF),
                        borderRadius:
                            BorderRadius.all(Radius.circular(20 * fem)),
                        border: Border.all(color: const Color(0xff8559FF)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_search,
                          color: Colors.white,
                          size: 35 * fem,
                        ),
                      ),
                    ), // Image Box
                    SizedBox(width: 8 * fem),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 30 * fem,
                            child: TextFormField(
                              onChanged: (value) =>
                                  mediInfo['itemName'] = value,
                              decoration: const InputDecoration(
                                hintText: 'name',
                                hintStyle: TextStyle(color: Color(0xff6B35FF)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff3600CA)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff8559FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30 * fem,
                            child: TextFormField(
                              onChanged: (value) =>
                                  mediInfo['entpName'] = value,
                              decoration: const InputDecoration(
                                hintText: 'company',
                                hintStyle: TextStyle(color: Color(0xff6B35FF)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff3600CA)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff8559FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),// name// , company
                  ],
                ),
              ),
            ),
            SizedBox(height: 10 * fem),
            Expanded(
              child: ListView.builder(
                itemCount: titleList.length,
                itemBuilder: (context, idx) => Padding(
                  padding: EdgeInsets.only(top: 20 * fem),
                  child: myTextField(idx),
                ),
              ),
            ),
            settingCount(fem),
            SizedBox(height: 10*fem),
          ],
        ),
      ),
    );
  }
}
