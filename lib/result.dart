import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'accessToken.dart';
import 'flight.dart';
import 'flight_search_data.dart';





class ResultPage extends StatefulWidget {
  final FlightSearchData searchData; // retrive data form flight_search_data

  ResultPage({required this.searchData});

  @override
  _ResultPageState createState() => _ResultPageState();
  
 
}


class _ResultPageState extends State<ResultPage> {
  List<Flight> _searchResults = []; // collect all flight that can search in the list
  bool _isLoading = true; // to check that can access token

  @override
  void initState() {
    print("check init state");// check
    super.initState();
    // Call the API and search for flights using the searchData from widget.searchData
    _getAccessToken(); // Get the access token first
  }
  
  Future<void> _getAccessToken() async { // need to get access token every time to search data
    try { // exception to check api status
      final tokenUrl = 'https://test.api.amadeus.com/v1/security/oauth2/token';
      final clientId = 'PBjFEhvGHXAzDb6blW0BRCcORKTiZKMj';
      final clientSecret = '4Pf1CUcDoTBgL5DB';
      print("check token"); 
      final response = await http.post( // call api for amadeus to gain acess token
        Uri.parse('$tokenUrl'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );
      //exception
      if (response.statusCode == 200) {
        AccessToken accessToken = AccessToken.fromJson(json.decode(response.body));
        _searchFlights(accessToken);
        print("token grain");
      } else {
        throw Exception('Failed to retrieve access token');
      }
    } catch (e) {
      // return error
      print('Error: $e');
    }
  }

    
    Future<void> _searchFlights(AccessToken accessToken) async { // use acceess to token to call api to search data
  try {
    
    final baseUrl = 'https://test.api.amadeus.com/v2/shopping/flight-offers';
    final dateFormatter = DateFormat('yyyy-MM-dd'); // set format date
    print(widget.searchData.getEffectiveDate()!); // check that what date data is available 
    final formattedDate = dateFormatter.format(widget.searchData.getEffectiveDate()!); // change format date
    final maxFlights = 10; // Set the maximum number of flight results to display .now recommend 2 is maximun if set maximum more than it can search it gonna bug it list

    // 1. Search for outbound flights
    final outboundResponse = await http.get(
      Uri.parse(
        '$baseUrl?originLocationCode=${widget.searchData.departure}&destinationLocationCode=${widget.searchData.arrival}&departureDate=$formattedDate&adults=${widget.searchData.adultCount}',
      ),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
      },
    );

    // 2. Search for return flights
    final returnDate = dateFormatter.format(widget.searchData.getEffectiveDateReturn()!);
    final returnResponse = await http.get(
      Uri.parse(
        '$baseUrl?originLocationCode=${widget.searchData.arrival}&destinationLocationCode=${widget.searchData.departure}&departureDate=$returnDate&adults=${widget.searchData.adultCount}',
      ),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
      },
    );
   
   // one way trip and round trip use difference date format
   // still can't figure out how to seperate the one way and round trip
  // update bug fix 

    if (outboundResponse.statusCode == 200 && returnResponse.statusCode == 200) {
    
      Map<String, dynamic> outboundData = json.decode(outboundResponse.body);
      Map<String, dynamic> returnData = json.decode(returnResponse.body);
      List<dynamic> outboundFlightData = outboundData['data'];
      List<dynamic> returnFlightData = returnData['data'];

      int numOutboundResults = outboundFlightData.length;
      int numReturnResults = returnFlightData.length;

      print("out flight: ${numOutboundResults}");
      print("in flight: ${numReturnResults}");

      // check that it dont add flight in list more than maximum
      // it not working propaly if the flight that can search less than maximum = bug ;-;
      if (numOutboundResults > maxFlights) {
        outboundFlightData = outboundFlightData.sublist(0, maxFlights); // Take only the first 'max' flight results
      }
      if (numReturnResults > maxFlights) {
        returnFlightData = returnFlightData.sublist(0, maxFlights); // Take only the first 'max' flight results
      }
      print("check maximum flight limit if");
      print(outboundFlightData);
      List<Flight> outboundResults = outboundFlightData.map((flight) => Flight.fromJson(flight)).toList(); //change json to list
      print("check");
      List<Flight> returnResults = returnFlightData.map((flight) => Flight.fromJson(flight)).toList(); // change json to list
      print("out flight: ${outboundResults}");
      print("in flight: ${returnResults}");

      // Combine outbound and return results into a single list
      List<Flight> results = [];
      results.addAll(outboundResults);
      print("result list: ${results}");
      

      // if the bug that one way trip show flight back trip by if one way trip not adding flight back trip in list
      if (widget.searchData.selectedDate == null){
        results.addAll(returnResults);
      }
      

      setState(() {
        _searchResults = results;
        _isLoading = false; // Set loading to false after processing the API response
      });
    } else {
      setState(() {
        _isLoading = false; // Set loading to false if the API call failed
      });
      throw Exception('Failed to load flights');
    }
  } catch (e) {
    setState(() {
      _isLoading = false; // Set loading to false if an error occurred
    });
    // check any errors
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // header
        title: Text("Flight Search Results"),
      ),
      body: _isLoading 
          ? Center( // if can find the flight
              child: CircularProgressIndicator(),
            )
          : _searchResults.isNotEmpty // Check if flight results are available
              ? ListView.builder( // create listview to show the flight
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    Flight flight = _searchResults[index];
                    // Display flight information here using the Flight model properties
                    return ListTile(
                      title: Text('${flight.airline} ${flight.flightNumber}: ${flight.departure} - ${flight.arrival}'), //show route
                      subtitle:
                          Text('Departure: ${flight.departureTime}, Arrival: ${flight.arrivalTime}'), // show schedual
                      trailing: Text('\$${flight.price}'),
                      onTap: () {
                        showDialog( // show Jason of fligh  when clicked
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Flight Details'),
                            content: Text(json.encode(flight.toJson())), // Show flight details in JSON format
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
                    );
                  },
                )
              : Center(
                  child: Text('Sorry, no flights found.'), // show error massage if cant find the flight
                ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ResultPage(
        searchData: FlightSearchData(
          departure: 'SYD',
          arrival: 'BKK',
          adultCount: '1',
          kidCount: '0',
          babyCount: '0',
          selectedDate: DateTime.parse('2023-08-03'),
          selectedRange: [],
          isEconomicClass: true,
          isPremiumEconomicClass: false,
          isBusinessClass: false,
          isFirstClass: false,
        ),
      ),
    ),
  );
}
