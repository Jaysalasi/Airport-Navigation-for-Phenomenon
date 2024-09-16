import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class FlutterGooglePlacesWeb extends StatefulWidget {
  static late Map<String, String> value;
  static bool showResults = false;

  final String apiKey;
  final String? proxyURL;
  final int? offset;
  final bool sessionToken;
  final String? components;
  final String? label;
  final InputDecoration? decoration;
  final bool required;
  final TextEditingController? controller;

  // New callback for getting the selected address
  final Function(Map<String, String>)? onAddressSelected;

  FlutterGooglePlacesWeb({
    Key? key,
    required this.apiKey,
    this.proxyURL,
    this.offset,
    this.components,
    this.sessionToken = true,
    this.decoration,
    required this.required,
    this.controller,
    this.label,
    this.onAddressSelected, // Accepting callback
  });

  @override
  FlutterGooglePlacesWebState createState() => FlutterGooglePlacesWebState();
}

class FlutterGooglePlacesWebState extends State<FlutterGooglePlacesWeb>
    with SingleTickerProviderStateMixin {
  late TextEditingController controller;
  late AnimationController _animationController;
  late Animation<Color> _loadingTween;
  List<Address> displayedResults = [];
  String proxiedURL = '';
  String offsetURL = '';
  String componentsURL = '';
  String? _sessionToken;
  // var uuid = Uuid();

  Future<List<Address>> getLocationResults(String inputText) async {
    if (_sessionToken == null && widget.sessionToken == true) {
      setState(() {
        // _sessionToken = uuid.v4();
      });
    }

    if (inputText.isEmpty) {
      setState(() {
        FlutterGooglePlacesWeb.showResults = false;
      });
    } else {
      setState(() {
        FlutterGooglePlacesWeb.showResults = true;
      });
    }

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'address';
    String input = Uri.encodeComponent(inputText);
    if (widget.proxyURL == null) {
      proxiedURL =
          '$baseURL?input=$input&key=${widget.apiKey}&type=$type&sessiontoken=$_sessionToken';
    } else {
      proxiedURL =
          '${widget.proxyURL}$baseURL?input=$input&key=${widget.apiKey}&type=$type&sessiontoken=$_sessionToken';
    }
    if (widget.offset == null) {
      offsetURL = proxiedURL;
    } else {
      offsetURL = proxiedURL + '&offset=${widget.offset}';
    }
    if (widget.components == null) {
      componentsURL = offsetURL;
    } else {
      componentsURL = offsetURL + '&components=${widget.components}';
    }

    final Map<String, dynamic> response = await http
        .get(Uri.parse('$componentsURL'))
        .then((value) => jsonDecode(value.body));
    var predictions = response['predictions'];
    if (predictions.isNotEmpty) {
      displayedResults.clear();
    }
    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      String placeId = predictions[i]['place_id'];
      String streetAddress =
          predictions[i]['structured_formatting']['main_text'];
      List<dynamic> terms = predictions[i]['terms'];
      String city = terms[terms.length - 2]['value'];
      String country = terms[terms.length - 1]['value'];
      displayedResults.add(Address(
        name: name,
        addressPlaceId: placeId,
        streetAddress: streetAddress,
        city: city,
        country: country,
      ));
    }

    return displayedResults;
  }

  selectResult(Address clickedAddress) async {
    final Map<String, dynamic> responseLocation = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=${clickedAddress.addressPlaceId}&key=${widget.apiKey}'),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Methods': 'GET,POST,HEAD'
        }).then((value) => jsonDecode(value.body));

    setState(() {
      FlutterGooglePlacesWeb.showResults = false;
      controller.text = clickedAddress.name;
      FlutterGooglePlacesWeb.value['name'] = clickedAddress.name;
      FlutterGooglePlacesWeb.value['streetAddress'] =
          clickedAddress.streetAddress;
      FlutterGooglePlacesWeb.value['city'] = clickedAddress.city;
      FlutterGooglePlacesWeb.value['country'] = clickedAddress.country;
      FlutterGooglePlacesWeb.value['lat'] = responseLocation['result']
                  ['geometry']['location']['lat']
              .toString() ??
          '';
      FlutterGooglePlacesWeb.value['long'] = responseLocation['result']
                  ['geometry']['location']['lng']
              .toString() ??
          '';

      // Triggering the callback with the selected address
      if (widget.onAddressSelected != null) {
        widget.onAddressSelected!(FlutterGooglePlacesWeb.value);
      }
    });
  }

  @override
  void initState() {
    FlutterGooglePlacesWeb.value = {};
    FlutterGooglePlacesWeb.showResults = false;
    controller = widget.controller ?? TextEditingController();
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    // _loadingTween = RainbowColorTween([
    //   const Color(0xFF4285F4), //Google Blue
    //   const Color(0xFF0F9D58), //Google Green
    //   const Color(0xFFF4B400), //Google Yellow
    //   const Color(0xFFDB4437), //Google Red
    // ]).animate(_animationController)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    _animationController.forward();
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            child: Stack(
              children: [
                TextFormField(
                  key: widget.key,
                  controller: controller,
                  validator: (value) {
                    if (widget.required == true && value!.isEmpty) {
                      return "this_field_can_t_be_empty".tr;
                    }
                    return null;
                  },
                  // cursorColor: kTitleColor,
                  textAlign: TextAlign.start,
                  // decoration: kInputDecoration.copyWith(
                  //   labelText: widget.label,
                  //   labelStyle: kTextStyle.copyWith(
                  //     color: kTitleColor,
                  //   ),
                  // contentPadding: const EdgeInsets.symmetric(
                  //   vertical: 15,
                  //   horizontal: 10.0,
                  // ),
                ),
                // onChanged: (text) {
                //   setState(() {
                //     getLocationResults(text);
                //   });
                // },
                // ),
                FlutterGooglePlacesWeb.showResults
                    ? Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                  fit: FlexFit.loose,
                                  child:
                                      // displayedResults.isEmpty
                                      // ?
                                      Container(
                                    padding: const EdgeInsets.only(
                                        top: 102, bottom: 102),
                                    child: CircularProgressIndicator(
                                      valueColor: _loadingTween,
                                      strokeWidth: 6.0,
                                    ),
                                  )
                                  // :
                                  // ListView(
                                  //     shrinkWrap: true,
                                  //     children: displayedResults
                                  //         .map(
                                  //           (Address addressData) =>
                                  //           //     SearchResultsTile(
                                  //           //   addressData: addressData,
                                  //           //   callback: selectResult,
                                  //           //   address: FlutterGooglePlacesWeb
                                  //           //       .value,
                                  //           // ),
                                  //         // )
                                  //         // .toList(),
                                  //   ),
                                  ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Address {
  String name;
  String addressPlaceId;
  String streetAddress;
  String city;
  String country;
  Address({
    required this.name,
    required this.addressPlaceId,
    required this.streetAddress,
    required this.city,
    required this.country,
  });
}
