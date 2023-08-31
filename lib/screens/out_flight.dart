

// ignore_for_file: prefer_final_fields

import 'package:flightapp/screens/flight_summary.dart';
import 'package:flightapp/screens/return_flight.dart';
import 'package:flightapp/models/selected_flights.dart';
import 'package:flightapp/widgets/sort_flight_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import '../services/accessToken.dart';
import '../models/flight.dart';
import '../models/flight_search_data.dart';
import 'package:flightapp/services/api_service.dart';




class ResultPage extends StatefulWidget {
  final FlightSearchData searchData; // retrive data form flight_search_data

  ResultPage({required this.searchData});

  @override
  _ResultPageState createState() => _ResultPageState();
  
 
}


class _ResultPageState extends State<ResultPage> {
  // Future<(List<Flight>, List<Flight>)> _searchResults = ApiService.searchFlights(widget.searchData); // collect all flight that can search in the list
  List<Flight> _searchResults = [];
  List<Flight> _searchResultsReturn = [];
  bool _isLoading = true; // to check that can access token
  String _sortingOption = 'Default'; // Default sorting option
  bool _sortAscending = true; // Default sorting order

  
  @override
  void initState() {
    super.initState();
    _fetchFlightResults();
  }
  void _sortResults(String option, List<Flight> sortedResults) {
    setState(() {
      _sortingOption = option;
      _searchResults = sortedResults;
    });
  }

  Future<void> _fetchFlightResults() async {
    try {
      var searchTuple = await ApiService.searchFlights(widget.searchData);
      _searchResults = searchTuple.$1;
      _searchResultsReturn = searchTuple.$2;
      print('1 $_searchResults');
      print('2 $_searchResultsReturn');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar( // header
        title: Text("Flight Search Results"),
        actions: [
          // Add the SortingWidget to the AppBar
          SortingWidget(
            sortingOptions: ['Default', 'Fastest', 'Cheapest', 'Direct'],
            selectedOption: _sortingOption,
            onSortOptionSelected: _sortResults,
            searchResults: _searchResults,
            ),
        ],
        
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

