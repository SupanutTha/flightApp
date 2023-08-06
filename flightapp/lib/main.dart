// main.dart

// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flightapp/result.dart';
import 'package:flutter/material.dart';

import 'flight_search_data.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> _isSelected = [true, false]; //for one way - round button default is one-way
  List<bool> _isSelectedClass = [true, false, false, false]; //for class selected eco/bus/first/.. default is eco
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [ // calendar for one way trip
    DateTime.now(),
  ];
  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [ // calendar for round trip
    DateTime.now(),
    DateTime.now().add(const Duration(days: 0)),
  ];

  TextEditingController _departureController = TextEditingController();
  TextEditingController _arrivalController = TextEditingController();
  TextEditingController _adultCountController = TextEditingController(text: '1');
  TextEditingController _kidCountController = TextEditingController(text: '0');
  TextEditingController _babyCountController = TextEditingController(text: '0');


  void _navigateToResultPage() {
  // ?? = defualt value
  String departure = _departureController.text ?? '';
  String arrival = _arrivalController.text ?? '';
  String adultCount = _adultCountController.text ?? '1';
  String kidCount = _kidCountController.text ?? '0';
  String babyCount = _babyCountController.text ?? '0';

  FlightSearchData searchData = FlightSearchData(
    departure: departure,
    arrival: arrival,
    adultCount: adultCount,
    kidCount: kidCount,
    babyCount: babyCount,
    isEconomicClass: _isSelectedClass[0],
    isPremiumEconomicClass: _isSelectedClass[1],
    isBusinessClass: _isSelectedClass[2],
    isFirstClass: _isSelectedClass[3],
    // if true = ?
    // false = :
    selectedDate: _isSelected[0]
        ? _singleDatePickerValueWithDefaultValue[0]
        : null,
    selectedRange: _isSelected[1]
        ? _rangeDatePickerWithActionButtonsWithValue
        : [null, null],//first , last
  );


  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultPage(searchData: searchData),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Flight"),
        actions: [],
      ),
      body: Column(
        children: [
          Row(
            children: [
              ToggleButtons(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('One-way Flight'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Round Flight'),
                  )
                ],
                isSelected: _isSelected,
                onPressed: (index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < _isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        _isSelected[buttonIndex] = true;
                      } else {
                        _isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _departureController, // Use the controller for Departure
                    decoration: InputDecoration(labelText: "Departure"),
                    keyboardType: TextInputType.text,
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _arrivalController, // Use the controller for Arrival
                    decoration: InputDecoration(labelText: "Arrival"),
                    keyboardType: TextInputType.text,
                  ),
                ),


                Row(
  children: [
    Expanded(
      flex: 1, // Custom flex value for the first TextField
      child: TextField(
        controller: _adultCountController,
        decoration: InputDecoration(labelText: "Adult (more than 11 years)"),
        keyboardType: TextInputType.text,
      ),
    ),
    Expanded(
      flex: 1, // Custom flex value for the second TextField
      child: TextField(
        controller: _kidCountController,
        decoration: InputDecoration(labelText: "Kid (2-11 years)"),
        keyboardType: TextInputType.text,
      ),
    ),
    Expanded(
      flex: 1, // Custom flex value for the third TextField
      child: TextField(
        controller: _babyCountController,
        decoration: InputDecoration(labelText: "Baby (below 2 years)"),
        keyboardType: TextInputType.text,
      ),
    ),
  ],
),

                ToggleButtons(
                  children: [
    Expanded(
      flex: 1, // Custom flex value for the first Text widget
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Economic Class'),
      ),
    ),
    Expanded(
      flex: 1, // Custom flex value for the second Text widget
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Premium Economic Class'),
      ),
    ),
    Expanded(
      flex: 1, // Custom flex value for the third Text widget
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Business Class'),
      ),
    ),
    Expanded(
      flex: 1, // Custom flex value for the fourth Text widget
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('First Class'),
      ),
    ),
  ],
                  isSelected: _isSelectedClass,
                  onPressed: (index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _isSelectedClass.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _isSelectedClass[buttonIndex] = true;
                        } else {
                          _isSelectedClass[buttonIndex] = false;
                        }
                      }
                    });
                  },
                ),
              ]),
            ),
          ),
          if (_isSelected[0])
            Expanded(
  child: Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 0),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2Config(),
          value: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (dates) =>
              _singleDatePickerValueWithDefaultValue = dates,
        ),
      ),
    ],
  ),
),

          if (_isSelected[1])
            Expanded(
                child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.only(top:0),
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.range,
                      ),
                      value: _rangeDatePickerWithActionButtonsWithValue,
                      onValueChanged: (dates) =>
                          _rangeDatePickerWithActionButtonsWithValue = dates,
                    ),
                  );
                }
              ),
            ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            onPressed: _navigateToResultPage,
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}
