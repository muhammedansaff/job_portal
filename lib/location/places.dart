import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GooglePlacesApiScreen extends StatefulWidget {
  const GooglePlacesApiScreen({super.key});

  @override
  State<GooglePlacesApiScreen> createState() => _GooglePlacesApiScreenState();
}

class _GooglePlacesApiScreenState extends State<GooglePlacesApiScreen> {
  TextEditingController _controllerr = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = "1234";
  List<dynamic>? _placesList;

  @override
  void initState() {
    super.initState();
    _controllerr.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggesion(_controllerr.text);
  }

  void getSuggesion(String input) async {
    String kPLACES_API_KEY = "AIzaSyBqSb8s2aRdPsLvdot3s_Ws5DFZw7HkHc4";
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['prediction'];
      });
    } else {
      throw Exception("failes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("google search api"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            TextFormField(
              controller: _controllerr,
              decoration: const InputDecoration(hintText: "search places"),
            )
          ],
        ),
      ),
    );
  }
}
