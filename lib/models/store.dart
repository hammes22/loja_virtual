import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/helpers/extencions.dart';

enum StoreStatus { closed, open, closing }

class Store {
  Store.fromDocumet(DocumentSnapshot doc) {
    name = doc.data['name'] as String;
    image = doc.data['image'] as String;
    phone = doc.data['phone'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    opening = (doc.data['opening'] as Map<String, dynamic>).map((key, value) {
      final timesString = value as String;

      if (timesString != null && timesString.isNotEmpty) {
        final splitted = timesString.split(RegExp(r"[:-]"));

        return MapEntry(key, {
          "from": TimeOfDay(
              hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
          "to": TimeOfDay(
              hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
        });
      } else {
        return MapEntry(key, null);
      }
    });
    updateStatus();
  }

  String name;
  String image;
  String phone;
  Address address;
  Map<String, Map<String, TimeOfDay>> opening;

  String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"), "");

  StoreStatus status;

  String get addressText =>
      'Rua: ${address.street}, N.º ${address.number} ${address.complement.isNotEmpty ? ' \nComplemento: ${address.complement}' : ''}'
      '\nBairro: ${address.district}, \nCidade: ${address.city}/UF: ${address.state}';
  String get openingText {
    return 'Seg-Sex: ${formattedPeriod(opening['segsex'])}\n'
        'Sab: ${formattedPeriod(opening['sabado'])}\n'
        'Dom: ${formattedPeriod(opening['domingo'])}';
  }

  String formattedPeriod(Map<String, TimeOfDay> period) {
    if (period == null) return "Fechado";
    return '${period['from'].formatted()} - ${period['to'].formatted()}';
  }

  void updateStatus() {
    final weekDay = DateTime.now().weekday;

    Map<String, TimeOfDay> period;
    if (weekDay >= 1 && weekDay <= 5) {
      period = opening['segsex'];
    } else if (weekDay == 6) {
      period = opening['sabado'];
    } else {
      period = opening['domingo'];
    }

    final now = TimeOfDay.now();

    if (period == null) {
      status = StoreStatus.closed;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() - 15 > now.toMinutes()) {
      status = StoreStatus.open;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
  }

  String get statusText {
    switch (status) {
      case StoreStatus.closed:
        return 'Fechado';
      case StoreStatus.open:
        return 'Aberto';
      case StoreStatus.closing:
        return 'Fechando';
      default:
        return '';
    }
  }
}
