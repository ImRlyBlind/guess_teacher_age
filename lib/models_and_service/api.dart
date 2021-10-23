import 'dart:convert';

import 'package:guess_teacher_age/models_and_service/api_result.dart';
import 'package:http/http.dart' as http;

class API {
  static const base_url = 'https://cpsu-test-api.herokuapp.com';

  Future<dynamic> submit(
    String end,
    Map<String, dynamic> params,
  ) async {
    var url = Uri.parse('$base_url/$end');
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);
      if (apiResult.status == 'ok') {
        return apiResult.data;
      } else {
        throw apiResult.message!;
      }
    } else if (response.statusCode == 500) {
      print('invalid input');
    } else {
      throw 'Server connection fail!';
    }
  }

  Future<dynamic> fetch(
    String end, {
    Map<String, dynamic>? query,
  }) async {
    String queryStr = Uri(queryParameters: query).query;
    var url = Uri.parse('$base_url/$end?$queryStr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);
      if (apiResult.status == 'ok') {
        return apiResult.data;
      } else {
        throw apiResult.message!;
      }
    } else {
      throw 'Server connection fail!';
    }
  }
}
