
import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/network.dart';
import 'package:medicine_app/sub_pages/medi_setting.dart';
import 'package:medicine_app/util/medicine_card.dart';
import '../medicine_data/medicine.dart';
import '../util/utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String itemName = "";
  List<Medicine> mediList = [];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    void readMedicineFromApi() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            content: Row(
              children: [
                const CircularProgressIndicator(color: Color(0xffa07eff)),
                SizedBox(width: 15 * fem),
                Container(
                  margin: const EdgeInsets.only(left: 7),
                  child: Text(
                    "Loading...",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 17 * fem,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      List<Medicine> tempMediList = [];
      Network network = Network(itemName: itemName);
      List<dynamic> listjson = await network.fetchMediList();

      if (context.mounted && (itemName.isEmpty || listjson.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "검색결과가 없습니다.",
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
        setState(() {
          mediList.clear();
        });
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
                        mediList.clear();
                        readMedicineFromApi();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            27 * fem, 20 * fem, 27 * fem, 20 * fem),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xff8a60ff),
                          borderRadius: BorderRadius.circular(20 * fem),
                        ),
                        child: Image.asset(
                          'image/fe-search-kxN.png',
                          width: 20 * fem,
                          height: 20 * fem,
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
                          child: MedicineCard(
                            fem: fem,
                            name: mediList[idx].itemName,
                            company: mediList[idx].entpName,
                            ontap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineSettingPage(
                                    medicine: mediList[idx]),
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
              onPressed: () {},
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
