import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AccessToken {
  final String tokenType;
  final String accessToken;
  final int expiresIn;

  AccessToken({
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      tokenType: json['token_type'],
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
    );
  }
}

class Flight {
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
      flightNumber: json['id'],
      departure: json['itineraries'][0]['segments'][0]['departure']['iataCode'],
      arrival: json['itineraries'][0]['segments'][1]['arrival']['iataCode'],
      departureTime: json['itineraries'][0]['segments'][0]['departure']['at'],
      arrivalTime: json['itineraries'][0]['segments'][1]['arrival']['at'],
      airline: json['itineraries'][0]['segments'][0]['carrierCode'],
      classType: json['travelerPricings'][0]['fareDetailsBySegment'][0]['cabin'],
      price: double.parse(json['price']['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flightNumber': flightNumber,
      'departure': departure,
      'arrival': arrival,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'airline': airline,
      'classType': classType,
      'price': price,
    };
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
    _getAccessToken(); // Get the access token first
  }

  Future<void> _getAccessToken() async {
    try {
      final tokenUrl = 'https://test.api.amadeus.com/v1/security/oauth2/token';
      final clientId = 'PBjFEhvGHXAzDb6blW0BRCcORKTiZKMj';
      final clientSecret = '4Pf1CUcDoTBgL5DB';
      final response = await http.post(
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

      if (response.statusCode == 200) {
        AccessToken accessToken = AccessToken.fromJson(json.decode(response.body));
        _searchFlights(accessToken);
      } else {
        throw Exception('Failed to retrieve access token');
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      print('Error: $e');
    }
  }

  Future<void> _searchFlights(AccessToken accessToken) async {
    try {
      // Implement the flight search API call using the accessToken and the searchData
      final baseUrl = 'https://test.api.amadeus.com/v2/shopping/flight-offers';
      final dateFormatter = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormatter.format(widget.searchData.selectedDate!);
      final maxFlights = 3; // Set the maximum number of flight results to display

      final response = await http.get(
        Uri.parse(
          '$baseUrl?originLocationCode=${widget.searchData.departure}&destinationLocationCode=${widget.searchData.arrival}&departureDate=$formattedDate&adults=${widget.searchData.adultCount}&max=$maxFlights',
        ),
        headers: {
          'Authorization': 'Bearer ${accessToken.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response and create a list of Flight objects
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> flightData = data['data'];
        int numResults = flightData.length;
        if (numResults > maxFlights) {
          flightData = flightData.sublist(0, maxFlights); // Take only the first 'max' flight results
        }
        List<Flight> results = flightData.map((flight) => Flight.fromJson(flight)).toList();
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
                  onTap: () {
                    showDialog(
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
              child: CircularProgressIndicator(),
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
