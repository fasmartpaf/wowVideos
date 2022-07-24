import 'package:dio/dio.dart';
import 'package:acoustic/util/preferenceutils.dart';
import 'package:acoustic/util/constants.dart';

class ApiHeader {
  Dio dioData() {
    final dio = Dio();
    // print(PreferenceUtils.getString(Constants.headerToken));
    dio.options.headers["Authorization"] = "Bearer" +
        "  " +
        PreferenceUtils.getString(
            Constants.headerToken); // config your dio headers globally
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;

    // print("tokwen123:${PreferenceUtils.getString(Constants.headertoken)}");

    return dio;
  }
}

class ApiHeader2 {
  Dio dioData2() {
    final dio = Dio();

    dio.options.headers["Authorization"] = "Bearer" +
        " " +
        PreferenceUtils.getString(
            Constants.headerToken); // config your dio headers globally
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    dio.options.headers["Content-Type"] = "multipart/form-data";
    // dio.options.followRedirects = false;

    // print("tokwen123:${PreferenceUtils.getString(Constants.headertoken)}");

    return dio;
  }
}
