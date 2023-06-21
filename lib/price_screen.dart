import 'dart:io';

import 'package:bit_coin_tracker/networking_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropdownValue = 'INR';
  String exchangeRate_BTC = '?';
  String exchangeRate_ETH = '?';
  String exchangeRate_LTC = '?';

  int selectedItem = 9;

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      // style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.lightBlue,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        updateExchangeRate(value!);
        setState(() {
          dropdownValue = value;
        });
      },
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  CupertinoPicker iosDropdown() {
    return CupertinoPicker(
        itemExtent: 36,
        scrollController: FixedExtentScrollController(
          initialItem: selectedItem,
        ),
        onSelectedItemChanged: (int index) {
          print(index);
          selectedItem = index;
        },
        children: List<Widget>.generate(currenciesList.length, (index) {
          return Center(
            child: Text(currenciesList[index]),
          );
        }));
  }

  @override
  void initState() {
    updateExchangeRate('INR');
  }

  void updateExchangeRate(String currency) async {
    String exchangerateBtc = await getExchangeRate('BTC', currency);
    String exchangerateEth = await getExchangeRate('ETH', currency);
    String exchangerateLtc = await getExchangeRate('LTC', currency);
    setState(() {
      exchangeRate_BTC = exchangerateBtc;
      exchangeRate_ETH = exchangerateEth;
      exchangeRate_LTC = exchangerateLtc;
    });
  }

  Future<String> getExchangeRate(String cryptoCoin, String currency) async {
    // print("$cryptoCoin  $currency");
    ExchangeData obj = ExchangeData(cryptoCoin, currency);

    await obj.getData();

    return double.parse(obj.exchangeRate).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑🤑🤑🤑🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              crypto_card(
                dropdownValue: dropdownValue,
                exchangeRate: exchangeRate_BTC,
                crypto_coin: 'BTC',
              ),
              crypto_card(
                dropdownValue: dropdownValue,
                exchangeRate: exchangeRate_ETH,
                crypto_coin: 'ETH',
              ),
              crypto_card(
                dropdownValue: dropdownValue,
                exchangeRate: exchangeRate_LTC,
                crypto_coin: 'LTC',
              ),
            ],
          ),
          Container(
            height: Platform.isIOS ? 250.0 : 150.0,
            // alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Center(
              child: Platform.isIOS ? iosDropdown() : getAndroidDropdown(),
            ),
          ),
        ],
      ),
    );
  }
}

class crypto_card extends StatelessWidget {
  const crypto_card(
      {super.key,
      required this.dropdownValue,
      required this.exchangeRate,
      required this.crypto_coin});

  final String dropdownValue;
  final String exchangeRate;
  final String crypto_coin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 10.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            "1 $crypto_coin =$exchangeRate  $dropdownValue",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
