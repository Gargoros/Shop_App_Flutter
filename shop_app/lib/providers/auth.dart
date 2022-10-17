import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA1WJi7syZuFSqR2p34L3WPCAQhgEhkYyo");
    final response = await http.post(url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    // https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
    return _authenticate(email, password, "signInWithPassword");
  }
}
