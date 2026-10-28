import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gatekeep/helper/dio_client.dart';
import 'package:gatekeep/provider/dashboard_provider.dart';
import 'package:gatekeep/provider/home_provider.dart';
import 'package:gatekeep/provider/qr_scanner_provider.dart';
import 'package:gatekeep/provider/visitor_details_provider.dart';
import 'package:gatekeep/provider/visitor_form_provider.dart';
import 'package:gatekeep/provider/visitor_list_provider.dart';
import 'package:gatekeep/services/api_service.dart';
import 'package:gatekeep/services/local_data_service.dart';
import 'package:gatekeep/utils/api_constants.dart';
import 'package:gatekeep/services/visitor_store.dart';

final GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiUrl,
        connectTimeout: ApiConstants.timeout,
        receiveTimeout: ApiConstants.timeout,
        sendTimeout: ApiConstants.timeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: false));
    }
    return dio;
  });

  locator.registerLazySingleton<DioClient>(() => DioClient());

  locator.registerLazySingleton<LocalDataService>(() => LocalDataService());

  locator.registerLazySingleton<ApiService>(() => ApiService());

  locator.registerLazySingleton<VisitorStore>(() => VisitorStore());

  locator.registerFactory(() => HomeProvider());

  locator.registerFactory(() => DashboardProvider());

  locator.registerFactory(() => VisitorListProvider());

  locator.registerFactory(() => VisitorFormProvider());

  locator.registerFactory(() => VisitorDetailsProvider());

  locator.registerFactory(() => QrScannerProvider());
}
