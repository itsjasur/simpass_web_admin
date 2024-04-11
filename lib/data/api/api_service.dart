import 'package:admin_simpass/data/api/api_handler.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/data/models/signup_model.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class APIService {
  Future<LoginResponseModel> login(BuildContext context, LoginRequestModel requestModel) async {
    try {
      ApiHandler api = ApiHandler();
      final response = await api.request(
        context: context,
        urlAddition: 'auth/signin',
        body: requestModel.toJson(),
      );

      if (response != null) {
        print(response);
        if (context.mounted) Provider.of<AuthServiceProvider>(context, listen: false).login();
        return LoginResponseModel.fromJson(response);
      }
      throw 'Incorrect credentials';
    } catch (e) {
      rethrow;
    }
  }

  Future<SignupResponseModel> signup(BuildContext context, SignupRequestModel requestModel) async {
    try {
      ApiHandler api = ApiHandler();

      print(requestModel.toJson());

      final response = await api.request(
        context: context,
        urlAddition: 'auth/signup',
        body: requestModel.toJson(),
      );

      if (response != null) {
        return SignupResponseModel.fromJson(response);
      }

      throw Exception('Login data error');
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileResponseModel> profileInfo(BuildContext context) async {
    ApiHandler api = ApiHandler();

    try {
      final response = await api.request(context: context, urlAddition: 'admin/myInfo', body: {}, isProtected: true, type: 'GET');

      if (response != null && response['data'] != null && response['data']['result'] == 'SUCCESS' && response['data']['info'] != null) {
        return ProfileResponseModel.fromJson(response['data']['info']);
      } else {
        throw "Response data not reveiced";
      }
    } catch (e) {
      rethrow;
    }
  }
}
