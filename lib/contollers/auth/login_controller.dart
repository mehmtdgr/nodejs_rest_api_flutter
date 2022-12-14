import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/auth/login_model.dart';
import '../../views/home/home_screen.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final box = GetStorage();

  var isLoading = true.obs;
  var validateMsg = ''.obs;
  var isLogin = false.obs;
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio();
  }

  changeLoading() {
    isLoading.value = !isLoading.value;
  }

  Future<void> signIn(UserModel userModel, BuildContext context) async {
    changeLoading();
    var userData = {
      'email': userModel.email,
      'password': userModel.password,
    };

    var result = await _dio.post('http://10.0.2.2:3000/api/users/login', data: userData);

    print(result.data);

    if (result.data['success'] == true) {
      box.write('token', result.data['token']);
      log("Kaydedilen token ==>" + box.read('token'));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }

    if (result.data['success'] == false) {
      Get.snackbar('Hata', result.data['message']);
    }

    changeLoading();
  }
}
