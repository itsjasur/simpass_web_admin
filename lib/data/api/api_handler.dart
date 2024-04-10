import 'dart:convert';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/sensitive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  Uri _urlMaker(String endpoint) {
    // print(Uri.parse(BASEURL + endpoint));
    return Uri.parse(BASEURL + endpoint);
  }

  Future<Map<String, dynamic>?> request({required BuildContext context, required String urlAddition, Map<String, dynamic>? body}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? "";

    var headers = {
      'Content-Type': 'application/json',
      'Athorization': accessToken,
    };

    return null;

    // try {

    //   print('request called 1');

    //   final response = await http.post(_urlMaker('auth/$urlAddition'), body: json.encode(body), headers: headers);

    //   if (response.statusCode == 400) {
    //     throw Exception('Request parameters are wrong');
    //   }

    //   //RETURNING THE DATA ONLY IF THE STATUS CODE IS 200
    //   if (response.statusCode == 200) {
    //     return json.decode(response.body);
    //   }

    //   //THIS TRIES TO REFRESH ACCESS TOKEN
    //   if (response.statusCode == 401) {
    //     String? newAccessToken = await _accessTokenRefreshed();

    //     if (newAccessToken != null) {
    //       headers['Authorization'] = 'Bearer $newAccessToken';
    //       final response = await http.post(_urlMaker('auth/$urlAddition'), body: body, headers: headers);

    //       //RETURNS DATA IF REFRESH TOKEN SUCCESS AND GETS 200
    //       if (response.statusCode == 200) {
    //         return json.decode(response.body);
    //       } else {
    //         if (context.mounted) Provider.of<AuthServiceProvider>(context, listen: false).logout();
    //       }
    //     }
    //   }
    // } catch (e) {
    //   throw Exception(e);
    // }

    throw Exception('Request failed. Please try again later');
  }

  Future<String?> _accessTokenRefreshed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      final response = await http.post(_urlMaker('auth/refreshtoken'), body: {"refreshToken": refreshToken});

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        await prefs.setString('accessToken', result['accessToken']);
        await prefs.setString('refreshToken', result['refreshToken']);

        return result['accessToken'];
      }
    }

    return null;
  }
}
