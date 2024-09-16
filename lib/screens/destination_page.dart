import 'package:car_rent/app_info/app_info.dart';
import 'package:car_rent/methods/google_maps_method.dart';
import 'package:car_rent/models/predictions_model.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  List<PredictionsModel> predictionsList = [];

  searchPlace(String placeInput) async {
    if (placeInput.length > 2) {
      String placesUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeInput&key=AIzaSyBjC0eWw6KiZ2h6452b8WwRgUqdF2HwLNQ&components=country:NG';

      // var response = await GoogleMapsMethods.sendReqToAPI(placesUrl);
      var response = await GoogleMapsMethods.sendReqToAPI(placesUrl);

      if (response == 'error') {
        return 'error';
      }
      if (response['status'] == 'OK') {
        var predictionsResult = response['predictions'];
        var predictionsResConverted = (predictionsResult as List)
            .map((e) => PredictionsModel.fromJson(e))
            .toList();

        setState(() {
          predictionsList = predictionsResConverted;
        });
      }
    }
  }

  Future searchAddress(String placeInput) async {
    if (placeInput.length > 2) {
      var response =
          await GoogleMapsMethods.convertAddressToCoordindates(placeInput);

      print(' replay $response');
    }
  }

  @override
  Widget build(BuildContext context) {
    String pickupAddress =
        Provider.of<AppInfo>(context, listen: false).pickupLocation?.address ??
            '';
    pickupController.text = pickupAddress;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 12,
              child: Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0, 0.5),
                  )
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 22,
                    bottom: 22,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          AppIcon(
                            icon: Icons.arrow_back,
                            onTap: () {
                              Get.back();
                            },
                          ),
                          const Center(
                            child: AppText(text: 'Search destination'),
                          )
                        ],
                      ),

                      // PICKUP
                      Row(
                        children: [
                          const AppIcon(
                            icon: Icons.location_on,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.grey,
                              ),
                              child: TextField(
                                controller: pickupController,
                                decoration: const InputDecoration(
                                  hintText: 'Pickup address',
                                  filled: true,
                                  fillColor: Colors.white12,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // destination
                      Row(
                        children: [
                          const AppIcon(
                            icon: Icons.location_on,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.grey,
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  // searchPlace(value);
                                  searchAddress(value);
                                },
                                controller: destinationController,
                                decoration: const InputDecoration(
                                  hintText: 'Search destination',
                                  filled: true,
                                  fillColor: Colors.white12,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (predictionsList.length > 0)
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: predictionsList.length,
                  itemBuilder: (context, index) {
                    var data = predictionsList[index];
                    print('pred ${data.mainText}');
                    return GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [AppText(text: data.mainText!)],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
