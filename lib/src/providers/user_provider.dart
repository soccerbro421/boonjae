import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/auth_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  
  
  final AuthService _authService = AuthService();

  UserModel get getUser {

    if (_user == null) {
      return const UserModel(bio: "", username: '', photoUrl: 'https://images.unsplash.com/photo-1631477076114-9123f721b9dc?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', uid:'idk', friends: [], name: "",);
    }

    return _user!;
  } 

  Future<void> refreshUser() async {
    UserModel user = await _authService.getUserDetails();
    _user = user;
    // print('refreshUser is called in provider');
    notifyListeners();
  }
}