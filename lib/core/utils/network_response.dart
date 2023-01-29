import 'dart:io';

import 'package:flutter/material.dart';

class NetworkResponse {
  String message;
  bool success;
  dynamic data;
  int code;

  NetworkResponse({
    this.message = "An unknown response received.",
    this.success = false,
    this.data,
    this.code = 500,
  });

  NetworkResponse.success({
    this.message = "Operation Successful",
    this.data,
    this.success = true,
    this.code = 200,
  });
  NetworkResponse.warning({
    this.message = 'An unknown response received.',
    this.data,
    this.success = false,
    this.code = 400,
  });

  NetworkResponse.error({
    this.message = 'An error occur, try again later.',
    this.data,
    this.success = false,
    this.code = 500,
  });

  handleError(error, trace) {
    message = 'An error occurred, please try again later.';
    debugPrintStack(stackTrace: trace);
    debugPrint(error?.toString());
    if (error is SocketException) {
      if (error.osError!.errorCode == 8) {
        message = 'Please check your internet connection.';
      } else if (error.osError!.errorCode == 61 ||
          error.osError!.errorCode == 111) {
        message = 'The server could not be reached, please try again later.';
      } else {
        message =
            'A network error prevented us from reaching the server, please try again later.';
      }
    }
  }
}
