import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicine_app/data/medicine.dart';


class Network {
  final apiKey = 'E%2FXF3cMAXfctK4LjQbchY8TliuRrN2sJ1M8dKJ6gFm'
      '88rPt1lpVI935w7bnPp%2B4ufAZdGPubLq0U%2F7dMqdIv9g%3D%3D';
  final String itemName;
  final int idx;

  Network({required this.itemName, required this.idx});

  Future<Medicine> fetchMedicine() async {
    final response = await http.get(Uri.parse("https://3rvfen0l3c.execute-api.u"
        "s-east-1.amazonaws.com/medicine_gateway_api/medicine/?itemName=활명수&p"
        "ageNo=1"));

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return Medicine.fromJson(json.decode(response.body), idx);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }
}
