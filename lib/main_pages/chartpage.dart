import 'package:flutter/material.dart';
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
  List<_SalesData> takeChartData = [
    _SalesData('6', 35),
    _SalesData('5', 28),
    _SalesData('4', 34),
    _SalesData('3', 32),
    _SalesData('2', 40),
    _SalesData('1', 32),
    _SalesData('0', 40),
  ];

  List<_SalesData> tookChartData = [
    _SalesData('6', 50),
    _SalesData('5', 20),
    _SalesData('4', 50),
    _SalesData('3', 10),
    _SalesData('2', 15),
    _SalesData('1', 20),
    _SalesData('0', 50),
  ];

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
      body: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                  width: 3,
                  color: const Color(0xffff5788),
                  dataSource: takeChartData,
                  xValueMapper: (_SalesData sales, _) => sales.key,
                  yValueMapper: (_SalesData sales, _) => sales.value,
                  name: '먹은 약',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<_SalesData, String>(
                  width: 3,
                  color: const Color(0xFFA07EFF),
                  dataSource: tookChartData,
                  xValueMapper: (_SalesData sales, _) => sales.key,
                  yValueMapper: (_SalesData sales, _) => sales.value,
                  name: '먹지 않은 약',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
