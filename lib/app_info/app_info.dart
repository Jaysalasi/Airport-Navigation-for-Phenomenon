import 'package:car_rent/models/address_model.dart';
import 'package:flutter/material.dart';

class AppInfo extends ChangeNotifier {
  AddressModel? pickupLocation;
  AddressModel? destinationLocation;

  void updatePickupLocation(AddressModel pickupModel) {
    pickupLocation = pickupModel;
    notifyListeners();
  }

  void updateDestinationLocation(AddressModel pickupModel) {
    destinationLocation = pickupModel;
    notifyListeners();
  }
}
