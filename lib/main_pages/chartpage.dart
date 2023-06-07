import 'package:flutter/material.dart';
import 'package:medicine_app/util/event.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../util/utils.dart';

class _SalesData {
  _SalesData(this.key, this.value);

  final String key;
  final double value;
}

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  var curTime = DateTime.now();
  late DateTime firstTime;
  List<_SalesData> takeChartData = [];
  List<_SalesData> tookChartData = [];
  int totalCnt = 0;
  int tookCnt = 0;

  @override
  void initState() {
    super.initState();

    firstTime = curTime.add(const Duration(days: -5));
    List<double> takeList = List.generate(7, (index) => 0, growable: false);
    List<double> tookList = List.generate(7, (index) => 0, growable: false);
    List<DateTime> correctKey = kEvents.keys.where((element) {
      int diff = curTime.day - element.day;
      return -1 <= diff && diff <= 5;
    }).toList();

    for (DateTime key in correctKey) {
      for (Event event in kEvents[key]!) {
        if (!event.memo) {
          int keyToIdx = curTime.day - key.day + 1;
          takeList[keyToIdx]++;
          totalCnt++;
          if (event.take) {
            tookList[keyToIdx]++;
            tookCnt++;
          }
        }
      }
    }

    for (int i = 0; i < 7; i++) {
      var yet = curTime.add(Duration(days: i - 5));
      takeChartData.add(_SalesData("${yet.month}.${yet.day}", takeList[6 - i]));
      tookChartData.add(_SalesData("${yet.month}.${yet.day}", tookList[6 - i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          'Chart',
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 500 * fem,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    enableAxisAnimation: false,
                    // Chart title
                    legend: Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                        width: 3,
                        color: const Color(0xFFA07EFF),
                        dataSource: takeChartData,
                        xValueMapper: (_SalesData sales, _) => sales.key,
                        yValueMapper: (_SalesData sales, _) => sales.value,
                        name: '전체 약 개수',
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                      LineSeries<_SalesData, String>(
                        width: 3,
                        color: const Color(0xffff5788),
                        dataSource: tookChartData,
                        xValueMapper: (_SalesData sales, _) => sales.key,
                        yValueMapper: (_SalesData sales, _) => sales.value,
                        name: '먹은 약 개수',
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20*fem),
                Text(
                  "${firstTime.month}월 ${firstTime.day}일부터",
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 17 * fem,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8357fc),
                  ),
                ),
                Text(
                  "$totalCnt개의 약 중 $tookCnt개의 약을 먹었어요",
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 26 * fem,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8357fc),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
