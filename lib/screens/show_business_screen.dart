import 'package:flutter/material.dart';
import 'package:pac_novale/screens/create_business_screen.dart';
import 'package:pac_novale/widgets/company_card.dart'; // Importe o CompanyCard

class ShowBusinessScreen extends StatelessWidget {
  const ShowBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of companies
    final List<Map<String, String>> companies = [
      {'name': 'Empresa Exemplo 1', 'cnpj': '00.000.000/0000-00'},
      {'name': 'Empresa Exemplo 2', 'cnpj': '00.000.000/0000-00'},
      {'name': 'Empresa Exemplo 3', 'cnpj': '00.000.000/0000-00'},
      // Add more companies here
    ];

    // Define the colors to cycle through
    final List<Color> colors = [
      Color(0xFFE94562),
      Color(0xFF382D62),
      Color(0xFF0090C8),
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
                    fontFamily: 'Roboto'
                  ),
                  textAlign: TextAlign.center,
                ),
              if (companies.isNotEmpty)
                ...companies.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String> company = entry.value;
                  Color color = colors[index % colors.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CompanyCard(
                      companyName: company['name']!,
                      companyCNPJ: company['cnpj']!,
                      color: color, // Pass the color to the CompanyCard
                    ),
                  );
                }).toList(),
              const SizedBox(height: 50),
              if (companies.isEmpty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateBusinessScreen())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text(
                    'CADASTRAR EMPRESA',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Colors.white
                    ),
                  ),
                ),
              if (companies.isNotEmpty)
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateBusinessScreen())
                    );
                  },
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.add),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
