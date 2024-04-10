import 'package:admin_simpass/data/api/api_handler.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class APIService {
  Future<LoginResponseModel> login(BuildContext context, LoginRequestModel requestModel) async {
    try {
      ApiHandler api = ApiHandler();
      final response = await api.request(context: context, urlAddition: 'signin', body: requestModel.toJson());

      if (response == null) {
        if (context.mounted) {
          Provider.of<AuthServiceProvider>(context, listen: false).login();
        }

        return LoginResponseModel(token: "token", id: 12, email: "", userName: "", roles: [], type: "", refreshToken: "");
      }

      throw Exception('everything alright');

      // if (response != null) {
      //   print(response);
      //   if (context.mounted) {x
      //     Provider.of<AuthServiceProvider>(context, listen: false).login();

      //   }
      //   return LoginResponseModel.fromJson(response);
      // } else {
      //   throw Exception('Data error');
      // }
    } catch (e) {
      throw Exception(e);
    }
  }
}
