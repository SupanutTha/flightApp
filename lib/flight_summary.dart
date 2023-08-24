import 'package:flightapp/selected_flights.dart';
import 'package:flutter/material.dart';
import 'flight.dart'; // Import your Flight class

class FlightSummary extends StatelessWidget {
  final Flight flight;

  FlightSummary({required this.flight});

  @override
  Widget build(BuildContext context) {
        return WillPopScope(
      onWillPop: () async {
        SelectedFlights.removeSelectedFlight(SelectedFlights.selectedFlights[SelectedFlights.selectedFlights.length-1]); // Clear selected flights when user clicks back button
        return true;
      },
    child: Scaffold(
      appBar: AppBar(
        title: Text('Flight summary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text('${SelectedFlights.selectedFlights}')
            // Text('Carrier: ${flight}'),
            // Text('Flight Number: ${flight}'),
            // Add more flight details here...
          ],
        ),
      ),
    )
    );
  }
}
