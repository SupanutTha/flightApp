

import 'package:flightapp/screens/flight_summary.dart';
import 'package:flightapp/screens/return_flight.dart';
import 'package:flightapp/models/selected_flights.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../services/accessToken.dart';
import '../models/flight.dart';
import '../models/flight_search_data.dart';





class ResultPage extends StatefulWidget {
  final FlightSearchData searchData; // retrive data form flight_search_data

  ResultPage({required this.searchData});

  @override
  _ResultPageState createState() => _ResultPageState();
  
 
}


class _ResultPageState extends State<ResultPage> {
  List<Flight> _searchResults = []; // collect all flight that can search in the list
  List<Flight> _searchResultsReturn = [];
  bool _isLoading = true; // to check that can access token

  // String _sortingOption = 'Default'; // Default sorting option
  // bool _sortAscending = true; // Default sorting order

  // void _sortResults(String option) {
  //   setState(() {
  //     _sortingOption = option;

  //     if (_sortingOption == 'Fastest') {
  //       _searchResults.sort((a, b) => a.getTotalDuration().compareTo(b.getTotalDuration()));
  //     } else if (_sortingOption == 'Cheapest') {
  //       _searchResults.sort((a, b) => a.price['total'].compareTo(b.price['total']));
  //     } else if (_sortingOption == 'Direct') {
  //       _searchResults.sort((a, b) => a.itineraries[0]['segments'].length.compareTo(b.itineraries[0]['segments'].length));
  //     }

  //     if (!_sortAscending) {
  //       _searchResults = List.from(_searchResults.reversed);
  //     }
  //   });
  // }
  
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
    var flightClass = '';
    if ( widget.searchData.isEconomicClass){
      flightClass = 'ECONOMY';
    }
    else if( widget.searchData.isBusinessClass){
      flightClass = 'BUSINESS';
    }
    else if( widget.searchData.isPremiumEconomicClass){
      flightClass = 'PREMIUM_ECONOMY';
    }
    else if( widget.searchData.isPremiumEconomicClass){
      flightClass = 'FIRST';
    }

    final baseUrl = 'https://test.api.amadeus.com/v2/shopping/flight-offers';
    final dateFormatter = DateFormat('yyyy-MM-dd'); // set format date
    print(widget.searchData.getEffectiveDate()!); // check that what date data is available 
    final formattedDate = dateFormatter.format(widget.searchData.getEffectiveDate()!); // change format date
    final maxFlights = 50; // Set the maximum number of flight results to display .now recommend 2 is maximun if set maximum more than it can search it gonna bug it list

    // 1. Search for outbound flights
    final outboundResponse = await http.get(
      Uri.parse(
        '$baseUrl?originLocationCode=${widget.searchData.departure}&destinationLocationCode=${widget.searchData.arrival}&departureDate=$formattedDate&adults=${widget.searchData.adultCount}&children=${widget.searchData.kidCount}&infants=${widget.searchData.babyCount}&travelClass=$flightClass',
      ),
      headers: {
        'Authorization': 'Bearer ${accessToken.accessToken}',
      },
    );

