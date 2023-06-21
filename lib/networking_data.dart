import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeData {
  String bit_coin;
  String general_currency;
  ExchangeData(this.bit_coin, this.general_currency);
  var exchangeRate = '0';
  Future getData() async {
    final url = Uri.https('alpha-vantage.p.rapidapi.com', '/query', {
      'from_currency': bit_coin,
      'function': 'CURRENCY_EXCHANGE_RATE',
      'to_currency': general_currency
    });

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': '0d06092421msh3a19e4a040dc3ebp127c92jsn67ba100321e2',
      'X-RapidAPI-Host': 'alpha-vantage.p.rapidapi.com'
    });

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    exchangeRate =
        jsonResponse["Realtime Currency Exchange Rate"]["5. Exchange Rate"];

    print(exchangeRate);
  }
}
