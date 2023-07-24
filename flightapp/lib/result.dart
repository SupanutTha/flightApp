import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final String departure;
  final String arrival;
  final String adultCount;
  final String kidCount;
  final String babyCount;
  final bool isEconomicClass;
  final bool isPremiumEconomicClass;
  final bool isBusinessClass;
  final bool isFirstClass;
  final DateTime? selectedDate;
  final List<DateTime?> selectedRange;

  ResultPage({
    required this.departure,
    required this.arrival,
    required this.adultCount,
    required this.kidCount,
    required this.babyCount,
    required this.isEconomicClass,
    required this.isPremiumEconomicClass,
    required this.isBusinessClass,
    required this.isFirstClass,
    this.selectedDate,
    this.selectedRange = const [null, null],
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Departure: ${widget.departure}'),
            Text('Arrival: ${widget.arrival}'),
            Text('Adult Count: ${widget.adultCount}'),
            Text('Kid Count: ${widget.kidCount}'),
            Text('Baby Count: ${widget.babyCount}'),
            Text('Economic Class: ${widget.isEconomicClass}'),
            Text('Premium Economic Class: ${widget.isPremiumEconomicClass}'),
            Text('Business Class: ${widget.isBusinessClass}'),
            Text('First Class: ${widget.isFirstClass}'),
            if (widget.selectedDate != null)
              Text('Selected Date: ${widget.selectedDate}'),
            if (widget.selectedRange[0] != null && widget.selectedRange[1] != null)
              Text('Selected Range: ${widget.selectedRange[0]} to ${widget.selectedRange[1]}'),
          ],
        ),
      ),
    );
  }
}
