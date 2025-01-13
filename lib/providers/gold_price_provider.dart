import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GoldPriceProvider extends ChangeNotifier {
  double? pricePerGram24sale;
  double? pricePerGram24buy;
  double? pricePerGram22sale;
  double? pricePerGram21sale;
  double? pricePerGram20sale;
  double? pricePerGram18sale;
  double? pricePerGram16sale;
  double? pricePerGram14sale;
  double? pricePerGram10sale;
  int? timestamp;

  bool isLoading = false;
  bool hasError = false;

  Future<void> fetchGoldPrice() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      var response = await Dio().get('https://www.goldapi.io/api/XAU/EGP',
          options: Options(headers: {
            'x-access-token': 'goldapi-1esnb5ksm1oxup7b-iom',
          }));
      var data = response.data;
      pricePerGram24sale = data['price_gram_24k'];
      pricePerGram24buy = data['price_gram_24k'];
      pricePerGram22sale = data['price_gram_22k'];
      pricePerGram21sale = data['price_gram_21k'];
      pricePerGram20sale = data['price_gram_20k'];
      pricePerGram18sale = data['price_gram_18k'];
      pricePerGram16sale = data['price_gram_16k'];
      pricePerGram14sale = data['price_gram_14k'];
      pricePerGram10sale = data['price_gram_10k'];
      timestamp = data['timestamp'];
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
      print('Error fetching gold price: $e');
    }
  }
}
