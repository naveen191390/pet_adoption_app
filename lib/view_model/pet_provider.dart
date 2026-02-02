import 'package:flutter/material.dart';
import 'package:pet_app/model/pet_model.dart';
import 'package:pet_app/services/api.dart';

class PetViewModel with ChangeNotifier {
  List<Data> _pets = [];
  List<Data> _filteredPets = [];
  bool _isLoading = false;

  List<Data> get pets => _filteredPets;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> fetchPets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pets = await _apiService.fetchPets();
      _filteredPets = _pets;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterPets(String query) {
    _filteredPets = _pets
        .where(
          (pet) => pet.petName!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    notifyListeners();
  }

  void filterFriendly(bool showFriendlyOnly) {
    if (showFriendlyOnly) {
      _filteredPets = _pets.where((pet) => pet.isfriendly == true).toList();
    } else {
      _filteredPets = _pets;
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    if (category == 'All') {
      _filteredPets = _pets;
    } else if (category == 'Dog') {
      _filteredPets = _pets.where((pet) => pet.category == 'Dog').toList();
    } else {
      _filteredPets = [];
    }
    notifyListeners();
  }
}
