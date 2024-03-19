import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'API Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? responseString = 'No body yet';
  String? responseHeader = 'No header yet';
  String? responseStatus = 'No status yet';
  String? error = 'No status yet';
  bool isLoading = false;
  String apiUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                key: const Key('apiUrlTextBox'),
                onChanged: (value) {
                  apiUrl = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter api url',
                ),
              ),
              ElevatedButton(
                  key: const Key('submitButton'),
                  onPressed: () async {
                    isLoading = true;
                    setState(() {});
                    FocusScope.of(context).unfocus();
                    try {
                      debugPrint("Starting request");
                      Map<String, String> response = await makeRequest(apiUrl);
                      responseString = response["body"];
                      responseHeader = response["headers"];
                      responseStatus = response["statusCode"];
                      error = response["error"];
                      debugPrint("Response body:$responseString");
                      isLoading = false;
                    } catch (e) {
                      debugPrint("Error when making request: $e");
                      responseStatus = '';
                      responseHeader = '';
                      responseString = '';
                      error = "Error when making request: $e";
                      isLoading = false;
                    }
                    setState(() {});
                  },
                  child: const Text("Make request")),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Error:"),
                        Text(error.toString()),
                        const Text("Status:"),
                        Text(responseStatus.toString()),
                        const Text("Header:"),
                        Text(responseHeader.toString()),
                        const Text("Body:"),
                        Text(responseString.toString())
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, String>> makeRequest(String apiUrl) async {
  try {
    debugPrint("Inside make request");
    http.Response response = await http.get(Uri.parse(apiUrl));
    return {
      "statusCode": response.statusCode.toString(),
      "body": response.body.toString(),
      "headers": response.headers.toString(),
      "error": ""
    };
  } catch (e) {
    debugPrint("MakeRequest Error: $e");
    return {
      "statusCode": "",
      "body": "",
      "headers": "",
      "error": "MakeRequest Error: $e"
    };
  }
}
