import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';


class AdminUsersManager extends ChangeNotifier {
  List<User> users = [];

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUser();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void _listenToUser() {
    _subscription =
        firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.documents.map((d) => User.fromDocument(d)).toList();

      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
