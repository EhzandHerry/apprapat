import 'package:flutter/material.dart';
import 'package:apprapat/models/rapat.dart';
import 'package:apprapat/services/rapat_service.dart';

class RapatController with ChangeNotifier {
  final RapatService _rapatService = RapatService();
  List<Rapat> _rapats = [];

  List<Rapat> get rapats => _rapats;

  Future<void> fetchRapats() async {
    try {
      _rapats = await _rapatService.fetchRapats();
      notifyListeners();
    } catch (error) {
      print('Error fetching rapats: $error');
    }
  }

  Future<void> createRapat(BuildContext context, Rapat rapat) async {
    try {
      print('Creating rapat with data: ${rapat.toJson()}');
      Rapat newRapat = await _rapatService.createRapat(rapat);
      _rapats.add(newRapat);
      notifyListeners();
      Navigator.pop(context);
    } catch (error) {
      print('Error creating rapat: $error');
    }
  }

  Future<void> updateRapat(BuildContext context, int id, Rapat rapat) async {
    try {
      print('Updating rapat with data: ${rapat.toJson()}');
      Rapat updatedRapat = await _rapatService.updateRapat(id, rapat);
      int index = _rapats.indexWhere((r) => r.id == id);
      _rapats[index] = updatedRapat;
      notifyListeners();
      Navigator.pop(context);
    } catch (error) {
      print('Error updating rapat: $error');
    }
  }

  Future<void> deleteRapat(int id) async {
    try {
      await _rapatService.deleteRapat(id);
      _rapats.removeWhere((rapat) => rapat.id == id);
      notifyListeners();
    } catch (error) {
      print('Error deleting rapat: $error');
    }
  }
}
