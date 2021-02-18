import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AcoesScreen extends StatefulWidget {
  @override
  _AcoesScreenState createState() => _AcoesScreenState();
}

class _AcoesScreenState extends State<AcoesScreen> {
  List<Map> responses = <Map>[];

  final String baseUrl =
      'https://api.hgbrasil.com/finance/stock_price?key=48833b20&symbol=';

  Future<void> _getData() async {
    Dio dio = Dio();
    Response response1 = await dio.get(baseUrl + 'bidi4');
    responses.add(response1.data);
    Response response = await dio.get(baseUrl + 'b3sa3');
    responses.add(response.data);
    Response response2 = await dio.get(baseUrl + 'ciel3');
    responses.add(response2.data);
    Response response3 = await dio.get(baseUrl + 'petr4');
    responses.add(response3.data);
    print(responses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5C22F5),
      appBar: _appBar,
      body: _body,
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Text('BOVESPA', style: TextStyle(color: Color(0xFFF28535))),
      centerTitle: true,
      backgroundColor: Color(0xFF5C22F5),
    );
  }

  Widget get _body {
    return FutureBuilder<void>(
      future: _getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFFF28535),
                  strokeWidth: 5.0,
                ),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Erro ao carregar dados',
                style: TextStyle(color: Color(0xFFF28535)),
              ));
            } else {
              return SingleChildScrollView(
                child: Padding(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.show_chart_rounded,
                              size: 150, color: Color(0xFFF28535)),
                          _itemShowBovespaIndex(
                            responses[0]['results']['BIDI4']['name'],
                            responses[0]['results']['BIDI4']['symbol'],
                            responses[0]['results']['BIDI4']['price'],
                          ),
                          _itemShowBovespaIndex(
                              responses[1]['results']['B3SA3']['name'],
                              responses[1]['results']['B3SA3']['symbol'],
                              responses[1]['results']['B3SA3']['price']),
                          _itemShowBovespaIndex(
                              responses[2]['results']['CIEL3']['name'],
                              responses[2]['results']['CIEL3']['symbol'],
                              responses[2]['results']['CIEL3']['price']),
                          _itemShowBovespaIndex(
                              responses[3]['results']['PETR4']['name'],
                              responses[3]['results']['PETR4']['symbol'],
                              responses[3]['results']['PETR4']['price'])
                        ]),
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0)),
              );
            }
        }
      },
    );
  }

  Widget _itemShowBovespaIndex(String name, String symbol, double price) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 20,
      color: Color(0xFFF28535),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFFFFFF),
                  ),
                )
              ],
            ),
            Text(
              'R\$' + '${price.toString()}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            )
          ],
        ),
      ),
    );
  }
}
