import 'package:flutter/material.dart';
import 'package:pac_novale/screens/create_business_screen.dart';
import 'package:pac_novale/widgets/company_card.dart'; // Importe o CompanyCard
import 'package:pac_novale/services/company_service.dart'; // Importe o serviço que faz as requisições HTTP

class ShowBusinessScreen extends StatefulWidget {
  const ShowBusinessScreen({super.key});

  @override
  ShowBusinessScreenState createState() => ShowBusinessScreenState();
}

class ShowBusinessScreenState extends State<ShowBusinessScreen> {
  List<Map<String, dynamic>> companies = [];
  final CompanyService companyService = CompanyService(); // Serviço para fazer requisições

  @override
  void initState() {
    super.initState();
    fetchCompanies(); // Busca as empresas do backend
  }

  // Função para buscar as empresas do backend
  Future<void> fetchCompanies() async {
    try {
      final List<Map<String, dynamic>> fetchedCompanies = await companyService.fetchCompanies();
      setState(() {
        companies = fetchedCompanies; // Atualiza a lista de empresas com os dados recebidos
      });
    } catch (error) {
      print('Failed to fetch companies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cores para os cartões
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
              
              // Verifica se há empresas. Caso contrário, exibe mensagem
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
              
              // Se houver empresas, exibe os CompanyCards
              if (companies.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: companies.length, // Número de empresas
                    itemBuilder: (context, index) {
                      Map<String, dynamic> company = companies[index]; // Empresa atual
                      Color color = colors[index % colors.length]; // Alterna as cores
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CompanyCard(
                          companyName: company['name'] ?? 'Nome não disponível', // Nome da empresa
                          companyCNPJ: company['cnpj'] ?? 'CNPJ não disponível', // CNPJ da empresa
                          color: color, // Cor para o cartão
                        ),
                      );
                    },
                  ),
                ),
              
              const SizedBox(height: 50),
              
              // Botão para cadastrar nova empresa
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateBusinessScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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