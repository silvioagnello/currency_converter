import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

var request = Uri.parse(
    "https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL,GBP-BRL");

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code
    return MaterialApp(
      title: 'Currency Converter',
      home: const Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final realController = TextEditingController();
  final euroController = TextEditingController();
  final btcController = TextEditingController();
  final dolaController = TextEditingController();
  final gbpController = TextEditingController();

  double dollar = 0.00;
  double euro = 0.00;
  double btc = 0.00;
  double gbp = 0.00;

  void _clearAll() {
    realController.text = gbpController.text =
        dolaController.text = euroController.text = btcController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double real = double.parse(text);
      double dr2 = (real / dollar);
      double dr3 = (real / euro);
      double dr1 = (real / btc);
      double dr4 = (real / gbp);
      dolaController.text = dr2.toStringAsFixed(2);
      euroController.text = dr3.toStringAsFixed(2);
      btcController.text = dr1.toStringAsFixed(10);
      gbpController.text = dr4.toStringAsFixed(2);
    }
  }

  void _dolaChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double dollar = double.parse(text);
      double dr2 = (this.dollar);
      double dr3 = ((this.dollar * dollar) / euro);
      double dr1 = ((this.dollar * dollar) / btc);
      double dr4 = ((this.dollar * dollar) / gbp);
      realController.text = dr2.toStringAsFixed(2);
      euroController.text = dr3.toStringAsFixed(2);
      gbpController.text = dr4.toStringAsFixed(2);
      btcController.text = dr1.toStringAsFixed(10);
    }
  }

  void _gbpChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double gbp = double.parse(text);
      double dr1 = (this.gbp);
      double dr2 = ((gbp * this.gbp) / dollar);
      double dr3 = ((gbp * this.gbp) / euro);
      double dr4 = ((gbp * this.gbp) / btc);
      realController.text = dr1.toStringAsFixed(2);
      dolaController.text = dr2.toStringAsFixed(2);
      euroController.text = dr3.toStringAsFixed(2);
      btcController.text = dr4.toStringAsFixed(10);
    }
  }

  void _btcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double btc = double.parse(text);
      double dr1 = (btc * this.btc);
      double dr2 = ((btc * this.btc) / dollar);
      double dr3 = ((btc * this.btc) / euro);
      double dr4 = ((btc * this.btc) / gbp);
      realController.text = dr1.toStringAsFixed(2);
      dolaController.text = dr2.toStringAsFixed(2);
      euroController.text = dr3.toStringAsFixed(2);
      gbpController.text = dr4.toStringAsFixed(2);
    }
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double euro = double.parse(text);
      double dr1 = (this.euro * euro);
      double dr2 = ((this.euro * euro) / dollar);
      double dr3 = (this.euro / btc);
      double dr4 = (this.euro / gbp);
      realController.text = dr1.toStringAsFixed(2);
      dolaController.text = dr2.toStringAsFixed(2);
      btcController.text = dr3.toStringAsFixed(10);
      gbpController.text = dr4.toStringAsFixed(2);
    }
  }

//late FocusNode myFocusNode;
  // @override
  // void initState() {
  //   super.initState();
  //   myFocusNode = FocusNode();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text('Carregando Dados...',
                      style: TextStyle(fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              case ConnectionState.active:
                return Container(color: Colors.green);
              case ConnectionState.done:
                String txdolar = snapshot.data!["USDBRL"]["high"];
                String txeuro = snapshot.data!["EURBRL"]["high"];
                String txbtc = snapshot.data!["BTCBRL"]["high"];
                String txgbp = snapshot.data!["GBPBRL"]["high"];
                dollar = double.parse(txdolar);
                euro = double.parse(txeuro);
                btc = double.parse(txbtc);
                gbp = double.parse(txgbp);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildTextField("Digite Aqui (Valores em REAIS)",
                              "R\$ ", realController, _realChanged),
                          buildTextField("Digite Aqui (Valores em DOLLARES)",
                              "US\$ ", dolaController, _dolaChanged),
                          buildTextField("Digite Aqui (Valores em EUROS)",
                              "€\$ ", euroController, _euroChanged),
                          buildTextField("Digite Aqui (Valores em LIBRAS)",
                              "£\$ ", gbpController, _gbpChanged),
                          buildTextField("Digite Aqui (Valores em BTCS)",
                              "BTC\$ ", btcController, _btcChanged),
                        ]),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar dados!!!',
                          style: TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.center));
                } else {
                  return Container(color: Colors.blue);
                }
            }
          }),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("\$Conversor\$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }

  Widget buildTextField(String label, String prefix,
      TextEditingController controlador, Function(String) f) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextField(
          //focusNode: myFocusNode,
          onChanged: f,
          controller: controlador,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: label, //,
              labelStyle: const TextStyle(color: Colors.amber),
              border: const OutlineInputBorder(),
              prefixText: prefix), //"R\$ "),
          style: const TextStyle(color: Colors.amber, fontSize: 25.0)),
    );
  }
}
