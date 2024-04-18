import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';


class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  Map<String, double> dataMap = {
    "GELİR": 32,
    "GİDER": 28,
    "BORÇ": 16,
    "ANA PARA": 24,
  };
  List<Color> colorList = [
    const Color.fromARGB(255, 127, 96, 3),
    const Color.fromARGB(255, 4, 46, 80),
    Colors.black,
    Colors.grey
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PieChart(
            dataMap: dataMap,
            colorList: colorList,
            chartRadius: MediaQuery.of(context).size.width /
                1, // Grafik boyutunu ayarlayın
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.bottom,
              legendTextStyle: TextStyle(
                  color: Colors.white, fontSize: 20), // Yazı rengini beyaz yap
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: false,
              chartValueStyle: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
