import 'package:flutter/material.dart';
import 'package:medicine_app/sub_pages/info_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InfoPage(
        title: '복용 전 참고사항',
        content: '12세 이상의 소아와 성인은 1회 2정을 매 8시간마다 복용합니다. 24시간 동안 6정을 초과하지 마십시오. '
            '이 약은 서방형 제제이므로 정제를 으깨거나 씹거나 녹이지 말고 그대로 삼켜서 복용하십시오.',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
