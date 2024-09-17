import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:car_rent/app_info/app_info.dart';
import 'package:car_rent/constants/constants.dart';
import 'package:car_rent/methods/google_maps_method.dart';
import 'package:car_rent/screens/destination_page.dart';
import 'package:car_rent/widgets/app_button.dart';
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
  double distanceKm = 0;
  double currentZoom = 15.0;
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

      final distKm =
          await GoogleMapsMethods.getDistance(lat, long, desLat, desLong);
      setState(() {
        destinationAddress = destAddress;
        distanceKm = distKm;
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
            zoom: 15,
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
    // ignore: deprecated_member_use
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/car-icon.png')
        .then((icon) {
      movementIcon = icon;
    });
  }

  Future<void> goToMyLocation() async {
    final GoogleMapController controller =
        await googleMapCompleterController.future;
    // Assuming you've already implemented logic to get the user's current location
    // Here, hardcoded to a specific LatLng for demo purposes
    LatLng currentLocation = LatLng(lat, long);

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 15,
        ),
      ),
    );
  }

  // Function to zoom in
  Future<void> zoomIn() async {
    final GoogleMapController controller =
        await googleMapCompleterController.future;
    setState(() {
      currentZoom += 1; // Increase the zoom level
    });
    controller.animateCamera(CameraUpdate.zoomTo(currentZoom));
  }

  // Function to zoom out
  Future<void> zoomOut() async {
    final GoogleMapController controller =
        await googleMapCompleterController.future;
    setState(() {
      currentZoom -= 1; // Decrease the zoom level
    });
    controller.animateCamera(CameraUpdate.zoomTo(currentZoom));
  }

  @override
  Widget build(BuildContext context) {
    // print('init lats lngs $lat $long $destinationAddress');
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
                    zoomControlsEnabled: false,
                    trafficEnabled: true,
                    padding: EdgeInsets.only(top: 20, bottom: bottomMapPadding),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, long),
                    ),
                    onMapCreated: (GoogleMapController googleMapController) {
                      controllerGoogleMap = googleMapController;
                      googleMapCompleterController
                          .complete(controllerGoogleMap);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('movementLocation'),
                        icon: movementIcon,
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        infoWindow: const InfoWindow(),
                      ),
                      Marker(
                        markerId: const MarkerId('Source'),
                        position: LatLng(lat, long),
                        infoWindow: const InfoWindow(),
                      ),
                      Marker(
                        // markerId: MarkerId(tappedPoint.toString()),
                        markerId: const MarkerId('destination'),
                        position: LatLng(desLat, desLong),
                        infoWindow: InfoWindow(
                          title: destinationAddress,
                        ),
                      ),
                    }, // Make sure markers is a Set
                    onTap: (LatLng tappedPoint) {
                      setState(
                        () {
                          desLat = tappedPoint.latitude;
                          desLong = tappedPoint.longitude;
                          // print('$desLat $desLong');
                          markers.clear(); // Clear previous markers if needed
                          updateDestination();
                          getPolyPoints();
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
                                text: 'A. Your location',
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
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 1,
                            width: context.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                            ),
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
                                  text: 'B. Destination',
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
            if (destinationAddress != '')
              Positioned(
                left: 0,
                right: 0,
                // top: 0,
                bottom: context.height * 0.1,
                child: FadeIn(
                  child: Container(
                    width: context.width,
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            // Container(
                            //   height: 1,
                            //   width: context.width * 0.6,
                            //   decoration: BoxDecoration(
                            //     color: Colors.black.withOpacity(0.2),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              // padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // const AppText(
                                  //   text: 'B. Destination',
                                  //   color: Colors.black,
                                  //   isBold: true,
                                  //   fontSize: 14,
                                  // ),
                                  SizedBox(
                                    width: context.width * 0.6,
                                    child: AppText(
                                      text: destinationAddress,
                                      color: Colors.black,
                                      fontSize: 14,
                                      isBold: true,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width: context.width * 0.6,
                                    child: Row(
                                      children: [
                                        const AppIcon(
                                          icon: Icons.route_rounded,
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        AppText(
                                          text: distanceKm.toString(),
                                          color: Colors.black,
                                          fontSize: 14,
                                          isBold: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: context.width * 0.9,
                              child: AppButton(
                                text: 'Let\'s go',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   padding: const EdgeInsets.all(3),
                        //   decoration: const BoxDecoration(
                        //       color: Colors.black, shape: BoxShape.circle),
                        //   child: const AppIcon(
                        //     icon: Icons.swap_vert_rounded,
                        //     color: Colors.white,
                        //     size: 20.0,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: context.height * 0.4,
              right: 12,
              // left: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: AppIcon(
                      icon: Icons.my_location_rounded,
                      color: Colors.black,
                      onTap: goToMyLocation,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: AppIcon(
                      icon: Icons.add,
                      color: Colors.black,
                      onTap: zoomIn,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: AppIcon(
                      icon: Icons.remove,
                      color: Colors.black,
                      onTap: zoomOut,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
