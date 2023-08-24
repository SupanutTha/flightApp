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
          image:AssetImage("../images/plane.png"), // app icon
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField( // only upper case and airport short name
                    controller: _departureController, // Use the controller for Departure
                    decoration: InputDecoration(labelText: "Departure (airport code Ex. BKK)"),
                    keyboardType: TextInputType.text,
                    
                    
                    
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _arrivalController, // Use the controller for Arrival
                    decoration: InputDecoration(labelText: "Arrival (airport code Ex. SYD)" ),
                    keyboardType: TextInputType.text,
                  ),
                ),


                Row(
  children: [
    Expanded(
      flex: 1,
      child: TextField(
        controller: _adultCountController,
        decoration: InputDecoration(labelText: "Adult (more than 11 years)"),
        keyboardType: TextInputType.text,
      ),
    ),
    Expanded(
      flex: 1, 
      child: TextField( //mock up cant search
        controller: _kidCountController,
        decoration: InputDecoration(labelText: "Kid (2-11 years) *WIP"),
        keyboardType: TextInputType.text,
      ),
    ),
    Expanded(
      flex: 1,  
      child: TextField( //mock up cant search
        controller: _babyCountController,
        decoration: InputDecoration(labelText: "Baby (below 2 years) *WIP"),
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
        child: Text('Economic Class (wip)'),
      ),
    ),
    Expanded(
      flex: 1, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Premium Economic Class (wip)'),
      ),
    ),
    Expanded(
      flex: 1, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Business Class (wip)'),
      ),
    ),
    Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('First Class (wip)'),
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
  child: Column( // calender one-way 
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
              if (iataCodes.contains(_departureController.text.toString()) && iataCodes.contains(_arrivalController.text.toString())){
                  _navigateToResultPage();
                  }
              else{
                  showDialog( // show message when tap
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Invalid input IATA code on Departure or Arrival'),
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
              }
            
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

List<String> iataCodes = [
  'POM', 'KEF', 'PRN', 'YEG', 'YHZ', 'YOW', 'YUL', 'YVR', 'YWG', 'YYC', 'YYJ',
  'YYT', 'YYZ', 'ALG', 'OUA', 'ACC', 'ABV', 'QUO', 'KAN', 'LOS', 'NIM', 'TUN',
  'BRU', 'CRL', 'LGG', 'SXF', 'DRS', 'FRA', 'FMO', 'HAM', 'CGN', 'DUS', 'MUC',
  'NUE', 'LEJ', 'STR', 'TXL', 'HAJ', 'BRE', 'DTM', 'FKB', 'TLL', 'HEL', 'BFS',
  'BHD', 'BHX', 'MAN', 'DSA', 'CWL', 'BRS', 'LPL', 'LTN', 'BOH', 'SOU', 'LGW',
  'LHR', 'LBA', 'NCL', 'EMA', 'ABZ', 'GLA', 'EDI', 'NWI', 'STN', 'EXT', 'LKZ',
  'MHZ', 'FFD', 'BZZ', 'AMS', 'EIN', 'ORK', 'DUB', 'SNN', 'BLL', 'CPH', 'AAL',
  'LUX', 'BOO', 'BGO', 'OSL', 'TOS', 'TRD', 'SVG', 'GDN', 'KRK', 'KTW', 'WMI',
  'POZ', 'WAW', 'WRO', 'GOT', 'MMX', 'LLA', 'ARN', 'RMS', 'RIX', 'VNO', 'CPT',
  'GRJ', 'DUR', 'JNB', 'GBE', 'SHO', 'MRU', 'LUN', 'TNR', 'LAD', 'MPM', 'SEZ',
  'NDJ', 'HRE', 'WDH', 'FIH', 'BKO', 'SPC', 'LPA', 'TFS', 'TFN', 'FNA', 'ROB',
  'CMN', 'DSS', 'DKR', 'NKC', 'SID', 'ADD', 'HGA', 'CAI', 'HRG', 'LXR', 'NBO',
  'MBA', 'TIP', 'KGL', 'JUB', 'KRT', 'DAR', 'ZNZ', 'EBB', 'AAP', 'ABQ', 'ADW',
  'AFW', 'AGS', 'AMA', 'ATL', 'AUS', 'AVL', 'BAB', 'BAD', 'BDL', 'BFI', 'BGR',
  'BHM', 'BIL', 'BLV', 'BMI', 'BNA', 'BOI', 'BOS', 'BUF', 'BWI', 'CAE', 'CBM',
  'CHA', 'CHS', 'CID', 'CLE', 'CLT', 'CMH', 'COS', 'CRP', 'CRW', 'CVG', 'CVS',
  'DAB', 'DAL', 'DAY', 'DBQ', 'DCA', 'DEN', 'DFW', 'DLF', 'DLH', 'DOV', 'DSM',
  'DTW', 'DYS', 'EDW', 'END', 'ERI', 'EWR', 'FFO', 'FLL', 'FSM', 'FTW', 'FWA',
  'GEG', 'GPT', 'GRB', 'GSB', 'GSO', 'GSP', 'GUS', 'HIB', 'HMN', 'HOU', 'HSV',
  'HTS', 'IAD', 'IAH', 'ICT', 'IND', 'JAN', 'JAX', 'JFK', 'JLN', 'LAS', 'LAX',
  'LBB', 'LCK', 'LEX', 'LFI', 'LFT', 'LGA', 'LIT', 'LTS', 'LUF', 'MBS', 'MCF',
  'MCI', 'MCO', 'MDW', 'MEM', 'MGE', 'MGM', 'MHT', 'MIA', 'MKE', 'MLI', 'MLU',
  'MOB', 'MSN', 'MSP', 'MSY', 'MUO', 'OAK', 'OKC', 'OMA', 'ONT', 'ORD', 'ORF',
  'PAM', 'PBI', 'PDX', 'PHF', 'PHL', 'PHX', 'PIA', 'PIT', 'PVD', 'PWM', 'RDU',
  'RFD', 'RIC', 'RND', 'RNO', 'ROA', 'ROC', 'RST', 'RSW', 'SAN', 'SAT', 'SAV',
  'SBN', 'SDF', 'SEA', 'SFB', 'SFO', 'SGF', 'SJC', 'SKA', 'SLC', 'SMF', 'SNA',
  'SPI', 'SPS', 'SRQ', 'SSC', 'STL', 'SUS', 'SUU', 'SUX', 'SYR', 'SZL', 'TCM',
  'TIK', 'TLH', 'TOL', 'TPA', 'TRI', 'TUL', 'TUS', 'TYS', 'VBG', 'VPS', 'WRB',
  'TIA', 'BOJ', 'SOF', 'VAR', 'LCA', 'PFO', 'AKT', 'ZAG', 'ALC', 'BCN', 'MAD',
  'AGP', 'PMI', 'SCQ', 'BOD', 'TLS', 'LYS', 'MRS', 'NCE', 'CDG', 'ORY', 'BSL',
  'ATH', 'HER', 'SKG', 'BUD', 'BRI', 'CTA', 'PMO', 'CAG', 'MXP', 'BGY', 'TRN',
  'GOA', 'LIN', 'BLQ', 'TSF', 'VRN', 'VCE', 'CIA', 'FCO', 'NAP', 'PSA', 'LJU',
  'PRG', 'TLV', 'VDA', 'MLA', 'VIE', 'FAO', 'TER', 'PDL', 'OPO', 'LIS', 'SJJ',
  'OTP', 'GVA', 'ZRH', 'ESB', 'ADA', 'AYT', 'GZT', 'ISL', 'ADB', 'DLM', 'ERZ',
  'TZX', 'ISE', 'BJV', 'SAW', 'IST', 'SKP', 'BEG', 'TGD', 'BTS', 'PUJ', 'SDQ',
  'GUA', 'KIN', 'ACA', 'GDL', 'HMO', 'MEX', 'MTY', 'PVR', 'SJD', 'TIJ', 'CUN',
  'PTY', 'LIR', 'SAL', 'HAV', 'VRA', 'GCM', 'NAS', 'BZE', 'RAR', 'PPT', 'AKL',
  'CHC', 'WLG', 'BAH', 'DMM', 'DHA', 'JED', 'MED', 'RUH', 'IKA', 'THR', 'MHD',
  'SYZ', 'TBZ', 'AMM', 'KWI', 'BEY', 'DQM', 'MNH', 'AUH', 'DXB', 'DWC', 'SHJ',
  'MCT', 'ISB', 'SKT', 'BGW', 'BSR', 'ALP', 'DAM', 'LTK', 'DOH', 'FAI', 'ANC',
  'GUM', 'CGY', 'HNL', 'KNH', 'KHH', 'TPE', 'NRT', 'KIX', 'CTS', 'FUK', 'KOJ',
  'NGO', 'FSZ', 'ITM', 'HND', 'OKO', 'MWX', 'KUV', 'CJU', 'PUS', 'ICN', 'OSN',
  'GMP', 'CJJ', 'OKA', 'DNA', 'CRK', 'MNL', 'DVO', 'CEB', 'GRV', 'EZE', 'BEL',
  'BSB', 'CNF', 'CWB', 'MAO', 'FLN', 'GIG', 'GRU', 'NAT', 'CGH', 'SSA', 'SCL',
  'LTX', 'UIO', 'BOG', 'VVI', 'LIM', 'CUZ', 'MVD', 'BLA', 'CCS', 'PTP', 'SJU',
  'NBE', 'SXM', 'ALA', 'TSE', 'FRU', 'KGF', 'GYD', 'EVN', 'TBS', 'KHV', 'KBP',
  'SIP', 'HRK', 'ODS', 'LED', 'MSQ', 'KJA', 'OVB', 'ROV', 'AER', 'SVX', 'ASB',
  'TAS', 'ZIA', 'DME', 'SVO', 'VKO', 'KZN', 'UFA', 'KUF', 'BOM', 'GOI', 'CMB',
  'HRI', 'PNH', 'REP', 'CCU', 'DAC', 'HKG', 'ATQ', 'DEL', 'MFM', 'KTM', 'BLR',
  'COK', 'CCJ', 'HYD', 'MAA', 'TRV', 'MLE', 'DMK', 'BKK', 'CNX', 'HKT', 'DAD',
  'HAN', 'SGN', 'MDL', 'RGN', 'UPG', 'DPS', 'DJJ', 'SUB', 'SOQ', 'BWN', 'CGK',
  'KNO', 'KUL', 'SIN', 'BNE', 'MEL', 'YNT', 'ADL', 'PER', 'CBR', 'SYD', 'PEK',
  'PKX', 'HET', 'NAY', 'TSN', 'TYN', 'CAN', 'CSX', 'KWL', 'NNG', 'SZX', 'CGO',
  'WUH', 'HAK', 'SYX', 'XIY', 'UBN', 'ULN', 'KMG', 'XMN', 'FOC', 'HGH', 'TNA',
  'NGB', 'NKG', 'PVG', 'SHA', 'WNZ', 'CKG', 'KWE', 'CTU', 'URC', 'HRB', 'DLC',
  'SHE','KBV'
];
