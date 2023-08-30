// main.dart

// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors
//
// IMPORTANT !!!
// can only run on Chrome
// macOS can't call api
// still can't figual it out
//
// One more thing !!
// destination and desination can only fill with aiport code with UPPERCASE 
// class selected / baby / chlid / drawer / bottom nav bar
// dont work yet it only mock up
//
//import '/widgets/autocomplete_textfield.dart';
import '/widgets/typeahead_desination.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flightapp/screens/out_flight.dart';
import 'package:flutter/material.dart';
import '../models/flight_search_data.dart';

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


  void _navigateToResultPage() { // send data to class flight_search_data
  // ?? = defualt value
  String departure = _departureController.text ?? '';
  String arrival = _arrivalController.text ?? '';
  String adultCount = _adultCountController.text ?? '1';
  String kidCount = _kidCountController.text ?? '0';
  String babyCount = _babyCountController.text ?? '0';

  FlightSearchData searchData = FlightSearchData( // collect data  in flightSearchData
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
        ? _singleDatePickerValueWithDefaultValue[0] // pick one day
        : null,
    selectedRange: _isSelected[1]
        ? _rangeDatePickerWithActionButtonsWithValue // pick range of days
        : [null, null],//first , last
  );

  


  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultPage(searchData: searchData), // send data to result page
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      
      appBar: AppBar( // header
        title:  Image(
          image:AssetImage("images/plane.png"), // app icon
          height: 40,
          ),
        actions: [],
      ),
      drawer : Drawer( ///drawer cant do any thing
          child: ListView(
              padding: EdgeInsets.zero,
          children: [       
            ListTile(
              title: Text("main menu"),
              onTap: () {
                showDialog( // show Jason of fligh  when clicked
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Work in progess'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        ); // can only click 
              },
            ),
            ListTile(
              title: Text("setting"), // yeah! this too
              onTap: () {
                showDialog( // show Jason of fligh  when clicked
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Work in progess'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
              },
            )
          ],
          ),
      ),
      body: Column( //select trip one way/round
        children: [ // they is a select one button 
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
                  setState(() { // set the trip by set true to the list<bool> index . index[0] = one way, index[1] = round
                    for (int buttonIndex = 0; // loop check that what index is true
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
          Expanded( //detail of flight
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Column(
                  children: [
                    AutocompleteTextfield(initialText: 'Departure', controller: _departureController,),
                    AutocompleteTextfield(initialText: 'Arrival', controller: _arrivalController)
                  ],
                ),
                Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _adultCountController,
                      decoration: InputDecoration(labelText: "Adult (>11 years)"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Expanded(
                    flex: 1, 
                    child: TextField( //mock up cant search
                      controller: _kidCountController,
                      decoration: InputDecoration(labelText: "Kid (2-11 years)"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Expanded(
                    flex: 1,  
                    child: TextField( //mock up cant search
                      controller: _babyCountController,
                      decoration: InputDecoration(labelText: "Baby (<2 years)"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              ToggleButtons( //select class eco/ flight / business  premium(mock up)
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Economic'),
                      ),
                    ),
                    Expanded(
                      flex: 1, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Premium Economic'),
                      ),
                    ),
                    Expanded(
                      flex: 1, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Business'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('First Class'),
                      ),
                    ),
                  ],
                  isSelected: _isSelectedClass,
                  onPressed: (index) {
                    setState(() { // use same method as trip mode selected
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
              child: 
                  Container(
                    padding: const EdgeInsets.only(top: 0),
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(),
                      value: _singleDatePickerValueWithDefaultValue,
                      onValueChanged: (dates) =>
                          _singleDatePickerValueWithDefaultValue = dates,
                    ),
                  ),            
            ),
          if (_isSelected[1])
            Expanded(
                child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.only(top:0),
                    child: CalendarDatePicker2( // calendar round trip
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
          FloatingActionButton( //floating button for search data
            onPressed: (){
              print(_departureController.text.toString());
              print(_arrivalController.text.toString());
              // if (iataCodes.contains(_departureController.text.toString()) && iataCodes.contains(_arrivalController.text.toString())){
              //     _navigateToResultPage();
              //     }
              // else{
              //     showDialog( // show message when tap
              //             context: context,
              //             builder: (context) => AlertDialog(
              //               title: Text('Invalid input IATA code on Departure or Arrival'),
              //               actions: [
              //                 TextButton(
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: Text('Close'),
              //                 ),
              //               ],
              //             ),
              //           );
              // }
               _navigateToResultPage();
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.search),
            ),
          BottomNavigationBar( // bottun Nav bar cant do any thing just show (can click)
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'search',
                
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.airplane_ticket),
                label: 'ticket'
                )
            ],
            onTap:(value) {
              showDialog( // show message when tap
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Work in progess'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
            },
            )
        ],
      ),
    );
  }
}


