import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function yeniTX;

  NewTransaction(this.yeniTX);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final tfBaslik = TextEditingController();

  final tfFiyat = TextEditingController();

  DateTime? secilenTarih;

  void _dataGonder() {
    if (tfFiyat.text.isEmpty) {
      return;
    }
    final girilenBaslik = tfBaslik.text;
    final girilenFiyat = double.parse(tfFiyat.text);

    if (girilenBaslik.isEmpty || girilenFiyat < 0 || secilenTarih == null) {
      return;
    }
    widget.yeniTX(
      girilenBaslik,
      girilenFiyat,
      secilenTarih,
    );

    Navigator.of(context).pop();
  }

  void _tarihSecici() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        secilenTarih = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Başlık"),
                controller: tfBaslik,
                onSubmitted: (_) => _dataGonder(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Fiyat"),
                controller: tfFiyat,
                keyboardType: TextInputType.number,
                //parantez içindeki alt tire
                //bana değer donduruyorsun ama umrumda değil demek.
                onSubmitted: (_) => _dataGonder(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Text(
                      secilenTarih == null
                          ? "Tarih seçilmedi"
                          : DateFormat.yMd().format(secilenTarih!),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              "Tarih seç",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _tarihSecici,
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: _tarihSecici,
                            child: Text(
                              "Tarih seç",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _dataGonder();
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                ),
                child: Text("Listeye Ekle"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
