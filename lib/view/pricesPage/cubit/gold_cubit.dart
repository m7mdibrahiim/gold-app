// import 'dart:developer';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:gold/view/pricesPage/cubit/gold_state.dart';

// class GoldCubit extends Cubit<GoldState> {
//   GoldCubit() : super(GoldInitial());

//   static GoldCubit get(context) => BlocProvider.of(context);

//   Future<void> getGoldPrices() async {
//     emit(GoldLoading());
//     try {
//       // Dio request to get gold and currency exchange rates from the API
//       var response = await Dio().get(
//           'https://api.metalpriceapi.com/v1/latest?api_key=f6da88f9f7ea19af2501254e656ef843');

//       // Extract gold price in USD per ounce (oz)
//       double goldPricePerOunceUSD = response.data['rates']['XAU'];
//       log('سعر الذهب عيار 24 بالدولار: $goldPricePerOunceUSD أونصة');

//       // Convert ounce to grams (1 ounce = 31.1035 grams)
//       double goldPricePerGramUSD = goldPricePerOunceUSD / 31.1035;
//       log('سعر الذهب عيار 24 بالجرام: $goldPricePerGramUSD دولار');

//       // Extract USD to EGP exchange rate
//       double usdToEgpRate = response.data['rates']['EGP'];
//       log('سعر الدولار مقابل الجنيه: $usdToEgpRate جنيه');

//       // Calculate the price in EGP for pure gold (24k) per gram
//       double goldPricePerGramEGP = goldPricePerGramUSD * usdToEgpRate;

//       // Calculate prices for different karats
//       double gold24k = goldPricePerGramEGP - 20;
//       double gold22k = gold24k * (22 / 24);
//       double gold21k = gold24k * (21 / 24) - (12.0);
//       double gold18k = gold24k * (18 / 24);

//       // Emit the prices in EGP and USD to EGP rate
//       emit(GoldLoaded(gold24k, gold22k, gold21k, gold18k, usdToEgpRate,
//           goldPricePerGramEGP));
//     } catch (e) {
//       emit(GoldError("فشل في جلب أسعار الذهب."));
//     }
//   }
// }
