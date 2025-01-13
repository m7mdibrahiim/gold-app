// import 'package:flutter/material.dart';
// import 'package:gold/view/pricesPage/price_page.dart';
// import 'package:gold/view/countries/uae_page.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart'; // مكتبة لتحويل التاريخ
// import 'dart:ui' as ui;

// class SaudiPage extends StatefulWidget {
//   const SaudiPage({super.key});

//   @override
//   _GoldPriceWidgetState createState() => _GoldPriceWidgetState();
// }

// class _GoldPriceWidgetState extends State<SaudiPage> {
//   final GoldPrice goldPrice = GoldPrice();
//   double? priceEGP;
//   String? formattedDate;
//   String selectedCountry = 'Saudi Arabia';

//   final Map<String, String> countries = {
//     'Egypt': '🇪🇬',
//     'Saudi Arabia': '🇸🇦',
//     'UAE': '🇦🇪',
//   };
//   @override
//   void initState() {
//     super.initState();
//     fetchGoldPrices();
//     _loadPriceEGP();
//   }

//   Future<void> fetchGoldPrices() async {
//     await goldPrice.fetchGoldPrice();
//     setState(() {
//       formattedDate = _formatTimestamp(goldPrice.timestamp); // تنسيق التاريخ
//     });
//   }

//   Future<void> _loadPriceEGP() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       priceEGP = prefs.getDouble('priceEGP') ?? 1.0;
//     });
//   }

//   String _formatTimestamp(int? timestamp) {
//     if (timestamp == null) return "غير متوفر";
//     var date = DateTime.fromMillisecondsSinceEpoch(
//         timestamp * 1000); // تحويل الـ timestamp إلى تاريخ
//     return DateFormat('yyyy-MM-dd  HH:mm').format(date); // تنسيق التاريخ
//   }

