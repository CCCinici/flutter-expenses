// ignore_for_file: prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:max_harcamalar/model/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function harcamaSil;

  TransactionList(this.transactions, this.harcamaSil);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  "Henüz harcama eklenmedi",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            /*
      children: transactions.map((tx) {

      }).toList(),
              Burada transaction bir list. Bizde listenin özelliği olan
              map fonksiyonu ile döngü başlatıyoruz. tx içine her bir
              transaction oluşumu alınıyor. ve liste kadar dönmeye başlıyor.
              return ile de içindeki yapımızı oluşturup gösteriyoruz.
              son olarakta toList ile bunu listeye tekrar dönüştürüyoruz.

               */
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text("${transactions[index].amount} TL"),
                      ),
                    ),
                  ),
                  title: Text(
                    "${transactions[index].title}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  trailing: MediaQuery.of(context).size.width > 360
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.delete),
                          label: Text("Sil"),
                        )
                      : IconButton(
                          onPressed: () {
                            harcamaSil(transactions[index].id);
                          },
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                        ),
                  subtitle: Text(
                      "${DateFormat.yMMMd().format(transactions[index].date!)}"),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}

/*

Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          transactions[index].amount!.toStringAsFixed(2) +
                              " TL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactions[index].title as String,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            //DateFormat içine tırnaklar içinde de kullanılabilir
                            //Örn : dd-MM-yyyy şeklinde
                            DateFormat.yMMMd()
                                .format(transactions[index].date as DateTime),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
 */
