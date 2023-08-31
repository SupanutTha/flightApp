import 'package:flightapp/models/flight.dart';
import 'package:flutter/material.dart';

class SortingWidget extends StatelessWidget {
  final List<String> sortingOptions;
  final String selectedOption;
  final Function(String, List<Flight>) onSortOptionSelected;
  final List<Flight> searchResults;

  SortingWidget({
    required this.sortingOptions,
    required this.selectedOption,
    required this.onSortOptionSelected,
    required this.searchResults,
  });
    
  static List<Flight> _sortResults(String option , List<Flight> searchResults) {
    
  List<Flight> sortedResults = List.from(searchResults); // Create a copy of searchResults
  if (option == 'Fastest') {
    sortedResults.sort((a, b) => a.itineraries[0]['duration'].compareTo(b.itineraries[0]['duration']));
  } else if (option == 'Cheapest') {
    sortedResults.sort((a, b) => a.price['total'].compareTo(b.price['total']));
  } else if (option == 'Direct') {
    sortedResults.sort((a, b) => a.itineraries[0]['segments'].length.compareTo(b.itineraries[0]['segments'].length));
  }
  return sortedResults;
}

 
  @override
  Widget build(BuildContext context) {
    
    return DropdownButton<String>(
      value: selectedOption,
      onChanged:(option) {
        List<Flight> sortedResults = _sortResults(option!, searchResults);
        onSortOptionSelected(option, sortedResults);
      },
        
      items: sortingOptions.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}
