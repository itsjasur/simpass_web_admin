// import 'dart:convert';

// import 'package:admin_simpass/sensitive.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// Future<bool> responseFilter(Response response) async {
//   int statusCode = response.statusCode;

//   if (statusCode == 200) {
//     return true;
//   }

//   if (statusCode == 401) {
//     bool refreshed = await accessTokenRefreshed();

//     if(refreshed){
//       return 
//     }
//   }

//   return false;
// }

// Uri _urlMaker(String endpoint) {
//   // print(Uri.parse(BASEURL + endpoint));
//   return Uri.parse(BASEURL + endpoint);
// }

// Future<bool> accessTokenRefreshed() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   final String? refreshToken = prefs.getString('refreshToken');
//   print("refreshtoken $refreshToken");

//   try {
//     final response = await http.post(
//       _urlMaker('auth/refreshtoken'),
//       body: {"refreshToken": refreshToken},
//       headers: {'Content-Type': 'application/json; charset=utf-8'},
//     );

//     if (response.statusCode == 200) {
//       var result = json.decode(utf8.decode(response.bodyBytes));
//       await prefs.setString('accessToken', result['accessToken']);
//       await prefs.setString('refreshToken', result['refreshToken']);

//       true;
//     }
//   } catch (e) {
//     return false;
//   }

//   return false;
// }
