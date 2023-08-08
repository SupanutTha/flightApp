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
  // factory is alternative way to create instance but can use crach and more recommend by commuity
  factory Flight.fromJson(Map<String, dynamic> json) { // map the jason
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

  // create Jason 
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