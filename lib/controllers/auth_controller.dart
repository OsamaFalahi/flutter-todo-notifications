import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../services/api/dio_client.dart';
import '../services/notification_service.dart';
import '../helpera/routes.dart';
import '../helpera/constants.dart';
import '../helpera/themes.dart';

class AuthController extends GetxController {
  final _dioClient = DioClient();
  final _settingsBox = Hive.box(AppConstants.boxSettings);

  final isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final userJson = _settingsBox.get(AppConstants.keyUser);
    if (userJson != null) {
      try {
        currentUser.value = UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        print('Error parsing user data: $e');
      }
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final response = await _dioClient.post(
        AppConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );
      // print(response);
      if (response.statusCode == 200) {
        final token = response.data[AppConstants.keyToken];
        if (token != null) {
          await _settingsBox.put(AppConstants.keyToken, token);

          final user = UserModel.fromJson(response.data);
          await _settingsBox.put(
              AppConstants.keyUser, jsonEncode(user.toJson()));
          currentUser.value = user;

          // Play notification sound
          SystemSound.play(SystemSoundType.alert);

          // Show Push Notification (Local)
          NotificationService.showNotification(
            id: 1,
            title: 'success'.tr,
            body: 'login_success'.tr,
          );

          Get.offAllNamed(AppRoutes.MAIN);
          Get.snackbar(
            'success'.tr,
            'login_success'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.successContainer,
            colorText: AppColors.success,
            duration: const Duration(seconds: 3),
            // margin: const EdgeInsets.all(16),
            borderRadius: 12,
            // icon: const Icon(Icons.check_circle, color: AppColors.success),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorContainer,
          colorText: AppColors.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _settingsBox.delete(AppConstants.keyToken);
    await _settingsBox.delete(AppConstants.keyUser);
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  bool get isLoggedIn => _settingsBox.get(AppConstants.keyToken) != null;
}
