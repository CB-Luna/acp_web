import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiErrorHandler {
  static String translateErrorMsg(String message) {
    switch (message) {
      //Login
      case 'Invalid login credentials':
        return 'Credenciales inválidas';
      //Reset Password
      case 'User not found':
        return 'Usuario no encontrado';
      case 'For security purposes, you can only request this once every 60 seconds':
        return 'Solo se puede solicitar este recurso una vez por minuto';
      default:
        return 'Error al realizar petición';
    }
  }

  static Future<void> callToast(
      [String msg = 'Error al realizar petición']) async {
    await Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#e74c3c",
      textColor: Colors.black,
      timeInSecForIosWeb: 5,
      webPosition: 'center',
    );
  }
}
