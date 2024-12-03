import 'dart:convert';
import 'package:http/http.dart' as http;

typedef CompanyData = Map<String, dynamic>;

class CompanyService {
  static const String _baseUrl =
      'https://pac-novale-api.onrender.com/companies';
  static final CompanyService _instance = CompanyService._internal();

  factory CompanyService() {
    return _instance;
  }

  CompanyService._internal();

  Future<List<CompanyData>> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> companiesJson = jsonDecode(response.body);
        return companiesJson.map((company) => company as CompanyData).toList();
      } else {
        throw Exception('Failed to load companies: ${response.reasonPhrase}');
      }
    } catch (err) {
      throw Exception('Failed to load companies: $err');
    }
  }

  Future<void> createCompany(CompanyData companyData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(companyData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create company: ${response.reasonPhrase}');
      }
    } catch (err) {
      throw Exception('Failed to create company: $err');
    }
  }
}
