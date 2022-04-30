import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:max_harcamalar/model/Transaction.dart';
import 'package:max_harcamalar/widget/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> sonTransactions;

  Chart(this.sonTransactions);

  List<Map<String, Object>> get transactionDegerGrup {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double toplamHarcama = 0.0;

      for (var i = 0; i < sonTransactions.length; i++) {
        if (sonTransactions[i].date!.day == weekDay.day &&
            sonTransactions[i].date!.month == weekDay.month &&
            sonTransactions[i].date!.year == weekDay.year) {
          toplamHarcama = toplamHarcama +
              double.parse(sonTransactions[i].amount.toString());
        }
      }
      //Haftanın günlerini map yapıyyoruz
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "fiyat": toplamHarcama
      };
    });
  }

  double get maxHarcanan {
    return transactionDegerGrup.fold(0.0, (previousValue, element) {
      return previousValue + (element["fiyat"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactionDegerGrup.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data["day"].toString(),
                  (data["fiyat"] as double),
                  maxHarcanan == 0.0
                      ? 0.0
                      : (data["fiyat"] as double) / maxHarcanan),
            );
          }).toList(),
        ),
      ),
    );
  }
}
