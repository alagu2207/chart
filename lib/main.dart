import'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
void main(){

  runApp(MaterialApp(
      debugShowCheckedModeBanner:false,
      home:app()

  )
  );
}
class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();

}

class _appState extends State<app> {
  List<Salesdetails> sales=[];
  List<salesdaily> ss=[];
  List<salesweekly> aa=[];
  List<String> days=['sunday','monday','tuesday','wednesday'];
  List<int> daily=[100,200,500,400];


  Future<void> getJsonFromAssets() async {
    try {
      final manifestContent = await rootBundle.loadString('assets/data.json');
      final dynamic jsonResponse = json.decode(manifestContent);
      for (var item in jsonResponse as List) {
        aa.add(salesweekly.fromJson(item as Map<String, dynamic>));
      print('object"$aa');
      }
    } catch (e) {
      print('Error loading or parsing JSON: $e');
      // Handle the error, e.g., by showing an error message to the user
    }
    print('aa: $aa');
  }
  void loadsalesdate(){
    sales=[
      Salesdetails('jun', 100),
      Salesdetails('jul', 200),
      Salesdetails('aug', 300),
      Salesdetails('sep', 400),
      Salesdetails('oct', 500),

    ];

  }
  void states(){
    for (int i = 0; i < daily.length; i++) {
      ss.add(salesdaily(days[i], daily[i]) );
    }
  }
  @override
  @override
  void initState() {
    // TODO: implement initState

    loadsalesdate();
    states();
    super.initState();
    getJsonFromAssets();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('charts'),

actions: [Icon(Icons.add),SizedBox(width: 20,),],
      ),
        drawer:Drawer(),

      body: Column(
        children: [
          Row(
            children: [
              Container( height: 200,
                  width: 200,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      LineSeries<Salesdetails,String>
                        (dataSource:sales,
                          xValueMapper: (Salesdetails details, _)=>details.month,
                          yValueMapper:  (Salesdetails details, _)=>details.salescount,)
                    ]
                  )


              ),Container( height: 200,
                  width: 200,
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries>[
                        LineSeries<salesdaily,String>
                          (dataSource:ss,
                          xValueMapper: (salesdaily details, _)=>details.days,
                          yValueMapper:  (salesdaily details, _)=>details.daily,)
                      ]
                  )


              ),
            ],
          ),
SizedBox(height: 20,),
          Container(

            height: 200,
            width: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries<salesweekly, String>>[
                LineSeries<salesweekly, String>(
                  dataSource: aa,
                  xValueMapper: (salesweekly details, _) => details.weekly,
                  yValueMapper: (salesweekly details, _) => details.weeklycount,
                ),
              ],
            ),
          ),






        ],
      )
    );
  }
}
class Salesdetails{
  Salesdetails(this.month,this.salescount);
  final String month;
  final int salescount;

}
class salesdaily{
  salesdaily(this.days,this.daily);
  final String days;
  final int daily;

}
class salesweekly{
  salesweekly(this.weekly,this.weeklycount);
  final String weekly;
  final int weeklycount;
  factory salesweekly.fromJson(Map<String, dynamic> json) {
    return salesweekly(
      json['weekly'] as String,
      json['weeklycount'] != null ? json['weeklycount'] as int : 0, // Handle null values
    );
  }
}
