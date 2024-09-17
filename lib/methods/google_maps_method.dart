import 'dart:convert';

import 'package:car_rent/app_info/app_info.dart';
import 'package:car_rent/constants/constants.dart';
import 'package:car_rent/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
import 'package:provider/provider.dart';

class GoogleMapsMethods {
  static sendReqToAPI(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String responseData = response.body;

        var dataDecoded = jsonDecode(responseData);
        return dataDecoded;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> convertGeographicCoordinatesToAddress(double latitude,
      double longitude, String type, BuildContext context) async {
    String readableAddress = '';
    String geoCodingUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${AppConstants.googleApiKey}';

    var response = await sendReqToAPI(geoCodingUrl);

    if (response != 'error') {
      readableAddress = response['results'][0]['formatted_address'];
      AddressModel addressModel = AddressModel();
      addressModel.address = readableAddress;
      addressModel.placeName = readableAddress;
      addressModel.placeId = response['results'][0]['place_id'];
      addressModel.latitude = latitude;
      addressModel.longitude = longitude;

      if (type != 'destination') {
        Provider.of<AppInfo>(context, listen: false)
            .updatePickupLocation(addressModel);
      }
    } else {
      return 'error';
    }
    return readableAddress;
  }

  static Future<double> getDistance(
      double pLat, double pLng, double dLat, double dLng) async {
    double distance = 0;

    final double result = Geolocator.distanceBetween(
          pLat,
          pLng,
          dLat,
          dLng,
        ) /
        1000;

    distance = result;

    return distance;
  }

  static Future<String> convertAddressToCoordindates(
    String address,
  ) async {
    String readableAddress = '';
    String geoCodingUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${AppConstants.googleApiKey}';

    var response = await sendReqToAPI(geoCodingUrl);
    print('replay 2  $response');
    if (response != 'error') {
      return response;
      // readableAddress = response['results'][0]['address_components'];
      // AddressModel addressModel = AddressModel();
      // addressModel.address = readableAddress;
      // addressModel.placeName = readableAddress;
      // addressModel.placeId = response['results'][0]['long_name'];
      // addressModel.latitude =
      //     response['results'][0]['geometry']['location']['lat'];
      // addressModel.longitude =
      //     response['results'][0]['geometry']['location']['lng'];

      // Provider.of<AppInfo>(context, listen: false)
      //     .updatePickupLocation(addressModel);
    } else {
      return 'error';
    }
    // return readableAddress;
  }
}
