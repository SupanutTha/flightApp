import 'package:flightapp/models/selected_flights.dart';
import 'package:flutter/material.dart';
import '../models/flight.dart'; // Import your Flight class

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
      body: ListView.builder(
        itemCount: SelectedFlights.selectedFlights.length,
        itemBuilder: (context, index) {
          Flight SelectedFlight = SelectedFlights.selectedFlights[index];
          List<dynamic> segments = SelectedFlight.itineraries[0]['segments'];
          if (segments.length ==1 ){
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
              trailing: Text('\$${SelectedFlight.price['total']}'),
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
                        trailing: Text('\$${SelectedFlight.price['total']}'),
                        
                      );
          }
          
        },
      ),
    
    )
    );
  }
}
