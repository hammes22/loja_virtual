import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  final List<Section> _sections = [];

  List<Section> _editingSections = [];

  bool editing = false;
  bool loading = false;

  final Firestore firestore = Firestore.instance;
  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      _sections.clear();
      for (final DocumentSnapshot document in snapshot.documents) {
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  List<Section> get sections {
    if (editing)
      return _editingSections;
    else
      return _sections;
  }

  void enterEditing() {
    editing = true;

    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;
    for (final section in _editingSections) {
      if (!section.valid()) valid = false;
    }

    if (!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;

    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Function() UpSection(Section section) {
    return section != _editingSections.first
        ? () {
            for (var i = 0; i < _editingSections.length; i++) {
              if (_editingSections[i] == section) {
                _editingSections.remove(section);
                _editingSections.insert(i - 1, section);
                notifyListeners();
                return;
              }
            }
          }
        : null;
  }

  // ignore: non_constant_identifier_names
  Function() DownSection(Section section) {
    return section != _editingSections.last
        ? () {
            for (var i = 0; i < _editingSections.length; i++) {
              if (_editingSections[i] == section) {
                _editingSections.remove(section);
                _editingSections.insert(i + 1, section);
                notifyListeners();
                return;
              }
            }
          }
        : null;
  }
}