//   void _navigateToCountryPage(String country) {
//     switch (country) {
//       case 'Egypt':
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   const GoldPriceWidget()), // توجيه إلى صفحة مصر
//         );
//         break;
//       case 'Saudi Arabia':
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const SaudiPage()), // توجيه إلى صفحة أمريكا
//         );
//         break;
//       case 'UAE':
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const UAEPage()), // توجيه إلى صفحة بريطانيا
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: ui.TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text(
//             'أسعار الذهب',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 206, 204, 200),
//                   Color.fromARGB(255, 1, 140, 22),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           leading: IconButton(
//             onPressed: () async {
//               //    await USDPrice().fetchGoldPrice();
//               await fetchGoldPrices(); // تأكد من تحديث الأسعار
//               await _loadPriceEGP(); // تحديث السعر بعد جلبه
//             },
//             icon: const Icon(
//               Icons.refresh,
//             ),
//             color: Colors.black,
//             iconSize: 28,
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: DropdownButton<String>(
//                 value: selectedCountry,
//                 icon: Text(
//                   countries[selectedCountry] ?? '🌍', // عرض رمز الدولة
//                   style: const TextStyle(
//                     fontSize: 30,
//                   ),
//                 ),
//                 underline: Container(), // إزالة الخط السفلي
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedCountry = newValue!;
//                     _navigateToCountryPage(
//                         selectedCountry); // الانتقال إلى صفحة الدولة
//                   });
//                 },
//                 items: countries.keys.map((String country) {
//                   return DropdownMenuItem<String>(
//                     value: country,
//                     child: Text(countries[country] ?? ''),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//           // actions: [
//           //   IconButton(
//           //     onPressed: () async {
//           //       await USDPrice().fetchGoldPrice();
//           //       await fetchGoldPrices(); // تأكد من تحديث الأسعار
//           //       await _loadPriceEGP(); // تحديث السعر بعد جلبه
//           //     },
//           //     icon: Icon(
//           //       Icons.refresh,
//           //     ),
//           //     color: Colors.black,
//           //     iconSize: 28,
//           //   ),
//           // ],
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 141, 140, 138),
//                 Color.fromARGB(255, 38, 123, 4),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Center(
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 const SizedBox(height: 16),
//                 Text(
//                   'آخر تحديث: $formattedDate',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildGoldPriceCard(
//                   'سعر الذهب عيار 24',
//                   (goldPrice.pricePerGram24sale ?? 0.0),
//                   // * (priceEGP ?? 1.0),
//                   (goldPrice.pricePerGram24buy ?? 0.0) *
//                       // (priceEGP ?? 1.0) *
//                       .99720,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildGoldPriceCard(
//                   'سعر الذهب عيار 21',
//                   (goldPrice.pricePerGram21sale ?? 0.0),
//                   // * (priceEGP ?? 1.0),
//                   (goldPrice.pricePerGram24buy ?? 0.0) *
//                       // (priceEGP ?? 1.0) *
//                       .99720 *
//                       21 /
//                       24,
//                   // (goldPrice.pricePerGram21buy ?? 0.0) * (priceEGP ?? 1.0),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildGoldPriceCard(
//                   'سعر الذهب عيار 18',
//                   (goldPrice.pricePerGram18sale ?? 0.0),
//                   // * (priceEGP ?? 1.0),
//                   (goldPrice.pricePerGram24buy ?? 0.0) *
//                       // (priceEGP ?? 1.0) *
//                       .99720 *
//                       18 /
//                       24,
//                   //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildGoldPriceInfoCard(),
//               ],
//             ),
//           ),
//         ),
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: () async {
//         //     await USDPrice().fetchGoldPrice();
//         //     await fetchGoldPrices(); // تأكد من تحديث الأسعار
//         //     await _loadPriceEGP(); // تحديث السعر بعد جلبه
//         //   },
//         //   child: const Icon(
//         //     Icons.refresh,
//         //     size: 25,
//         //   ),
//         //   backgroundColor: const Color.fromARGB(255, 255, 164, 18),
//         // ),
//       ),
//     );
//   }

//   Widget _buildGoldPriceCard(String title, double salePrice, double buyPrice) {
//     return Card(
//       elevation: 5,
//       color: Colors.black38,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(color: Colors.grey.shade300, width: 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.amber[700], // لون ذهبي
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Text(
//                   'سعر البيع:  ',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   ' ${salePrice.toStringAsFixed(2)} جنيها',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text(
//                   'سعر الشراء: ',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[200], // لون فضي
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '  ${buyPrice.toStringAsFixed(2)} جنيها',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[200], // لون فضي
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGoldPriceInfoCard() {
//     return Card(
//       elevation: 5,
//       color: Colors.black38,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(color: Colors.grey.shade300, width: 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'معلومات إضافية عن سعر الذهب',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 8),
//             _buildGoldInfoRow(
//                 'السعر الحالي:', (goldPrice.price ?? 0.0) * (priceEGP ?? 1.0)),
//             _buildGoldInfoRow('سعر الإغلاق السابق:',
//                 (goldPrice.prevClosePrice ?? 0.0) * (priceEGP ?? 1.0)),
//             _buildGoldInfoRow('أدنى سعر اليوم:',
//                 (goldPrice.lowPrice ?? 0.0) * (priceEGP ?? 1.0)),
//             _buildGoldInfoRow('أعلى سعر اليوم:',
//                 (goldPrice.highPrice ?? 0.0) * (priceEGP ?? 1.0)),
//             _buildGoldInfoRow(
//                 'التغيير:', (goldPrice.change ?? 0.0) * (priceEGP ?? 1.0)),
//             _buildGoldInfoRow('نسبة التغيير:', goldPrice.changePercent ?? 1),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGoldInfoRow(String label, double value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             value.toStringAsFixed(2),
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade200,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GoldPrice {
//   double? pricePerGram24sale;
//   double? pricePerGram21sale;
//   double? pricePerGram18sale;
//   double? pricePerGram24buy;
//   double? pricePerGram21buy;
//   double? pricePerGram18buy;
//   double? price;
//   double? prevClosePrice;
//   double? lowPrice;
//   double? highPrice;
//   double? change;
//   double? changePercent;
//   int? timestamp; // إضافة متغير timestamp

//   Future<void> fetchGoldPrice() async {
//     final Dio dio = Dio();
//     final response = await dio.get(
//       'https://www.goldapi.io/api/XAU/SAR',
//       options: Options(
//         headers: {
//           'x-access-token': 'goldapi-1esnb5ksm1oxup7b-io',
//         },
//       ),
//     );

//     if (response.statusCode == 200) {
//       final data = response.data;

//       price = data['price'];
//       prevClosePrice = data['prev_close_price'];
//       lowPrice = data['low_price'];
//       highPrice = data['high_price'];
//       change = data['ch'];
//       changePercent = data['chp'];
//       timestamp = data['timestamp']; // جلب timestamp

//       pricePerGram24sale = data['price_gram_24k'];
//       pricePerGram21sale = data['price_gram_21k'];
//       pricePerGram18sale = data['price_gram_18k'];

//       pricePerGram24buy = pricePerGram24sale;
//       pricePerGram21buy = pricePerGram21sale;
//       pricePerGram18buy = pricePerGram18sale;
//     } else {
//       throw Exception('فشل في جلب سعر الذهب');
//     }
//   }
// }

// class USDPrice {
//   Future<void> fetchGoldPrice() async {
//     final response = await http.get(Uri.parse(
//         'https://api.metalpriceapi.com/v1/latest?api_key=f6da88f9f7ea19af2501254e656ef843'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       double priceEGP = data['rates']['EGP'];
//       await _savePriceEGP(priceEGP);
//     } else {
//       throw Exception('فشل في جلب سعر الذهب');
//     }
//   }

//   Future<void> _savePriceEGP(double priceEGP) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('priceEGP', priceEGP);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gold/view/countries/uae_page.dart';
import 'package:gold/view/pricesPage/price_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // مكتبة لتحويل التاريخ
import 'dart:ui' as ui;

class SaudiPage extends StatefulWidget {
  const SaudiPage({super.key});

  @override
  _GoldPriceWidgetState createState() => _GoldPriceWidgetState();
}

class _GoldPriceWidgetState extends State<SaudiPage> {
  final GoldPrice goldPrice = GoldPrice();
  final SliverPrice sliverPrice = SliverPrice();
  double? priceEGP;
  String? formattedDate;
  String selectedCountry = 'Saudi Arabia';

  final Map<String, String> countries = {
    'Egypt': '🇪🇬',
    'Saudi Arabia': '🇸🇦',
    'UAE': '🇦🇪',
  };
  @override
  void initState() {
    super.initState();
    fetchGoldPrices();
    fetchSliverPrices();
    _loadPriceEGP();
  }

  Future<void> fetchGoldPrices() async {
    await goldPrice.fetchGoldPrice();
    setState(() {
      formattedDate = _formatTimestamp(goldPrice.timestamp); // تنسيق التاريخ
    });
  }

  Future<void> fetchSliverPrices() async {
    await sliverPrice.fetchSliverPrice();
    setState(() {
      formattedDate = _formatTimestamp(sliverPrice.timestamp); // تنسيق التاريخ
    });
  }

  Future<void> _loadPriceEGP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      priceEGP = prefs.getDouble('priceEGP') ?? 1.0;
    });
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return "غير متوفر";
    var date = DateTime.fromMillisecondsSinceEpoch(
        timestamp * 1000); // تحويل الـ timestamp إلى تاريخ
    return DateFormat('yyyy-MM-dd  HH:mm').format(date); // تنسيق التاريخ
  }

  void _navigateToCountryPage(String country) {
    switch (country) {
      case 'Egypt':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const GoldPriceWidget()), // توجيه إلى صفحة مصر
        );
        break;
      case 'Saudi Arabia':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SaudiPage()), // توجيه إلى صفحة أمريكا
        );
        break;
      case 'UAE':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const UAEPage()), // توجيه إلى صفحة بريطانيا
        );
        break;
    }
  }

  // void _navigateToMetalPage(String country) {
  //   switch (country) {
  //     case 'أسعار الذهب':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 const GoldPriceWidget()), // توجيه إلى صفحة مصر
  //       );
  //       break;
  //     case 'أسعار الفضة':
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => const SaudiPage()), // توجيه إلى صفحة أمريكا
  //       );
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'أسعار الذهب',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 206, 204, 200),
                  Color.fromARGB(255, 1, 140, 22),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              //    await USDPrice().fetchGoldPrice();
              await fetchGoldPrices(); // تأكد من تحديث الأسعار
              await _loadPriceEGP(); // تحديث السعر بعد جلبه
            },
            icon: const Icon(
              Icons.refresh,
            ),
            color: Colors.black,
            iconSize: 28.sp,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: selectedCountry,
                icon: Text(
                  countries[selectedCountry] ?? '🌍', // عرض رمز الدولة
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                underline: Container(), // إزالة الخط السفلي
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                    _navigateToCountryPage(
                        selectedCountry); // الانتقال إلى صفحة الدولة
                  });
                },
                items: countries.keys.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(countries[country] ?? ''),
                  );
                }).toList(),
              ),
            ),
          ],
          // actions: [
          //   IconButton(
          //     onPressed: () async {
          //       await USDPrice().fetchGoldPrice();
          //       await fetchGoldPrices(); // تأكد من تحديث الأسعار
          //       await _loadPriceEGP(); // تحديث السعر بعد جلبه
          //     },
          //     icon: Icon(
          //       Icons.refresh,
          //     ),
          //     color: Colors.black,
          //     iconSize: 28,
          //   ),
          // ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 141, 140, 138),
                Color.fromARGB(255, 38, 123, 4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                SizedBox(height: 12.h),
                Text(
                  'آخر تحديث: $formattedDate',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 24',
                  (goldPrice.pricePerGram24sale ?? 0.0),

                  // * (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //     (priceEGP ?? 1.0)
                      //  *
                      .99720,
                  Colors.amber[700],
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 22',
                  (goldPrice.pricePerGram22sale ?? 0.0),

                  // * (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //     (priceEGP ?? 1.0)
                      //  *
                      .99720 *
                      22 /
                      24,
                  Colors.amber[700],
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 21',
                  (goldPrice.pricePerGram21sale ?? 0.0),
                  //* (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //  (priceEGP ?? 1.0) *
                      .99720 *
                      21 /
                      24,
                  Colors.amber[700],
                  // (goldPrice.pricePerGram21buy ?? 0.0) * (priceEGP ?? 1.0),
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 20',
                  (goldPrice.pricePerGram20sale ?? 0.0),
                  //* (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //  (priceEGP ?? 1.0) *
                      .99720 *
                      20 /
                      24,
                  Colors.amber[700],
                  // (goldPrice.pricePerGram21buy ?? 0.0) * (priceEGP ?? 1.0),
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 18',
                  (goldPrice.pricePerGram18sale ?? 0.0),
                  ////  * (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //    (priceEGP ?? 1.0) *
                      .99720 *
                      18 /
                      24,
                  Colors.amber[700],
                  //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 16',
                  (goldPrice.pricePerGram16sale ?? 0.0),
                  ////  * (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //    (priceEGP ?? 1.0) *
                      .99720 *
                      16 /
                      24,
                  Colors.amber[700],
                  //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 14',
                  (goldPrice.pricePerGram14sale ?? 0.0),
                  ////  * (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //    (priceEGP ?? 1.0) *
                      .99720 *
                      14 /
                      24,
                  Colors.amber[700],
                  //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                  'سعر الذهب عيار 10',
                  (goldPrice.pricePerGram10sale ?? 0.0),
                  ////  * (priceEGP ?? 1.0),
                  (goldPrice.pricePerGram24buy ?? 0.0) *
                      //    (priceEGP ?? 1.0) *
                      .99720 *
                      10 /
                      24,
                  Colors.amber[700],
                  //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                ),
                SizedBox(height: 20.h),
                _buildGoldPriceInfoCard(),
////
                ///
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: Text(
                    "أسعار الفضة",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ////////
                SizedBox(height: 12.h),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 24',
                    (sliverPrice.pricePerGram24sale ?? 0.0),

                    // * (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //     (priceEGP ?? 1.0)
                        //  *
                        .99720,
                    const Color.fromARGB(255, 218, 247, 255)),

                SizedBox(height: 16.h),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 22',
                    (sliverPrice.pricePerGram22sale ?? 0.0),

                    // * (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //     (priceEGP ?? 1.0)
                        //  *
                        .99720 *
                        22 /
                        24,
                    const Color.fromARGB(255, 218, 247, 255)),
                SizedBox(height: 16.h),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 21',
                    (sliverPrice.pricePerGram21sale ?? 0.0),
                    //* (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //  (priceEGP ?? 1.0) *
                        .99720 *
                        21 /
                        24,
                    const Color.fromARGB(255, 218, 247,
                        255) // (goldPrice.pricePerGram21buy ?? 0.0) * (priceEGP ?? 1.0),
                    ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 20',
                    (sliverPrice.pricePerGram20sale ?? 0.0),
                    //* (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //  (priceEGP ?? 1.0) *
                        .99720 *
                        20 /
                        24,
                    const Color.fromARGB(255, 218, 247,
                        255) // (goldPrice.pricePerGram21buy ?? 0.0) * (priceEGP ?? 1.0),
                    ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 18',
                    (sliverPrice.pricePerGram18sale ?? 0.0),
                    ////  * (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //    (priceEGP ?? 1.0) *
                        .99720 *
                        18 /
                        24,
                    const Color.fromARGB(255, 218, 247,
                        255) //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                    ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 16',
                    (sliverPrice.pricePerGram16sale ?? 0.0),
                    ////  * (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //    (priceEGP ?? 1.0) *
                        .99720 *
                        16 /
                        24,
                    const Color.fromARGB(255, 218, 247,
                        255) //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                    ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 14',
                    (sliverPrice.pricePerGram14sale ?? 0.0),
                    ////  * (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //    (priceEGP ?? 1.0) *
                        .99720 *
                        14 /
                        24,
                    const Color.fromARGB(255, 218, 247, 255)
                    //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                    ),
                const SizedBox(height: 16),
                _buildGoldPriceCard(
                    'سعر الفضة عيار 10',
                    ////  * (priceEGP ?? 1.0),
                    (sliverPrice.pricePerGram10sale ?? 0.0),
                    (sliverPrice.pricePerGram24buy ?? 0.0) *
                        //    (priceEGP ?? 1.0) *
                        .99720 *
                        10 /
                        24,
                    const Color.fromARGB(255, 218, 247, 255)
                    //    (goldPrice.pricePerGram18buy ?? 0.0) * (priceEGP ?? 1.0),
                    ),
                SizedBox(height: 20.h),
                //  _buildGoldPriceInfoCard(),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await USDPrice().fetchGoldPrice();
        //     await fetchGoldPrices(); // تأكد من تحديث الأسعار
        //     await _loadPriceEGP(); // تحديث السعر بعد جلبه
        //   },
        //   child: const Icon(
        //     Icons.refresh,
        //     size: 25,
        //   ),
        //   backgroundColor: const Color.fromARGB(255, 255, 164, 18),
        // ),
      ),
    );
  }

  Widget _buildGoldPriceCard(
    String title,
    double salePrice,
    double buyPrice,
    Color? color,
  ) {
    return Card(
      elevation: 5,
      color: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300, width: 1.w),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: color // لون ذهبي
                  ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'سعر البيع:  ',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  ' ${salePrice.toStringAsFixed(2)} جنيها',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'سعر الشراء: ',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey[200], // لون فضي
                  ),
                ),
                const Spacer(),
                Text(
                  '  ${buyPrice.toStringAsFixed(2)} جنيها',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey[200], // لون فضي
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldPriceInfoCard() {
    return Card(
      elevation: 5,
      color: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300, width: 1.w),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'معلومات إضافية عن سعر الذهب',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            _buildGoldInfoRow('سعر الاونصه:', (goldPrice.price ?? 0.0)),
            //* (priceEGP ?? 1.0)),
            // _buildGoldInfoRow('سعر الإغلاق السابق:',
            //     (goldPrice.prevClosePrice ?? 0.0) * (priceEGP ?? 1.0)),
            // _buildGoldInfoRow('أدنى سعر اليوم:',
            //     (goldPrice.lowPrice ?? 0.0) * (priceEGP ?? 1.0)),
            // _buildGoldInfoRow('أعلى سعر اليوم:',
            //     (goldPrice.highPrice ?? 0.0) * (priceEGP ?? 1.0)),
            _buildGoldInfoRow('التغيير:', (goldPrice.change ?? 0.0)),
            // * (priceEGP ?? 1.0)),
            //   _buildGoldInfoRow('نسبة التغيير:', goldPrice.changePercent ?? 1),          ],
          ],
        ),
      ),
    );
  }

  // Widget _buildSliverPriceInfoCard() {
  //   return Card(
  //     elevation: 5,
  //     color: Colors.black38,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       side: BorderSide(color: Colors.grey.shade300, width: 1.w),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'معلومات إضافية عن سعر الفضة',
  //             style: TextStyle(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           SizedBox(height: 8.h),
  //           _buildGoldInfoRow(
  //               'سعر الاونصه:', (sliverPrice.price ?? 0.0) * (priceEGP ?? 1.0)),
  //           // _buildGoldInfoRow('سعر الإغلاق السابق:',
  //           //     (goldPrice.prevClosePrice ?? 0.0) * (priceEGP ?? 1.0)),
  //           // _buildGoldInfoRow('أدنى سعر اليوم:',
  //           //     (goldPrice.lowPrice ?? 0.0) * (priceEGP ?? 1.0)),
  //           // _buildGoldInfoRow('أعلى سعر اليوم:',
  //           //     (goldPrice.highPrice ?? 0.0) * (priceEGP ?? 1.0)),
  //           _buildGoldInfoRow(
  //               'التغيير:', (sliverPrice.change ?? 0.0) * (priceEGP ?? 1.0)),
  //           //   _buildGoldInfoRow('نسبة التغيير:', goldPrice.changePercent ?? 1),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGoldInfoRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}

