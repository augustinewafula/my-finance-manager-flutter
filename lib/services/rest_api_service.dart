import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../config/constants.dart';
import 'auth.dart';
import 'navigation_service.dart';

class RestApiService {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<void> appendAuthToken() async {
    String token = await getAuthToken();
    headers['Authorization'] = 'Bearer $token';
  }
}

Client client = InterceptedClient.build(interceptors: [
  ApiInterceptor(),
]);

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      clearAuthSharedPreferences();
      NavigationService.instance.navigateToReplacement("/screens.sign_in");
      EasyLoading.dismiss();
    } else if (data.statusCode == 408) {
      EasyLoading.showError('Failed');
    }
    return data;
  }
}

Future<Response> login(String email, String password) async {
  var url = Uri.parse('${baseUrl!}login');
  String body = '{"email": "$email", "password": "$password"}';
  var response =
      await http.post(url, body: body, headers: RestApiService.headers);
  return response;
}

Future<Response> mpesaTransaction(String message) async {
  await RestApiService().appendAuthToken();
  var url = Uri.parse('${baseUrl!}mpesa-transactions');
  String body = '{"message": "$message"}';
  var response =
      await http.post(url, body: body, headers: RestApiService.headers);
  return response;
}
