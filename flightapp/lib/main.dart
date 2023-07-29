// main.dart

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flightapp/result.dart';
import 'package:flutter/material.dart';

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
  List<bool> _isSelected = [true, false];
  List<bool> _isSelectedClass = [true, false, false, false];
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 0)),
  ];

  // Define the controllers
  TextEditingController _departureController = TextEditingController();
  TextEditingController _arrivalController = TextEditingController();
  TextEditingController _adultCountController = TextEditingController(text: '1');
  TextEditingController _kidCountController = TextEditingController(text: '0');
  TextEditingController _babyCountController = TextEditingController(text: '0');

  // Create a function to navigate to the result page and pass data as arguments
  void _navigateToResultPage() {
    FlightSearchData searchData = FlightSearchData(
      departure: _departureController.text,
      arrival: _arrivalController.text,
      adultCount: _adultCountController.text,
      kidCount: _kidCountController.text,
      babyCount: _babyCountController.text,
      isEconomicClass: _isSelectedClass[0],
      isPremiumEconomicClass: _isSelectedClass[1],
      isBusinessClass: _isSelectedClass[2],
      isFirstClass: _isSelectedClass[3],
      selectedDate: _isSelected[0]
          ? _singleDatePickerValueWithDefaultValue[0]
          : null,
      selectedRange: _isSelected[1]
          ? _rangeDatePickerWithActionButtonsWithValue
          : [null, null],
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
                    child: Text('Go-Back Flight'),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _adultCountController, // Use the controller for Adult Count
                    decoration:
                        InputDecoration(labelText: "Adult (more than 11 years)"),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _kidCountController, // Use the controller for Kid Count
                    decoration: InputDecoration(labelText: "Kid (2-11 years)"),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _babyCountController, // Use the controller for Baby Count
                    decoration:
                        InputDecoration(labelText: "Baby (below 2 years)"),
                    keyboardType: TextInputType.text,
                  ),
                ),
                ToggleButtons(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Economic Class'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Premiun Economic Class'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Business Class'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('First Class'),
                    )
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
                    padding: const EdgeInsets.only(top: 40.0),
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
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.range,
                  ),
                  value: _rangeDatePickerWithActionButtonsWithValue,
                  onValueChanged: (dates) =>
                      _rangeDatePickerWithActionButtonsWithValue = dates,
                ),
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
