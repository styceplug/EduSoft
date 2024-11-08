import 'package:school_management/data/api/api_client.dart';
import 'package:school_management/data/repo/auth_repo.dart';
import 'package:school_management/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  //api clients
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //repos
  Get.lazyPut(
          () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  //controllers

}
