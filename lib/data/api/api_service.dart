import 'dart:convert';
import 'package:admin_simpass/data/api/request_helper.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/data/models/member_model.dart';
import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/data/models/signup_model.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
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

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    return accessToken;
  }

  var headers = {'Content-Type': 'application/json; charset=utf-8'};

  Future<void> login(BuildContext context, LoginRequestModel requestModel) async {
    try {
      final response = await http.post(_urlMaker('auth/signin'), headers: headers, body: json.encode(requestModel.toJson()));
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        LoginResponseModel loginResponse = LoginResponseModel.fromJson(decodedResponse);
        if (context.mounted) {
          await Provider.of<AuthServiceProvider>(context, listen: false).loggedIn(context, loginResponse.token, loginResponse.refreshToken);
        }
        if (context.mounted) await Provider.of<MyinfoProvifer>(context, listen: false).setRolesList(loginResponse.roles);
      } else {
        throw 'Incorrect credentials';
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
    }
  }

  Future<Map> fetchUsers({required BuildContext context, required page, required rowLimit}) async {
    String? accessToken = await getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';
    Uri url = _urlMaker('admin/member');
    var body = json.encode({
      "page": page,
      "rowLimit": rowLimit,
    });

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
      rethrow;
    }
  }

  Future<MemberModel> fetchMemberInfo({required BuildContext context, required String memberUserName}) async {
    String? accessToken = await getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';
    Uri url = _urlMaker('admin/memberDetail');

    var body = json.encode({"username": memberUserName});

    try {
      var response = await http.post(url, headers: headers, body: body);
      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        return MemberModel.fromJson(decodedResponse["data"]["info"]);
      } else {
        throw "Could not fetch data";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> memberAddOrUpdate({required BuildContext context, required MemberAddUpdateModel requestModel, required bool isNew}) async {
    var messenger = ScaffoldMessenger.of(context);

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = isNew ? _urlMaker('admin/register') : _urlMaker('admin/memberUpdate');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 1));
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        if (context.mounted) context.pop();
      } else {
        throw decodedResponse['message'] ?? "Update data incorrect";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<ManagePlansModel> fetchPlansInfo({required BuildContext context, required ManagePlanSearchModel requestModel}) async {
    try {
      String? accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/plan');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return ManagePlansModel.fromJson(decodedResponse['data']);
      } else {
        throw decodedResponse['message'] ?? "Plans data request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOrAddPlan({required BuildContext context, required PlanAddUpdateModel requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/setPlan');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        return true;
      } else {
        throw decodedResponse['message'] ?? "Data error";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}