class GoldPrice {
  double? pricePerGram24sale;
  double? pricePerGram22sale;
  double? pricePerGram21sale;
  double? pricePerGram20sale;
  double? pricePerGram18sale;
  double? pricePerGram16sale;
  double? pricePerGram14sale;
  double? pricePerGram10sale;

  double? pricePerGram24buy;
  double? pricePerGram22buy;
  double? pricePerGram21buy;
  double? pricePerGram20buy;
  double? pricePerGram18buy;
  double? pricePerGram16buy;
  double? pricePerGram14buy;
  double? pricePerGram10buy;

  double? price;
  double? prevClosePrice;
  double? lowPrice;
  double? highPrice;
  double? change;
  double? changePercent;
  int? timestamp; // إضافة متغير timestamp

  Future<void> fetchGoldPrice() async {
    final Dio dio = Dio();
    final response = await dio.get(
      'https://www.goldapi.io/api/XAU/SAR',
      options: Options(
        headers: {
          'x-access-token': 'goldapi-1esnb5ksm1oxup7b-io',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;

      price = data['price'];
      prevClosePrice = data['prev_close_price'];
      lowPrice = data['low_price'];
      highPrice = data['high_price'];
      change = data['ch'];
      changePercent = data['chp'];
      timestamp = data['timestamp']; // جلب timestamp

      pricePerGram24sale = data['price_gram_24k'];
      pricePerGram22sale = data['price_gram_22k'];

      pricePerGram21sale = data['price_gram_21k'];
      pricePerGram20sale = data['price_gram_20k'];

      pricePerGram18sale = data['price_gram_18k'];
      pricePerGram16sale = data['price_gram_16k'];
      pricePerGram14sale = data['price_gram_14k'];
      pricePerGram10sale = data['price_gram_10k'];

      pricePerGram24buy = pricePerGram24sale;
      pricePerGram22buy = pricePerGram22sale;
      pricePerGram21buy = pricePerGram21sale;
      pricePerGram20buy = pricePerGram20sale;
      pricePerGram18buy = pricePerGram18sale;
      pricePerGram16buy = pricePerGram16sale;
      pricePerGram14buy = pricePerGram14sale;
      pricePerGram10buy = pricePerGram10sale;
    } else {
      throw Exception('فشل في جلب سعر الذهب');
    }
  }
}

class SliverPrice {
  double? pricePerGram24sale;
  double? pricePerGram22sale;
  double? pricePerGram21sale;
  double? pricePerGram20sale;
  double? pricePerGram18sale;
  double? pricePerGram16sale;
  double? pricePerGram14sale;
  double? pricePerGram10sale;

  double? pricePerGram24buy;
  double? pricePerGram22buy;
  double? pricePerGram21buy;
  double? pricePerGram20buy;
  double? pricePerGram18buy;
  double? pricePerGram16buy;
  double? pricePerGram14buy;
  double? pricePerGram10buy;

  double? price;
  double? prevClosePrice;
  double? lowPrice;
  double? highPrice;
  double? change;
  double? changePercent;
  int? timestamp; // إضافة متغير timestamp

  Future<void> fetchSliverPrice() async {
    final Dio dio = Dio();
    final response = await dio.get(
      'https://www.goldapi.io/api/XAG/SAR',
      options: Options(
        headers: {
          'x-access-token': 'goldapi-1esnb5ksm1oxup7b-io',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;

      price = data['price'];
      prevClosePrice = data['prev_close_price'];
      lowPrice = data['low_price'];
      highPrice = data['high_price'];
      change = data['ch'];
      changePercent = data['chp'];
      timestamp = data['timestamp']; // جلب timestamp

      pricePerGram24sale = data['price_gram_24k'];
      pricePerGram22sale = data['price_gram_22k'];

      pricePerGram21sale = data['price_gram_21k'];
      pricePerGram20sale = data['price_gram_20k'];

      pricePerGram18sale = data['price_gram_18k'];
      pricePerGram16sale = data['price_gram_16k'];
      pricePerGram14sale = data['price_gram_14k'];
      pricePerGram10sale = data['price_gram_10k'];

      pricePerGram24buy = pricePerGram24sale;
      pricePerGram22buy = pricePerGram22sale;
      pricePerGram21buy = pricePerGram21sale;
      pricePerGram20buy = pricePerGram20sale;
      pricePerGram18buy = pricePerGram18sale;
      pricePerGram16buy = pricePerGram16sale;
      pricePerGram14buy = pricePerGram14sale;
      pricePerGram10buy = pricePerGram10sale;
    } else {
      throw Exception('فشل في جلب سعر الذهب');
    }
  }
}

class USDPrice {
  Future<void> fetchGoldPrice() async {
    final response = await http.get(Uri.parse(
        'https://api.metalpriceapi.com/v1/latest?api_key=f6da88f9f7ea19af2501254e656ef843m'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      double priceEGP = data['rates']['EGP'];
      await _savePriceEGP(priceEGP);
    } else {
      throw Exception('فشل في جلب سعر الذهب');
    }
  }

  Future<void> _savePriceEGP(double priceEGP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('priceEGP', priceEGP);
  }
}
