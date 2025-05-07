import 'dart:convert';
import 'package:http/http.dart' as http;


//Ce fichier gère les appels aux API REST pour récupérer les données des flux CCTV et des alertes depuis le backend.​



class ApiService {
  //final String baseUrl = "http://127.0.0.1:5000";  // Use Local Backend
  // final String baseUrl = "https://ImanHajj.pythonanywhere.com";
final String baseUrl = "http://192.168.229.133:8000";

  
  Future<List<dynamic>> fetchAlerts() async {
  final response = await http.get(Uri.parse("$baseUrl/alerts"));
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data ?? [];  // ✅ Prevents `null` from causing errors
  } else {
    throw Exception("Failed to load alerts");
  }
}


  Future<List<dynamic>> fetchCCTVFeeds() async {
    final response = await http.get(Uri.parse("$baseUrl/cctv"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load CCTV feeds");
    }
  }
}
