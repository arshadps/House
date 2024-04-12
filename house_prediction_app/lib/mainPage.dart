import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HousePricePredictionApp extends StatefulWidget {
  @override
  _HousePricePredictionAppState createState() =>
      _HousePricePredictionAppState();
}

class _HousePricePredictionAppState extends State<HousePricePredictionApp> {
  TextEditingController sizeController = TextEditingController();
  TextEditingController bedroomsController = TextEditingController();
  TextEditingController bathroomsController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  late double? predictedPrice; // Mark as late and nullable

  @override
  void initState() {
    super.initState();
    predictedPrice = null; // Initialize in initState
  }

  Future<void> predictPrice() async {
    String url = 'http://127.0.0.1/predict';
    Map<String, dynamic> requestBody = {
      'size': sizeController.text,
      'bedrooms': bedroomsController.text,
      'bathrooms': bathroomsController.text,
      'location': locationController.text,
    };
    print(json.encode(requestBody));

    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json', // Set Content-Type header
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        // Successful response
        print("hi");
        var jsonData = json.decode(response.body);
        print(jsonData);
        predictedPrice = jsonData['predicted_price'];
        // Handle predicted price...
      } else {
        // Error handling
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Exception handling
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House Price Prediction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: sizeController,
                decoration: InputDecoration(labelText: 'Size'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bedroomsController,
                decoration: InputDecoration(labelText: 'Bedrooms'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bathroomsController,
                decoration: InputDecoration(labelText: 'Bathrooms'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  predictPrice();
                },
                child: Text('Predict Price'),
              ),
              SizedBox(height: 20.0),
              predictedPrice != null
                  ? Text(
                      'Predicted Price: \$${predictedPrice!.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18.0),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'House Price Prediction App',
    home: HousePricePredictionApp(),
  ));
}
