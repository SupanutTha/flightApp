import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/airport_db.dart';

class AirportSearchWidget  {


  Future<List<String>> getMatchingSuggestions(String input) async {
  sqfliteFfiInit();

  final databaseFactory = databaseFactoryFfi;
  final db = await databaseFactory.openDatabase(
    join(await getDatabasesPath(), 'airports.db'),
  );

  final List<Map<String, dynamic>> maps = await db.rawQuery(
    "SELECT * FROM airports WHERE name LIKE '%$input%' OR iata LIKE '%$input%' OR city LIKE '%$input%'",
  );

  await db.close();

  List<Airport> airportObjects = maps.map((map) => Airport.fromMap(map)).toList();

  return airportObjects.map((airport) => airport.name).toList();
}



}
