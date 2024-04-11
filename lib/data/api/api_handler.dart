import 'dart:async';
import 'dart:convert';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/sensitive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  Uri _urlMaker(String endpoint) {
    // print(Uri.parse(BASEURL + endpoint));
    return Uri.parse(BASEURL + endpoint);
  }

  Future<Map<String, dynamic>?> request({
    required BuildContext context,
    required String urlAddition,
    Map<String, dynamic>? body,
    bool isProtected = false,
    String type = 'POST',
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? "";

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };
    if (isProtected) headers['Authorization'] = 'Bearer $accessToken';

    print(headers);

    late Response response;

    try {
      if (type == 'GET') {
        response = await http.get(_urlMaker(urlAddition), headers: headers);
      } else {
        response = await http.post(_urlMaker(urlAddition), headers: headers, body: json.encode(body));
      }

      //first checking if code 401, if true access token will  be refreshed
      if (response.statusCode == 401) {
        String? newAccessToken = await _accessTokenRefreshed();

        if (newAccessToken != null) {
          print('access token refresheeeed');
          headers['Authorization'] = 'Bearer $newAccessToken';

          if (type == 'GET') {
            response = await http.get(_urlMaker(urlAddition), headers: headers);
          } else {
            response = await http.post(_urlMaker(urlAddition), headers: headers, body: json.encode(body));
          }
        }
      }

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        print(decodedResponse.toString());
        return decodedResponse;
      }

      if (context.mounted) {
        Provider.of<AuthServiceProvider>(context, listen: false).logout();
        context.go('/login');
      }

      ///
      ///
      /////
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      rethrow;
    }

    return null;
  }

  Future<String?> _accessTokenRefreshed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      try {
        final response = await http.post(
          _urlMaker('auth/refreshtoken'),
          body: json.encode({"refreshToken": refreshToken}),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
        );

        if (response.statusCode == 200) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          await prefs.setString('accessToken', result['accessToken']);
          await prefs.setString('refreshToken', result['refreshToken']);
          return result['accessToken'];
        }
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
