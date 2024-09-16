import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:car_rent/app_info/app_info.dart';
import 'package:car_rent/constants/constants.dart';
import 'package:car_rent/methods/google_maps_method.dart';
import 'package:car_rent/screens/destination_page.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  double bottomMapPadding = 0;
  late double lat = 0;
  late double long = 0;
  double desLat = 8.996140076758163;
  double desLong = 7.584372460842132;
  String destinationAddress = '';
  // Position? currentUserPosition;
  Set<Marker> markers = {};

  @override
  void initState() {
    initializeLocationAndPolyPoints();
    setCustomMarker();
    super.initState();
  }

  void initializeLocationAndPolyPoints() async {
    getCurrentLocation(); // Wait for the position to be determined
    // if (lat != 0 && long != 0) {
    getPolyPoints(); // Only call this after lat/long is updated
    // }
  }

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor movementIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  void updateDestination() async {
    Location location = Location();

    location.onLocationChanged.listen((e) async {
      currentLocation = e;

      final destAddress =
          await GoogleMapsMethods.convertGeographicCoordinatesToAddress(
              desLat,
              desLong,
              'destination',
              // ignore: use_build_context_synchronously
              context);
      setState(() {
        destinationAddress = destAddress;
        // desLat = e.latitude!;
        // desLong = e.longitude!;
      });
      setState(() {});
    });
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((e) {
      currentLocation = e;
    });

    GoogleMapController mapController =
        await googleMapCompleterController.future;
    location.onLocationChanged.listen((e) async {
      currentLocation = e;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(
              e.latitude!,
              e.longitude!,
            ),
          ),
        ),
      );
      await GoogleMapsMethods.convertGeographicCoordinatesToAddress(
          e.latitude!,
          e.longitude!,
          'pickup',
          // ignore: use_build_context_synchronously
          context);
      setState(() {
        lat = e.latitude!;
        long = e.longitude!;
      });
      setState(() {});
    });
  }

  void getPolyPoints() async {
    polylineCoordinates.clear();
    Location location = Location();
    setState(() {});
    PolylinePoints polylinePoints = PolylinePoints();
    // print('Polyss $lat $long');

    location.getLocation().then((e) async {
      setState(() {
        lat = e.latitude!;
        long = e.longitude!;
      });
      currentLocation = e;

      PolylineResult polylineResult =
          await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: AppConstants.googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(lat, long),
          destination: PointLatLng(
            desLat,
            desLong,
          ),
          mode: TravelMode.driving,
          // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );

      if (polylineResult.points.isNotEmpty) {
        for (var point in polylineResult.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        setState(() {});
      } else {}
    });
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/car-icon.png')
        .then((icon) {
      movementIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('init lats lngs $lat $long $destinationAddress');
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            currentLocation == null
                ? const Text('Loading...')
                : GoogleMap(
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        color: Colors.yellow[700]!,
                        width: 3,
                      ),
                    },
                    padding: EdgeInsets.only(top: 20, bottom: bottomMapPadding),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, long), zoom: 15),
                    onMapCreated: (GoogleMapController googleMapController) {
                      controllerGoogleMap = googleMapController;
                      googleMapCompleterController
                          .complete(controllerGoogleMap);
                      // determinePosition();
                    },
                    // markers: Set<Marker>.of(markers), // Make sure markers is a Set
                    markers: {
                      // Marker(
                      //   // markerId: MarkerId(tappedPoint.toString()),
                      //   markerId: const MarkerId('movementLocation'),
                      //   icon: movementIcon,
                      //   position: LatLng(
                      //       currentLocation!.latitude!, currentLocation!.longitude!),
                      //   infoWindow: const InfoWindow(
                      //       // title: "Selected Location",
                      //       // snippet:
                      //       //     "Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}",
                      //       ),
                      // ),
                      Marker(
                        // markerId: MarkerId(tappedPoint.toString()),
                        markerId: const MarkerId('movementLocation'),
                        icon: movementIcon,
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        infoWindow: const InfoWindow(
                            // title: "Selected Location",
                            // snippet:
                            //     "Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}",
                            ),
                      ),
                      Marker(
                        markerId: const MarkerId('Source'),
                        position: LatLng(lat, long),
                        infoWindow: const InfoWindow(
                            // title: "Selected Location",
                            // snippet:
                            //     "Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}",
                            ),
                      ),
                      Marker(
                        // markerId: MarkerId(tappedPoint.toString()),
                        markerId: const MarkerId('destination'),
                        position: LatLng(desLat, desLong),
                        infoWindow: InfoWindow(
                          title: destinationAddress,
                          // snippet:
                          //     "Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}",
                        ),
                      ),
                    }, // Make sure markers is a Set
                    onTap: (LatLng tappedPoint) {
                      setState(
                        () {
                          desLat = tappedPoint.latitude;
                          desLong = tappedPoint.longitude;
                          print('$desLat $desLong');
                          markers.clear(); // Clear previous markers if needed
                          updateDestination();
                          getPolyPoints();
                          // markers.add(
                          //   // Marker(
                          //   //   // markerId: MarkerId(tappedPoint.toString()),
                          //   //   markerId: MarkerId('Source'),
                          //   //   position: tappedPoint,
                          //   //   infoWindow: InfoWindow(
                          //   //     title: "Selected Location",
                          //   //     snippet:
                          //   //         "Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}",
                          //   //   ),
                          //   // ),
                          // );
                        },
                      );
                    },
                  ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              // bottom: 0,
              child: FadeIn(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Start point',
                                color: Colors.black,
                                isBold: true,
                                fontSize: 14,
                              ),
                              SizedBox(
                                width: context.width * 0.6,
                                child: AppText(
                                  text:
                                      '${Provider.of<AppInfo>(context, listen: true).pickupLocation == null ? 'Loading...' : Provider.of<AppInfo>(context, listen: false).pickupLocation?.placeName}',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const DestinationPage());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const AppText(
                                  text: 'Destination',
                                  color: Colors.black,
                                  isBold: true,
                                  fontSize: 14,
                                ),
                                SizedBox(
                                  width: context.width * 0.6,
                                  child: AppText(
                                    text: destinationAddress,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        child: const AppIcon(
                          icon: Icons.swap_vert_rounded,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
