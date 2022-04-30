// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:max_harcamalar/widget/chart.dart';
import 'package:max_harcamalar/widget/new_transaction.dart';
import 'package:max_harcamalar/widget/transaction_list.dart';

import 'model/Transaction.dart';

void main() {
  //Bazı cihazlarda bu yapı sorunu çözebiliyor.
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harcamalar',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: Theme.of(context).textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: "OpanSans",
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Transaction> _userTransactions = [
    // Transaction(
    //   id: "t1",
    //   title: "Yeni Ayakkabı",
    //   amount: 319.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t2",
    //   title: "Su Faturası",
    //   amount: 39.59,
    //   date: DateTime.now(),
    // ),
  ];

  bool _grafikGoster = false;

  List<Transaction> get _sonHarcamalar {
    return _userTransactions.where((element) {
      return element.date!.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String baslik, double fiyat, DateTime secilenTarih) {
    final yeniTx = Transaction(
      id: DateTime.now().toString(),
      title: baslik,
      amount: fiyat,
      date: secilenTarih,
    );

    setState(() {
      _userTransactions.add(yeniTx);
    });
  }

  void _yeniOdemeEkle(BuildContext context) {
    //show modal ile alttan açılan menu gibi bişey yapılabiliyor.
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _harcamaSil(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  /*
  Bir widget listesi döndüren fonksiyonun var
  bunu row ya da column da kullanabilmek için
  önüne ... nokta koy. Bu her birini listeden çıkartıp, tek tek
  çalıştırıyormuş gibi hazırlar.
   */

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //durumu denetliyor.
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    //kapatıldığında
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //tekrar tekrar render etmesin diye değişkene attık.
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              "Harcamalar",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _yeniOdemeEkle(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              "Harcamalar",
            ),
            actions: [
              IconButton(
                onPressed: () => _yeniOdemeEkle(context),
                icon: Icon(Icons.add),
              ),
            ],
          );

    final txFinalWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.6,
      child: TransactionList(_userTransactions, _harcamaSil),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //dart 2.2.2 ile geldi
            //sadece if ekleyip çalışıp çalışmayacağını söyleyebiliyoruz
            if (isLandScape)
              Row(
                children: [
                  Text(
                    "Grafiği göster",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _grafikGoster,
                      onChanged: (deger) {
                        setState(() {
                          _grafikGoster = deger;
                        });
                      }),
                ],
              ),
            if (!isLandScape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.5,
                child: Chart(_sonHarcamalar),
              ),
            if (!isLandScape) txFinalWidget,
            if (isLandScape)
              _grafikGoster
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.2,
                      child: Chart(_sonHarcamalar),
                    )
                  : txFinalWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _yeniOdemeEkle(context),
                  ),
          );
  }
}