    // 2. Search for return flights
    final returnDate = dateFormatter.format(widget.searchData.getEffectiveDateReturn()!);
    final returnResponse = await http.get(
      Uri.parse(
        '$baseUrl?originLocationCode=${widget.searchData.arrival}&destinationLocationCode=${widget.searchData.departure}&departureDate=$returnDate&adults=${widget.searchData.adultCount}&children=${widget.searchData.kidCount}&infants=${widget.searchData.babyCount}&travelClass=$flightClass',
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
      List<dynamic> outboundFlightData = outboundData['data'];
      Map<String , dynamic> returnData = json.decode(returnResponse.body);
      List<dynamic> returnFlightData = returnData['data'];

      int numOutboundResults = outboundFlightData.length;
      int numReturnResults = returnFlightData.length;


      print("out flight: ${numOutboundResults}");

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
      List<Flight> returnResults = returnFlightData.map((flight) => Flight.fromJson(flight)).toList(); // change jason to list
      print("check");
      // print("out flight: ${outboundResults}");
      // print("in flight: ${returnResults}");

      // Combine outbound and return results into a single list
      List<Flight> resultsOut = [];
      resultsOut.addAll(outboundResults);
      // print("result list: ${results}");
      

      // if the bug that one way trip show flight back trip by if one way trip not adding flight back trip in list
      List<Flight> resultsIn = [];
      if (widget.searchData.selectedDate == null){
        resultsIn.addAll(returnResults);
      }
      

      setState(() {
        print("set state");
        _searchResults = resultsOut;
        _searchResultsReturn = resultsIn;
        _isLoading = false; // Set loading to false after processing the API response
        print("set state2");
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
                    List<dynamic> segments = flight.itineraries[0]['segments'];
                    if (segments.length == 1) {
                      // Only one segment
                      String carrierCode = segments[0]['carrierCode'];
                      String flightNumber = segments[0]['number'];
                      String duration = segments[0]['duration'];
                      String departureIataCode = segments[0]['departure']['iataCode'];
                      String arrivalIataCode = segments[0]['arrival']['iataCode'];
                      String departureTime = segments[0]['departure']['at'];
                      String arrivalTime = segments[0]['arrival']['at'];

                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$carrierCode$flightNumber: $departureIataCode - $arrivalIataCode'),
                          Text('Departure Time: $departureTime - Arrival Time: $arrivalTime'),
                          Text('Duration: $duration'),
                          Divider()
                        ],
                      ),
                      trailing: Text('\$${flight.price['total']}'),
                      onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Flight Details'),
                              content: Text(json.encode(flight.toJson())),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    SelectedFlights.addSelectedFlight(flight);
                                    if(widget.searchData.selectedRange.last != null){
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReturnFlightSelection(
                                          outboundFlight: flight, 
                                          returnFlights: _searchResultsReturn)
                                        ),
                                    );
                                    }
                                    else{
                                    Navigator.push(
                                      context,
                                       MaterialPageRoute(
                                        builder: (context) => FlightSummary(flight: flight)
                                        ),
                                      );
                                    }
                                  },
                                   child: Text('Select Flight')),
                                   TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                    );
                    } else if (segments.length > 1) {
                      // Multiple segments
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: segments.map((segment) {
                            String carrierCode = segment['carrierCode'];
                            String flightNumber = segment['number'];
                            String duration = segment['duration'];
                            String departureIataCode = segment['departure']['iataCode'];
                            String arrivalIataCode = segment['arrival']['iataCode'];
                            String departureTime = segment['departure']['at'];
                            String arrivalTime = segment['arrival']['at'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$carrierCode$flightNumber: $departureIataCode - $arrivalIataCode'),
                              Text('Departure Time: $departureTime - Arrival Time: $arrivalTime'),
                              Text('Duration: $duration'),
                            ],
                          );
                          }).toList(),
                        ),
                        trailing: Text('\$${flight.price['total']}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Flight Details'),
                              content: Text(json.encode(flight.toJson())),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    SelectedFlights.addSelectedFlight(flight);
                                    if(widget.searchData.selectedRange.last != null){
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReturnFlightSelection(
                                          outboundFlight: flight, 
                                          returnFlights: _searchResultsReturn)
                                        ),
                                    );
                                    }
                                    else{
                                    Navigator.push(
                                      context,
                                       MaterialPageRoute(
                                        builder: (context) => FlightSummary(flight: flight)
                                        ),
                                      );
                                    }
                                  },
                                   child: Text('Select Flight')),
                                   TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      // No segments, handle this case as needed
                      return ListTile(
                        title: Text('No segments found'),
                        trailing: Text('\$${flight.price['total']}'),
                      );
                    }
              },
              )
                  
                
              : Center(
                  child: Text('Sorry, no flights found.'), // show error massage if cant find the flight
                ),
    );
  }
}

