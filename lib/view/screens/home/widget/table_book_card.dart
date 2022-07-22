import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TableBookCard extends StatefulWidget {
  @override
  State<TableBookCard> createState() => _TableBookCard();
}

class _TableBookCard extends State<TableBookCard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController datepicker = TextEditingController();
  final TextEditingController timepicker = TextEditingController();

  Branches dropdownValue;
  String dropdownValue1 = '1';
  Color today_background = Colors.red;
  Color tommorrow_background = Colors.transparent;
  bool _isLoggedIn;
  String eating_time = "Lunch";
  @override
  Widget build(BuildContext context) {
    final _branchModel = Provider.of<SplashProvider>(context, listen: false)
        .configModel
        .branches;
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Stack(children: <Widget>[
      Container(
          width: 380,
          height: 450,
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFE0EE0), blurRadius: 5, spreadRadius: 1)
            ],
          ),
          margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
          child: Column(children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                child: const Text(
                  'Let\'s  Book A Table for you',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25),
                )),
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                child: const Text(
                  'Don’t wait in a line to enjoy your meal. \n Reserve a table in advance with us.',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                )),
            Container(
              margin: const EdgeInsets.all(10),
              child: DropdownSearch<Branches>(
                //selectedItem: dropdownValue,
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Select Region",
                  hintText: "Select the nearest center",
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Search Location",
                      hintText: "Select Location",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                    )),
                mode: Mode.MENU,
                popupItemBuilder: _customPopupItemBuilderExample2,
                // focusColor: Colors.red,
                dropdownButtonProps: const IconButtonProps(
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                  ),
                ),

                onChanged: (Branches newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: _branchModel,
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: const Text('Date')),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF05A22),
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: today_background,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              changeBackground('today');
                            });
                          },
                          child: Center(
                              child: const Text(
                            'Today',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          )))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF05A22),
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: tommorrow_background,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              changeBackground('tommorrow');
                            });
                          },
                          child: const Center(
                              child: Text(
                            'Tomorrow',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          )))),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          height: 40,
                          child: Center(
                              child: TextField(
                            controller:
                                datepicker, //editing controller of this TextField
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                focusColor: Colors.red,
                                icon: Icon(Icons.calendar_today,
                                    color: Colors.red),
                                hintStyle: TextStyle(
                                    color: Colors.black), //icon of text field
                                hintText: "Enter Date" //label text of field
                                ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              // Position position =
                              //     await _determinePosition();
                              // print(position);
                              DateTime pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors
                                              .amberAccent, // <-- SEE HERE
                                          onPrimary:
                                              Colors.redAccent, // <-- SEE HERE
                                          onSurface: Colors.red, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            primary:
                                                Colors.red, // button text color
                                          ),
                                        ),
                                      ),
                                      child: child,
                                    );
                                  });
                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat(AppConstants.DATE_FORMAT)
                                        .format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  datepicker.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ))))
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: const Text('Session')),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF05A22),
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              eating_time = "lunch";
                            });
                          },
                          child: const Center(
                              child: Text(
                            'Lunch',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          )))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF05A22),
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              eating_time = "lunch";
                            });
                          },
                          child: const Center(
                              child: Text(
                            'Dinner',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          )))),
                  Expanded(
                      child: Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownSearch<String>(
                      //selectedItem: dropdownValue,
                      dropdownSearchDecoration: const InputDecoration(
                          labelText: "Choose Time",
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          icon: Icon(Icons.alarm, color: Colors.red)),
                      mode: Mode.MENU,
                      // focusColor: Colors.red,
                      dropdownButtonProps: const IconButtonProps(
                        icon: Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),

                      onChanged: (String newValue) {
                        setState(() {
                          //dropdownValue = newValue;
                        });
                      },
                      items: const <String>[
                        '12:00 AM',
                        '01:00 AM',
                        '02:00 AM',
                        '03:00 AM',
                        '04:00 AM',
                        '05:00 AM',
                        '06:00 AM',
                        '07:00 AM',
                        '08:00 AM',
                        '09:00 AM',
                        '10:00 AM',
                        '11:00 AM',
                        '12:00 PM',
                        '01:00 PM',
                        '02:00 PM',
                        '03:00 PM',
                        '04:00 PM',
                        '05:00 PM',
                        '06:00 PM',
                        '07:00 PM',
                        '08:00 PM',
                        '09:00 PM',
                        '10:00 PM',
                        '11:00 PM',
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ])),
      Positioned(
        bottom: 0,
        left: 120.0,
        child: InkWell(
            onTap: () => {
                  if (!_isLoggedIn)
                    Navigator.pushReplacementNamed(
                        context, Routes.getLoginRoute())
                  else
                    Navigator.pushReplacementNamed(
                        context, Routes.getDashboardRoute('cart'))
                },
            child: Center(
                child: AvatarGlow(
              glowColor: Colors.red,
              endRadius: 80.0,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: false,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: Material(
                // Replace this child with your own
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/image/food_icon.png',
                    height: 60,
                  ),
                  radius: 40.0,
                ),
              ),
            ))),
      )
    ]);
  }

  changeBackground(String type) {
    // Color color = Color.fromARGB(Random().nextInt(256), Random().nextInt(256),
    //     Random().nextInt(256), Random().nextInt(256));
    setState(() {
      switch (type) {
        case 'today':
          {
            today_background = Colors.red;
            tommorrow_background = Colors.transparent;
            String formattedDate =
                DateFormat(AppConstants.DATE_FORMAT).format(DateTime.now());
            //formatted date output using intl package =>  2021-03-16
            //you can implement different kind of Date Format here according to your requirement
            datepicker.text =
                formattedDate; //set output date to TextField value
            break;
          }
        case 'tommorrow':
          {
            tommorrow_background = Colors.red;
            today_background = Colors.transparent;
            var today = DateTime.now();

            String formattedDate = DateFormat(AppConstants.DATE_FORMAT)
                .format(today.add(const Duration(days: 1)));
            //formatted date output using intl package =>  2021-03-16 //you can implement different kind of Date Format here according to your requirement
            datepicker.text = formattedDate;
            break;
          }
      }
    });
  }
}

Widget _customPopupItemBuilderExample2(
    BuildContext context, Branches item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColorLight),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item?.name ?? ''),
      subtitle: Text(item?.address?.toString() ?? ''),
      leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
          ),
    ),
  );
}
