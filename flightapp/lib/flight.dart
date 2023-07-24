// flight.dart

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
