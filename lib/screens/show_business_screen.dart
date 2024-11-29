import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pac_novale/screens/create_business_screen.dart';
import 'package:pac_novale/widgets/company_card.dart';
import 'package:pac_novale/screens/company_details_screen.dart';

class ShowBusinessScreen extends StatefulWidget {
  const ShowBusinessScreen({super.key});

  @override
  ShowBusinessScreenState createState() => ShowBusinessScreenState();
}

class ShowBusinessScreenState extends State<ShowBusinessScreen> {
  List<Map<String, dynamic>> companies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://pac-novale-api.onrender.com/get_companies');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> fetchedCompanies = json.decode(response.body);
      setState(() {
        companies = List<Map<String, dynamic>>.from(fetchedCompanies);
        isLoading = false;
      });
    } else {
      print('Failed to fetch companies: ${response.body}');
      setState(() {
        isLoading = false;
      });
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
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/novale_hub_logo.jpeg',
                    height: 150,
                  ),
                  const SizedBox(height: 100),
                  if (!isLoading && companies.isEmpty)
                    const Text(
                      'Você não possui nenhuma \nempresa cadastrada.',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (!isLoading && companies.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: companies.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> company = companies[index];
                          Color color = colors[index % colors.length];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyDetailsScreen(
                                    companyId: company['id'],
                                    companyName: company['Name'] ??
                                        'Nome não disponível',
                                    companyDetails: company,
                                  ),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  fetchCompanies();
                                }
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: CompanyCard(
                                companyName:
                                    company['Name'] ?? 'Nome não disponível',
                                companyCNPJ:
                                    company['CNPJ'] ?? 'CNPJ não disponível',
                                color: color,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateBusinessScreen()),
                        ).then((value) {
                          if (value == true) {
                            fetchCompanies();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: companies.isEmpty
                            ? const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20)
                            : const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: companies.isEmpty
                          ? const Text(
                              'CADASTRAR EMPRESA',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
