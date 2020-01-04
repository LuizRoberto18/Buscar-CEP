import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String cep = "57040530";
  double opacidade = 0;
  TextEditingController controle = TextEditingController();

  getCep(){
    setState(() {
      cep =controle.text;
      opacidade = 1;
    });
  }

  Future<Map> getData() async {
    String url = "https://viacep.com.br/ws/$cep/json/";
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar cep"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (context, conexao) {
            switch (conexao.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return CircularProgressIndicator();

              default:
                if (conexao.hasError) {
                  return Column(
                    children: <Widget>[
                      Text("Deu Errado..."),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,color: Colors.green, size: 20,),
                        onPressed: () {
                          setState(() {
                            cep = "57120000";
                            opacidade = 0;
                          });
                        },
                      ),
                    ],
                  );
                } else
                  return Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: controle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Digite um CEP",
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        Divider(height: 20,),
                        RaisedButton(
                          child: Text("Pesquisar", style:  TextStyle(color: Colors.white),),
                          color: Colors.green,
                          onPressed: getCep(),
                        ),
                        Divider(height: 20),
                        AnimatedOpacity(
                          opacity: opacidade,
                          duration:Duration(seconds: 3),
                          child: Column(
                            children: <Widget>[
                              Text(conexao.data["cep"]),
                              Text(conexao.data["logradouro"]),
                              Text(conexao.data["bairro"]),
                              Text(conexao.data["localidade"]),
                              Text(conexao.data["uf"]),

                            ],
                          ),
                        )
                      ],
                    ),
                  );
            }
          },
        ),
      ),
    );
  }
}
