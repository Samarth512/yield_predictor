import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CropPredictionScreen(),
    );
  }
}

class CropPredictionScreen extends StatefulWidget {
  @override
  _CropPredictionScreenState createState() => _CropPredictionScreenState();
}

class _CropPredictionScreenState extends State<CropPredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  final TextEditingController cropTypeController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  final TextEditingController fertilizerController = TextEditingController();
  final TextEditingController pesticideController = TextEditingController();

  String predictionResult = "";

  // List of crop names and their corresponding integers
  final List<Map<String, dynamic>> cropOptions = [
    {'name': 'Wheat', 'value': 1},
    {'name': 'Rice', 'value': 2},
    {'name': 'Maize', 'value': 3},
    {'name': 'Barley', 'value': 4},
    {'name': 'Cotton', 'value': 5},
    {'name': 'Sugarcane', 'value': 6},
    {'name': 'Soybean', 'value': 7},
    {'name': 'Jute', 'value': 8},
    {'name': 'Rapeseed', 'value': 9},
    {'name': 'Mustard', 'value': 10},
    {'name': 'Potato', 'value': 11},
    {'name': 'Onion', 'value': 12},
    {'name': 'Tomato', 'value': 13},
    {'name': 'Green Gram', 'value': 14},
    {'name': 'Black Gram', 'value': 15},
    {'name': 'Peas', 'value': 16},
    {'name': 'Tur', 'value': 17},
    {'name': 'Groundnut', 'value': 18},
    {'name': 'Coriander', 'value': 19},
    {'name': 'Fenugreek', 'value': 20},
  ];

  // List of states and their corresponding integers
  final List<Map<String, dynamic>> stateOptions = [
    {'name': 'Andhra Pradesh', 'value': 1},
    {'name': 'Arunachal Pradesh', 'value': 2},
    {'name': 'Assam', 'value': 3},
    {'name': 'Bihar', 'value': 4},
    {'name': 'Chhattisgarh', 'value': 5},
    {'name': 'Goa', 'value': 6},
    {'name': 'Gujarat', 'value': 7},
    {'name': 'Haryana', 'value': 8},
    {'name': 'Himachal Pradesh', 'value': 9},
    {'name': 'Jharkhand', 'value': 10},
    {'name': 'Karnataka', 'value': 11},
    {'name': 'Kerala', 'value': 12},
    {'name': 'Madhya Pradesh', 'value': 13},
    {'name': 'Maharashtra', 'value': 14},
    {'name': 'Manipur', 'value': 15},
    {'name': 'Meghalaya', 'value': 16},
    {'name': 'Mizoram', 'value': 17},
    {'name': 'Nagaland', 'value': 18},
    {'name': 'Odisha', 'value': 19},
    {'name': 'Punjab', 'value': 20},
    {'name': 'Rajasthan', 'value': 21},
    {'name': 'Sikkim', 'value': 22},
    {'name': 'Tamil Nadu', 'value': 23},
    {'name': 'Telangana', 'value': 24},
    {'name': 'Tripura', 'value': 25},
    {'name': 'Uttar Pradesh', 'value': 26},
    {'name': 'Uttarakhand', 'value': 27},
    {'name': 'West Bengal', 'value': 28},
    {'name': 'Andaman and Nicobar Islands', 'value': 29},
    {'name': 'Chandigarh', 'value': 30},
    {'name': 'Delhi', 'value': 31},
    {'name': 'Jammu and Kashmir', 'value': 32},
    {'name': 'Ladakh', 'value': 33},
    {'name': 'Lakshadweep', 'value': 34},
    {'name': 'Puducherry', 'value': 35},
  ];

  // Method to make prediction request
  Future<void> predictYield() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Prepare data to send to Flask backend
        final Map<String, dynamic> input = {
          'Crop': int.parse(cropTypeController.text),
          'Season': int.parse(seasonController.text),
          'State': int.parse(stateController.text),
          'Area': double.parse(areaController.text),
          'Annual_Rainfall': double.parse(rainfallController.text),
          'Fertilizer': double.parse(fertilizerController.text),
          'Pesticide': double.parse(pesticideController.text),
        };

        // Send the POST request to the Flask API
        final response = await http.post(
          Uri.parse('http://192.168.50.212:5000/predict'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(input),
        );

        // Handle the response
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          setState(() {
            predictionResult = 'Predicted Yield: ${responseData['predicted_yield']}';
          });
          _showPredictionDialog();
        } else {
          setState(() {
            predictionResult = 'Error: ${response.body}';
          });
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  // Method to show dialog with prediction result
  void _showPredictionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediction Result'),
          content: Text(predictionResult),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Yield Prediction'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Dropdown for selecting crop type
                _buildDropdownField(cropTypeController, 'Crop Type', cropOptions),

                // Radio buttons for season
                _buildRadioButtons(seasonController, 'Season', ['Kharif', 'Rabi', 'Whole Year']),

                // Dropdown for selecting state
                _buildDropdownField(stateController, 'State', stateOptions),

                _buildTextField(areaController, 'Area (hectares)', isNumeric: true),
                _buildTextField(rainfallController, 'Annual Rainfall (mm)', isNumeric: true),
                _buildTextField(fertilizerController, 'Fertilizer (kg)', isNumeric: true),
                _buildTextField(pesticideController, 'Pesticide (kg)', isNumeric: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: predictYield,
                  child: Text('Predict Yield'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(TextEditingController controller, String label, List<Map<String, dynamic>> options) {
    return DropdownButtonFormField<int>(
      value: int.tryParse(controller.text),
      decoration: InputDecoration(labelText: label),
      items: options.map((option) {
        return DropdownMenuItem<int>(
          value: option['value'],
          child: Text(option['name']),
        );
      }).toList(),
      onChanged: (value) {
        controller.text = value.toString();
      },
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildRadioButtons(TextEditingController controller, String label, List<String> options) {
    int selectedValue = int.tryParse(controller.text) ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        ...options.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          return RadioListTile<int>(
            title: Text(option),
            value: index,
            groupValue: selectedValue,
            onChanged: (value) {
              controller.text = value.toString();
              setState(() {});  // Trigger update
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }
}
