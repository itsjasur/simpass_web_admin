import 'dart:convert';
import 'package:admin_simpass/data/api/request_helper.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/data/models/signup_model.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/sensitive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  Uri _urlMaker(String endpoint) {
    return Uri.parse(BASEURL + endpoint);
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    return accessToken;
  }

  var headers = {'Content-Type': 'application/json; charset=utf-8'};

  Future<LoginResponseModel> login(BuildContext context, LoginRequestModel requestModel) async {
    try {
      final response = await http.post(_urlMaker('auth/signin'), headers: headers, body: json.encode(requestModel.toJson()));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          await Provider.of<AuthServiceProvider>(context, listen: false).loggedIn(context, decodedResponse['accessToken'], decodedResponse['refreshToken']);
        }
        return LoginResponseModel.fromJson(decodedResponse);
      } else {
        throw 'Incorrect credentials';
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      rethrow;
    }
  }

  Future<void> signup(BuildContext context, SignupRequestModel requestModel) async {
    try {
      final response = await http.post(_urlMaker('auth/signup'), headers: headers, body: json.encode(requestModel.toJson()));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['message'])),
          );
        }
      } else {
        throw Exception('Sign up data error');
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      rethrow;
    }
  }

  Future<ProfileResponseModel> profileInfo(BuildContext context) async {
    try {
      String? accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';
      Uri url = _urlMaker('admin/myInfo');
      var response = await http.get(url, headers: headers);
      response = await RequestHelper().get(context.mounted ? context : null, response, url, headers);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        if (decodedResponse != null && decodedResponse['data'] != null && decodedResponse['data']['result'] == 'SUCCESS' && decodedResponse['data']['info'] != null) {
          return ProfileResponseModel.fromJson(decodedResponse['data']['info']);
        }
      }

      throw "Profile response data not reveiced";
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

      rethrow;
    }
  }

  Future<void> profileInfoUpdate(BuildContext context, ProfileUpdateRequestModel requestModel) async {
    try {
      String? accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';
      Uri url = _urlMaker('admin/myUpdate');

      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['message'])),
          );
        }
      } else {
        throw "Update data incorrect";
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      rethrow;
    }
  }

  Future<Map> fetchUsers({required BuildContext context, required page, required rowLimit}) async {
    String? accessToken = await getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';
    Uri url = _urlMaker('admin/member');
    var body = json.encode({"page": page, "rowLimit": rowLimit});

    try {
      var response = await http.post(url, headers: headers, body: body);
      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        throw "Could not fetch data";
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

      rethrow;
    }
  }
}
