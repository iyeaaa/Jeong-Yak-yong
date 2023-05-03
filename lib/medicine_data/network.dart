import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicine_app/medicine_data/medicine.dart';

class Network {
  final String _itemName;
  String url = "https://3rvfen0l3c.execute-api.us-east-1.amazonaws.com"
      "/medicine_gateway_api/medicine/?";

  Network({required String itemName}):
        _itemName = itemName
  {
    url += "itemName=$_itemName&";
    url += "pageNo=1";
  }

  Future<List<dynamic>> fetchMediList() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body)['items'];
      } catch (e) {
        return [];
      }
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  Medicine fetchMedicine(Map<String, dynamic> jsMedi) {
      return Medicine.fromJson(jsMedi);
  }
}
