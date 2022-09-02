import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String symbol;
String request =
    "https://api.hgbrasil.com/finance/stock_price?key=2a34b926&symbol=" +
        symbol;

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final acaoController = TextEditingController();
  final simboloController = TextEditingController();

  _simboloChange(String text) {
    acaoController.text = "";
    symbol = text;
  }

  _buscar(data) {
    String resposta = "- Nome da ação:\n";
    resposta += "\t\t\t" + data["name"];
    resposta += "\n\n- Preço:\n";
    resposta += "\t\t\t" + data["price"].toString();
    resposta += "\n\n- Website:\n";
    resposta += "\t\t\t" + data["website"];
    acaoController.text = resposta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("App Bolsa de Valores"),
            centerTitle: true,
            backgroundColor: Colors.amber),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
              Divider(),
              buildTextFormField("Informe o símbolo da ação", simboloController,
                  _simboloChange),
              Divider(),
              TextButton(
                child: const Text(
                  "Buscar",
                  style: TextStyle(fontSize: 40.0, color: Colors.amber),
                ),
                onPressed: () async {
                  try {
                    http.Response response = await http.get(request);
                    Map<dynamic, dynamic> snapshot = json.decode(response.body);
                    _buscar(snapshot["results"][symbol.toUpperCase()]);
                  } catch (e) {
                    acaoController.text = "Ação não encontrada!";                      
                  }
                },
              ),
              Divider(),
              Divider(),
              TextField(
                  controller: acaoController,
                  decoration: InputDecoration(
                    border: InputBorder.none
                  ),
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  keyboardType: TextInputType.none)
            ],
          ),
        ));
  }
}

Widget buildTextFormField(
    String label, TextEditingController controller, Function f) {
  return TextField(
    onChanged: f,
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder()),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    keyboardType: TextInputType.text,
  );
}
