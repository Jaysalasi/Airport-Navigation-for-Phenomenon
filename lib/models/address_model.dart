class AddressModel {
  String? placeId;
  String? address;
  String? addressLongName;
  double? latitude;
  double? longitude;
  String? placeName;

  AddressModel(
      {this.address,
      this.latitude,
      this.addressLongName,
      this.longitude,
      this.placeId,
      this.placeName});
}
