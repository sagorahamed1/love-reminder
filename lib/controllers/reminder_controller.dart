import 'dart:convert';

import 'package:get/get.dart';
import '../models/getreminder_model.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class ReminderController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    getReminder();
  }



  RxInt page = 1.obs;
  var totalPage = (-1);
  var currectPage = (-1);
  var totalResult = (-1);

  void loadMore() {
    print(
      "==========================================total page $totalPage page No: ${page.value} == total result $totalResult",
    );
    if (totalPage > page.value) {
      page.value += 1;
      getReminder();
      print("**********************print here");
      update();
    }
    print("**********************print here**************");
  }





  RxBool reviewLoading = false.obs;
  RxList<GetReminderModel> getAllReminders = <GetReminderModel>[].obs;
  getReminder({String? id}) async {
    if (page.value == 1) {
      reviewLoading(true);
      getAllReminders.clear();
    }
    var response = await ApiClient.getData(
      '${ApiConstants.getReminder(page.value.toString())}',
    );
    if (response.statusCode == 200) {
      totalPage =
          jsonDecode(response.body['pagination']['totalPages'].toString()) ?? 0;
      totalResult =
          jsonDecode(response.body['pagination']['totalCount'].toString()) ?? 0;
      var data = List<GetReminderModel>.from(
        response.body["data"].map((x) => GetReminderModel.fromJson(x)),
      );
      getAllReminders.addAll(data);
      update();
      reviewLoading(false);
    } else {
      reviewLoading(false);
    }
  }




  RxBool createReminderLoading = false.obs;

  createReminder({var body}) async {
    createReminderLoading(true);

    var response = await ApiClient.postData('/patient/pay-instant-call', jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {

      Get.back();

      createReminderLoading(false);
    } else {
      createReminderLoading(false);
    }
  }



}
