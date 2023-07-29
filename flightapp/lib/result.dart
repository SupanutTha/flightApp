// result.dart

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Flight {
  // Define the Flight model class based on the response from the API
  final String flightNumber;
  final String departure;
  final String arrival;
  final String departureTime;
  final String arrivalTime;
  final String airline;
  final String classType;
  final double price;

  Flight({
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.airline,
    required this.classType,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNumber: json['flightNumber'],
      departure: json['departure'],
      arrival: json['arrival'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      airline: json['airline'],
      classType: json['classType'],
      price: json['price'].toDouble(),
    );
  }
}

class FlightSearchData {
  final String departure;
  final String arrival;
  final String adultCount;
  final String kidCount;
  final String babyCount;
  final DateTime? selectedDate;
  final List<DateTime?> selectedRange;
  final bool isEconomicClass;
  final bool isPremiumEconomicClass;
  final bool isBusinessClass;
  final bool isFirstClass;

  FlightSearchData({
    required this.departure,
    required this.arrival,
    required this.adultCount,
    required this.kidCount,
    required this.babyCount,
    required this.selectedDate,
    required this.selectedRange,
    required this.isEconomicClass,
    required this.isPremiumEconomicClass,
    required this.isBusinessClass,
    required this.isFirstClass,
  });
}

class ResultPage extends StatefulWidget {
  final FlightSearchData searchData;

  ResultPage({required this.searchData});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Flight> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Call the API and search for flights using the searchData from widget.searchData
    _searchFlights();
  }

  Future<void> _searchFlights() async {
  try {
    // Implement the API call here using the searchData and the baseUrl
    final baseUrl = 'http://test.api.amadeus.com/v2';
    final response = await http.get(Uri.parse('$baseUrl/flights?departure=${widget.searchData.departure}&arrival=${widget.searchData.arrival}&date=${widget.searchData.selectedDate}'));

    if (response.statusCode == 200) {
      // Parse the response and create a list of Flight objects
      List<dynamic> data = json.decode(response.body);
      List<Flight> results = data.map((flightData) => Flight.fromJson(flightData)).toList();
      setState(() {
        _searchResults = results;
      });
    } else {
      throw Exception('Failed to load flights');
    }
  } catch (e) {
    // Handle any errors that occur during the API call
    print('Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flight Search Results"),
      ),
      body: _searchResults.isNotEmpty
          ? ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Flight flight = _searchResults[index];
                // Display flight information here using the Flight model properties
                // For example:
                return ListTile(
                  title: Text('${flight.airline} - Flight ${flight.flightNumber}'),
                  subtitle: Text('Departure: ${flight.departureTime}, Arrival: ${flight.arrivalTime}'),
                  trailing: Text('\$${flight.price}'),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
