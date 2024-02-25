import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ayurvedic/apiServices/urls.dart';
import 'package:ayurvedic/apiServices/webService.dart';
import 'package:ayurvedic/helper/utils.dart';
import 'package:ayurvedic/models/loginModel.dart';
import 'package:ayurvedic/provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRepo {
  ApiService _service = ApiService();

  Future<String> Login() async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    // Encode form data
    var body = {
      "username": getContext().read<LoginProvider>().username!,
      "password": getContext().read<LoginProvider>().password!,
    };

    var formData = body.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await http.post(
        Uri.parse("https://flutter-amr.noviindus.in/api/Login"),
        body: formData,
        headers: headers);

    // Check the response status code
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      LoginModel model = LoginModel.fromJson(responseBody);
      getContext().read<LoginProvider>().setLoginModel(model);
      log("message" + responseBody.toString());
    } else {
      // Handle error cases
      showToast(getContext(), "Invalid username or password", Colors.black,
          Colors.white);
    }

    return "";
  }
}
