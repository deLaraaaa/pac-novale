import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pac_novale/screens/create_business_screen.dart';
import 'package:pac_novale/widgets/company_card.dart';

class ShowBusinessScreen extends StatefulWidget {
  const ShowBusinessScreen({super.key});

  @override
  ShowBusinessScreenState createState() => ShowBusinessScreenState();
}

class ShowBusinessScreenState extends State<ShowBusinessScreen> {
  List<Map<String, dynamic>> companies = [];

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    final url = Uri.parse('http://localhost:3000/companies');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> fetchedCompanies = json.decode(response.body);
      setState(() {
        companies = List<Map<String, dynamic>>.from(fetchedCompanies);
      });
    } else {
      print('Failed to fetch companies: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      const Color(0xFFE94562),
      const Color(0xFF382D62),
      const Color(0xFF0090C8),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/novale_hub_logo.jpeg',
                height: 150,
              ),
              const SizedBox(height: 100),
              if (companies.isEmpty)
                const Text(
                  'Você não possui nenhuma \nempresa cadastrada.',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              if (companies.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> company = companies[index];
                      Color color = colors[index % colors.length];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CompanyCard(
                          companyName: company['name'] ?? 'Nome não disponível',
                          companyCNPJ: company['cnpj'] ?? 'CNPJ não disponível',
                          color: color,
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateBusinessScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'CADASTRAR EMPRESA',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
