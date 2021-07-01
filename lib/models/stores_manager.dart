import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoreList();
    _startTime();
  }

  List<Store> stores = [];

  final Firestore firestore = Firestore.instance;

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').getDocuments();

    stores = snapshot.documents.map((e) => Store.fromDocumet(e)).toList();

    notifyListeners();
  }

  void _startTime() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
      notifyListeners();
    }
  }
}
