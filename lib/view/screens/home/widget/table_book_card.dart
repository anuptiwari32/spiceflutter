import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/book_table_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
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

//
  Branches dropdownValue;
  String slot = '';
  Color todayBackground = Colors.red;
  Color tommorrowBackground, lunchColor, dinnerColor = Colors.transparent;
  bool _isLoggedIn;
  Branches _branch;
  String eatingTime = "lunch";
  String eatingDay = "today";
  List<String> slots = AppConstants.SLOTS;
  List<Branches> _branchModel;
  Map<String, dynamic> _tableData;
  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    _branchModel = Provider.of<SplashProvider>(context, listen: false)
        .configModel
        .branches;

    _branch = _branchModel[0];

    _tableData = Provider.of<BookTableProvider>(context, listen: false)
        .getTableBookData();
    if (_tableData.isNotEmpty) {
      _branch = _branchModel
          .where((element) => element.id == _tableData['branch_id'])
          .first;
      eatingDay = _tableData['day'];
      eatingTime = _tableData['session'];
      changeType(eatingTime);
      changeType(eatingDay);
      datepicker.text = _tableData['date'];
    } else {
      datepicker.text =
          DateFormat(AppConstants.DATE_FORMAT).format(DateTime.now());
    }
    dropdownValue = _branch;

    Provider.of<BookTableProvider>(context, listen: false)
        .getSlots(_branch.id.toString(), datepicker.text.toString(), eatingTime,
            context)
        .then((value) {
      setState(() {
        slots = DateConverter.getSlots(value, context,
            end: datepicker.text.toString());
        slots = DateConverter.getSlots(value, context);
        slot = _tableData.isNotEmpty ? _tableData['time'] : '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookTableProvider>(builder: (context, order, child) {
      return Stack(children: <Widget>[
        Container(
            width: ResponsiveHelper.isDesktop(context) ? 380 : 1170,
            height: 450,
            padding: ResponsiveHelper.isMobile(context)
                ? const EdgeInsets.all(0)
                : const EdgeInsets.fromLTRB(15, 30, 15, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFE0EE0),
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
            ),
            margin: ResponsiveHelper.isMobile(context)
                ? const EdgeInsets.all(0)
                : const EdgeInsets.fromLTRB(10, 10, 20, 10),
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
                  selectedItem: dropdownValue,
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
                          color: todayBackground,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                            onTap: () {
                              changeBackground('today', context, order);
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
                          color: tommorrowBackground,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                changeBackground('tommorrow', context, order);
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
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.0),
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
                                            onPrimary: Colors
                                                .redAccent, // <-- SEE HERE
                                            onSurface:
                                                Colors.red, // <-- SEE HERE
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              primary: Colors
                                                  .red, // button text color
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
                                  changeBackground('date', context, order);
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
                          color: lunchColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                            onTap: () {
                              changeBackground('lunch', context, order);
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
                          color: dinnerColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                            onTap: () {
                              changeBackground('dinner', context, order);
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
                        selectedItem: slot,
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
                        showSearchBox: true,
                        searchFieldProps: const TextFieldProps(
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Search slots",
                              hintText: "Select Slot",
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                            )),
                        // focusColor: Colors.red,
                        dropdownButtonProps: const IconButtonProps(
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.red,
                          ),
                        ),

                        onChanged: (String newValue) {
                          setState(() {
                            slot = newValue;
                          });
                        },
                        items: slots,
                      ),
                    ))
                  ],
                ),
              ),
            ])),
        Positioned(
          bottom: 0,
          left: ResponsiveHelper.isDesktop(context)
              ? 120.0
              : MediaQuery.of(context).size.width / 2 - 70,
          child: InkWell(
              onTap: () {
                Map<String, dynamic> data = Map<String, dynamic>();
                data['branch_id'] = dropdownValue.id;
                data['date'] = datepicker.text.toString();
                data['session'] = eatingTime;
                data['day'] = eatingDay;
                data['time'] = slot;
                if (!_isLoggedIn) {
                  Navigator.pushReplacementNamed(
                      context, Routes.getLoginRoute());
                  order.addTableBookData(data);
                } else {
                  if (slots.length == 0)
                    showCustomSnackBar(
                        'There is not available slot for booking', context,
                        isError: true);
                  else if (slot == '')
                    showCustomSnackBar(
                        'Please Select the time slot for booking', context,
                        isError: true);
                  else
                    order
                        .checkAvailability(dropdownValue.id.toString(),
                            datepicker.text, slot, context)
                        .then((value) {
                      if (order.isAvailable) {
                        order.addTableBookData(data);
                        order.addItemsToCart(context);
                        Navigator.pushReplacementNamed(
                            context, Routes.getDashboardRoute('book'));
                      }
                    });

                  //
                }
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
                      Images.food_icon,
                      height: 60,
                    ),
                    radius: 40.0,
                  ),
                ),
              ))),
        )
      ]);
    });
  }

  changeBackground(String type, BuildContext context, BookTableProvider order) {
    // Color color = Color.fromARGB(Random().nextInt(256), Random().nextInt(256),
    //     Random().nextInt(256), Random().nextInt(256));

    setState(() {
      var branchId = dropdownValue != null
          ? dropdownValue.id.toString()
          : _branch.id.toString();
      var dateSelected = datepicker.text.isNotEmpty
          ? datepicker.text
          : DateFormat(AppConstants.DATE_FORMAT).format(DateTime.now());

      order.getSlots(branchId, dateSelected, eatingTime, context).then((value) {
        slots = DateConverter.getSlots(value, context, end: dateSelected);
        slot = '';
      });
      if (dateSelected ==
          DateFormat(AppConstants.DATE_FORMAT).format(DateTime.now()))
        type = 'today';
      else if (DateFormat(AppConstants.DATE_FORMAT)
              .format(DateTime.now().add(const Duration(days: 1))) ==
          dateSelected) type = 'tommorrow';

      changeType(type);
    });
  }

  void changeType(String type) {
    switch (type) {
      case 'lunch':
        {
          lunchColor = Colors.red;
          dinnerColor = Colors.transparent;
          eatingTime = "lunch";
          break;
        }
      case 'dinner':
        {
          lunchColor = Colors.red;
          dinnerColor = Colors.transparent;
          eatingTime = "dinner";
          break;
        }
      case 'today':
        {
          todayBackground = Colors.red;
          tommorrowBackground = Colors.transparent;
          String formattedDate =
              DateFormat(AppConstants.DATE_FORMAT).format(DateTime.now());
          datepicker.text = formattedDate; //set output date to TextField value
          break;
        }
      case 'tommorrow':
        {
          tommorrowBackground = Colors.red;
          todayBackground = Colors.transparent;
          var today = DateTime.now();
          String formattedDate = DateFormat(AppConstants.DATE_FORMAT)
              .format(today.add(const Duration(days: 1)));
          datepicker.text = formattedDate;
          break;
        }
      case 'date':
        {
          tommorrowBackground = Colors.transparent;
          todayBackground = Colors.transparent;
          break;
        }
      default:
        {
          tommorrowBackground = Colors.transparent;
          todayBackground = Colors.transparent;
          lunchColor = Colors.transparent;
          dinnerColor = Colors.transparent;
          break;
        }
    }
  }
}

Widget _customPopupItemBuilderExample2(
    BuildContext context, Branches item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item?.name ?? ''),
      subtitle: Text(item?.address?.toString() ?? ''),
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        // this does not work - throws 404 error
        // backgroundImage: NetworkImage(item.avatar ?? ''),
      ),
    ),
  );
}
