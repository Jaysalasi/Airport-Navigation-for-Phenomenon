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

class DistanceMatrixModel {
  String? destinationAddress;
  String? originAddress;
  List<Rows>? rows;
  double? latitude;
  double? longitude;
  String? placeName;

  DistanceMatrixModel(
      {this.destinationAddress,
      this.latitude,
      this.rows,
      this.longitude,
      this.originAddress,
      this.placeName});
}

class Rows {
  List<MatrixElements>? elements;

  Rows({this.elements});
}

class MatrixElements {
  List<Elements>? elements;

  MatrixElements({
    this.elements,
  });
}

class Elements {
  Distance? distance;
  Duration? duration;

  Elements({
    this.distance,
    this.duration,
  });
}

class Distance {
  String? text;
  int? value;

  Distance({
    this.text,
    this.value,
  });
}

class Duration {
  String? text;
  int? value;

  Duration({
    this.text,
    this.value,
  });
}
