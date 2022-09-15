import 'package:flutter/material.dart';
import 'package:flutter_restaurant/view/screens/home/widget/table_book_card.dart';
import 'package:geolocator/geolocator.dart';

class BookTableScreen extends StatefulWidget {
  @override
  State<BookTableScreen> createState() => _BookTableScreen();
}

class _BookTableScreen extends State<BookTableScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController datepicker = TextEditingController();

  String dropdownValue = 'One';
  String dropdownValue1 = '1';
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/main_banner.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            height: 530,
            width: _width - 683,
            child: Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 68),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/banner.webp"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFF05A22),
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Center(
                            child: Text(
                          'Order Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 14),
                        ))))),
          ),
          SizedBox(height: 530, child: TableBookCard())
        ]));
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
