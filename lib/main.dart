import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flightapp/screens/homepage.dart'; // Import the HomePage class
import 'database/database_helper.dart';


void main()  async{
  // Initialize the databaseFactory for the sqflite_common_ffi backend
  // Initialize the sqflite_common_ffi backend
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance; // Create an instance of DatabaseHelper

  // // Initialize the database
  // try {
  //   await DatabaseHelper.instance.airlinesDatabase;
  //   print("Database initialized successfully");
  // } catch (e) {
  //   print("Error initializing database: $e");
  // }

  // try{
  //   await DatabaseHelper.instance.airportsDatabase;
  //  print("Database initialized successfully");
  // } catch (e) {
  //   print("Error initializing database: $e");
  // }
  
  // // add data in database
  // final jsonString = await dbHelper.loadAsset('assets/airports_data.json');
  // final jsonData = json.decode(jsonString);
  //  try{
  //   await dbHelper.insertAirportJsonToDatabase(jsonData);
  //   print("insert data successfully");
  //  }
  //  catch(e){
  //   print("Erorr to insert data: ${e}");
  //  }
  //  print("check after insert");

  // final jsonString2 = await dbHelper.loadAsset('assets/airlines_data.json');
  // final jsonData2 = json.decode(jsonString2);

  // try {
  //   await dbHelper.insertAirlinesJsonToDatabase(jsonData2);
  //   print("Insert data successfully");
  // } catch (e) {
  //   print("Error inserting data: $e");
  // }

  
  final airports = await dbHelper.retrieveAirports();
  print("airprt : ${airports}");
  airports.forEach((airport) {
    print(airport.name);
  });

  // final airlines = await dbHelper.retrieveAirlines();
  // airlines.forEach((airline){
  //   print(airline.name);
  // }) ;



  runApp(
    MaterialApp(
      home: HomePage(), // Set HomePage as the home route
    ),
  );
}

