
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';




class DependencyInjection implements Bindings {

  DependencyInjection();

  @override
  void dependencies() {

   Get.lazyPut(() => AuthController(), fenix: true);
  }
}

