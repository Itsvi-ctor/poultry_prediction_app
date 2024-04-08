import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _prediction = '';

  Future<void> _selectAndSendAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://172.20.10.4:5000/predict"),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          _prediction = responseData; // You'll need to parse the JSON response
        });
      } else {
        setState(() {
          _prediction = 'Failed to get prediction';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I am rich"),
        backgroundColor: Colors.blueGrey[700],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectAndSendAudio,
              child: const Text('Select Audio'),
            ),
            const SizedBox(height: 20),
            Text('Prediction: $_prediction'),
          ],
        ),
      ),
    );
  }
}
