// flight_search_data.dart

class FlightSearchData {
  final String departure;
  final String arrival;
  final DateTime? selectedDate;
  final List<DateTime?> selectedRange;
  final bool isEconomicClass;
  final bool isPremiumEconomicClass;
  final bool isBusinessClass;
  final bool isFirstClass;

  FlightSearchData({
    required this.departure,
    required this.arrival,
    required this.selectedDate,
    required this.selectedRange,
    required this.isEconomicClass,
    required this.isPremiumEconomicClass,
    required this.isBusinessClass,
    required this.isFirstClass,
  });
}
