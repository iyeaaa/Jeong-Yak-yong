import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/network.dart';
import 'package:medicine_app/util/medicine_card.dart';
import '../medicine_data/medicine.dart';
import '../util/utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String itemName = "";
  List<Medicine> mediList = [];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    void readMedicineFromApi() async {
      List<Medicine> tempMediList = [];
      Network network = Network(itemName: itemName);
      List<dynamic> listjson = await network.fetchMediList();

      for (Map<String, dynamic> jsMedi in listjson) {
        tempMediList.add(await network.fetchMedicine(jsMedi));
      }

      setState(() {
        mediList = tempMediList;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: false,
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
        leading: const Icon(Icons.arrow_back_ios_new_sharp),
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
              key: _formKey,
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
              child: ListView.builder(
                itemCount: mediList.length,
                itemBuilder: (context, idx) => Container(
                  margin: EdgeInsets.only(top: 10 * fem),
                  child: MedicineCardForSearch(
                    fem: fem,
                    name: mediList[idx].itemName,
                    company: mediList[idx].entpName,
                  ),
                ),
              ),
            ), // 약 목록 리스트 위젯
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

