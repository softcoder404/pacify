import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/network_response.dart';

///This class handles all API calls methods
class HttpService {
  static final HttpService _singleton = HttpService._internal();
  factory HttpService() => _singleton;
  HttpService._internal();

  Future<NetworkResponse> post({
    required Map<String, dynamic> payload,
    required String url,
    String? token,
  }) async {
    final _client = http.Client();
    NetworkResponse result = NetworkResponse.warning();
    try {
      log("post request: $url");
      log("Body: " + json.encode(payload));
      final response = await _client
          .post(
            Uri.parse(url),
            body: json.encode(payload),
            headers: _httpHeaders(token),
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(seconds: 30));

      result = _handleHttpResponse(response);
    } on SocketException {
      result.message = 'No Internet Connection!';
    } on TimeoutException {
      result.message = "Timeout! No Strong Internet";
    } catch (error, trace) {
      result.handleError(error, trace);
    } finally {
      _client.close();
    }
    return result;
  }

  Future<NetworkResponse> get({
    required String url,
    String? token,
  }) async {
    final _client = http.Client();
    NetworkResponse result = NetworkResponse.warning();

    try {
      final response = await _client
          .get(Uri.parse(url), headers: _httpHeaders(token))
          .timeout(const Duration(seconds: 25));
      result = _handleHttpResponse(response);
    } on SocketException {
      result.message = 'No Internet Connection!';
    } catch (error, trace) {
      result.handleError(error, trace);
    } finally {
      _client.close();
    }
    return result;
  }

  Map<String, String> _httpHeaders(String? token) {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer ' + token,
    };
    return headers;
  }

  NetworkResponse _handleHttpResponse(dynamic response) {
    NetworkResponse _result = NetworkResponse.warning();

    final data = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      _result = NetworkResponse.success(
        message: data['message'] ?? 'success',
        data: data,
      );
    } else {
      _result.code = response.statusCode;
      _result.message = data["error_message"] ?? data['message'];
      _result.data = data['data'];
      if (_result.code == 401) {
        //logout
      }
    }
    return _result;
  }
}
