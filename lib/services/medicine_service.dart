import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicineService {
  // Replace with your actual backend API endpoint
  static const String _baseUrl = 'https://api.example.com/medicines';

  Future<Map<String, dynamic>?> fetchMedicineInfo(String name) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl?name=[1m$name[0m'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
