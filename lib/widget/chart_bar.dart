import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double harcananFiyat;
  final double harcananYuzdeToplam;

  ChartBar(this.label, this.harcananFiyat, this.harcananYuzdeToplam);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.05,
            child: FittedBox(
              child: Text("${harcananFiyat.toStringAsFixed(0)} TL"),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.7,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: harcananYuzdeToplam,
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.07,
          ),
          Container(
            height: constraints.maxHeight * 0.06,
            child: FittedBox(
              child: Text("${label}"),
            ),
          ),
        ],
      );
    });
  }
}
