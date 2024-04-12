import 'dart:convert';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/data/models/signup_model.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/sensitive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  Uri _urlMaker(String endpoint) {
    return Uri.parse(BASEURL + endpoint);
  }

  var headers = {'Content-Type': 'application/json; charset=utf-8'};

  Future<LoginResponseModel> login(BuildContext context, LoginRequestModel requestModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(_urlMaker('auth/signin'), headers: headers, body: json.encode(requestModel));

      if (response.statusCode == 200) {
        print('api call log in success');
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        await prefs.setString('accessToken', decodedResponse['accessToken']);
        await prefs.setString('refreshToken', decodedResponse['refreshToken']);
        return LoginResponseModel.fromJson(decodedResponse);
      }

      throw 'Incorrect credentials';
    } catch (e) {
      rethrow;
    }
  }

  Future<SignupResponseModel> signup(BuildContext context, SignupRequestModel requestModel) async {
    try {
      final response = await http.post(_urlMaker('auth/signup'), headers: headers, body: json.encode(requestModel));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['message'])),
          );
        }
      }
      throw Exception('Sign up data error');
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileResponseModel> profileInfo(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('accessToken');
      headers['Authorization'] = 'Bearer $accessToken';

      var response = await http.get(_urlMaker('admin/myInfo'), headers: headers);

      //first checking if code 401, if true access token will  be refreshed
      if (response.statusCode == 401) {
        String? newAccessToken = await _accessTokenRefreshed();

        if (newAccessToken != null) {
          headers['Authorization'] = 'Bearer $newAccessToken';
          response = await http.get(_urlMaker('admin/myInfo'), headers: headers);
        } else {
          if (context.mounted) {
            Provider.of<AuthServiceProvider>(context, listen: false).logout();
            context.go('/login');
          }
        }
      }

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        if (decodedResponse != null && decodedResponse['data'] != null && decodedResponse['data']['result'] == 'SUCCESS' && decodedResponse['data']['info'] != null) {
          return ProfileResponseModel.fromJson(decodedResponse['data']['info']);
        }
      }

      throw "Profile response data not reveiced";
    } catch (e) {
      rethrow;
    }
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
          print('access token refresheeeed');
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
