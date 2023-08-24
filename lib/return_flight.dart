import 'dart:convert';

import 'package:flightapp/selected_flights.dart';
import 'package:flutter/material.dart';
import 'package:flightapp/flight.dart';

import 'flight_summary.dart';

class ReturnFlightSelection extends StatelessWidget {
  final Flight outboundFlight;
  final List<Flight> returnFlights;

  ReturnFlightSelection({
    required this.outboundFlight,
    required this.returnFlights,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SelectedFlights.removeSelectedFlight(SelectedFlights.selectedFlights[SelectedFlights.selectedFlights.length-1]); // Clear selected flights when user clicks back button
        return true;
      },
    child:  Scaffold(
      appBar: AppBar(
        title: Text('Return Flight Selection'),
      ),
      body: ListView.builder(
        itemCount: returnFlights.length,
        itemBuilder: (context, index) {
          Flight returnFlight = returnFlights[index];
          List<dynamic> segments = returnFlight.itineraries[0]['segments'];
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
              trailing: Text('\$${returnFlight.price['total']}'),
              onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Flight Details'),
                              content: Text(json.encode(returnFlight.toJson())),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    SelectedFlights.addSelectedFlight(returnFlight);
                                    Navigator.push(
                                      context,
                                       MaterialPageRoute(
                                        builder: (context) => FlightSummary(flight: returnFlight)
                                        ),
                                      );
                                    
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
                        trailing: Text('\$${returnFlight.price['total']}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Flight Details'),
                              content: Text(json.encode(returnFlight.toJson())),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    SelectedFlights.addSelectedFlight(returnFlight);
                                    Navigator.push(
                                      context,
                                       MaterialPageRoute(
                                        builder: (context) => FlightSummary(flight: returnFlight)
                                        ),
                                      );
                                    
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
          }
          
        },
      ),
    )
    );
  }
}
