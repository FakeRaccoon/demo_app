import 'package:atana/model/transport_model.dart';
import 'package:atana/service/api.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RentalController extends GetxController {
  var transports = [].obs;
  var test = "Rental Mobil".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTransport();
  }

  void fetchTransport() async {
    try {
      var transport = await API.getTransport();
      if (transport != null) {
        transports.assignAll(transport);
      }
    } finally {}
  }
}