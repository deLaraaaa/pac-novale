import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:pac_novale/screens/business_info/customer_loss_info_screen.dart';
import 'package:pac_novale/screens/business_info/income_info_screen.dart';
import 'package:pac_novale/screens/business_info/outcome_info_screen.dart';
import 'package:pac_novale/screens/business_info/employee_info_screen.dart';
import 'package:pac_novale/screens/business_info/market_gain_info_screen.dart';
import 'business_info/engagement_info_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String companyId;
  final String companyName;
  final Map<String, dynamic> companyDetails;

  const CompanyDetailsScreen({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.companyDetails,
  });

  @override
  CompanyDetailsScreenState createState() => CompanyDetailsScreenState();
}

class CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  bool isDeleting = false;
  final Color buttonColor = Color(0xff00bfa5);

  final Map<String, String> fieldMapping = {
    'CNPJ': 'CNPJ',
    'Negócio': 'Market',
    'Inovação': 'Inovation',
    'Estágio': 'Status',
    'Entrada': 'EntryDate',
    'Saída': 'ExitDate',
    'Tipo': 'Type',
  };

  Future<void> deleteCompany() async {
    setState(() {
      isDeleting = true;
    });

    final url = Uri.parse('http://localhost:3000/delete_company');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': widget.companyId}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      setState(() {
        isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete company: ${response.body}')),
      );
    }
  }

  Future<void> updateCompany(String field, String value) async {
    final url = Uri.parse('http://localhost:3000/update_company');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': widget.companyId,
        'field': fieldMapping[field],
        'value': value,
      }),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update company: ${response.body}')),
      );
    }
  }

  void openEditDialog(String title, String content) async {
    if (title == 'Entrada' || title == 'Saída') {
      DateTime initialDate = DateTime.now();
      if (content.isNotEmpty) {
        final parts = content.split('/');
        if (parts.length == 2) {
          final month = int.tryParse(parts[0]);
          final year = int.tryParse(parts[1]);
          if (month != null && year != null) {
            initialDate = DateTime(year, month);
          }
        }
      }

      final DateTime? picked = await showMonthYearPicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null) {
        final formattedDate = DateFormat('yyyy-MM').format(picked);
        await updateCompany(title, formattedDate);
        setState(() {
          widget.companyDetails[fieldMapping[title] ?? title] = formattedDate;
        });
      }
    } else {
      TextEditingController controller = TextEditingController(text: content);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(color: Colors.grey, height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Editar $title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  InkWell(
                    onTap: () async {
                      await updateCompany(title, controller.text);
                      setState(() {
                        widget.companyDetails[fieldMapping[title] ?? title] =
                            controller.text;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0),
                        ),
                      ),
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateFormat('yyyy-MM').parse(date);
      return DateFormat('MM/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  Widget buildTextCard(String title, String content) {
    if (title == 'Entrada' || title == 'Saída') {
      content = formatDate(content);
    }

    return GestureDetector(
      onLongPress: () => openEditDialog(title, content),
      child: SizedBox(
        width: double.infinity, // Faz o card ocupar a largura total
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          color: const Color.fromARGB(255, 241, 241, 241),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$title: $content',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        maximumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyDetails = widget.companyDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: isDeleting ? null : deleteCompany,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ListView(
              children: [
                buildTextCard(
                    'CNPJ', companyDetails['CNPJ'] ?? 'Não disponível'),
                buildTextCard(
                    'Negócio', companyDetails['Market'] ?? 'Não disponível'),
                buildTextCard('Inovação',
                    companyDetails['Inovation'] ?? 'Não disponível'),
                buildTextCard(
                    'Estágio', companyDetails['Status'] ?? 'Não disponível'),
                buildTextCard(
                    'Entrada', companyDetails['EntryDate'] ?? 'Não disponível'),
                buildTextCard(
                    'Saída', companyDetails['ExitDate'] ?? 'Não disponível'),
                buildTextCard(
                    'Tipo', companyDetails['Type'] ?? 'Não disponível'),
                const Divider(
                  height: 40,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildGridButton(
                        "Engajamento",
                        () {
                          // Navegar para a tela EngagementInfoScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EngagementInfoScreen()),
                          );
                        },
                      ),
                      buildGridButton(
                        "Ganho de Mercado",
                        () {
                          // Navegar para a tela EngagementInfoScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketGainInfoScreen(
                                  companyId: widget.companyId),
                            ),
                          );
                        },
                      ),
                      buildGridButton(
                        "Funcionários",
                        () {
                          // Navegar para a tela EngagementInfoScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeInfoScreen()),
                          );
                        },
                      ),
                      buildGridButton(
                        "Custos",
                        () {
                          // Navegar para a tela EngagementInfoScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OutcomeInfoScreen()),
                          );
                        },
                      ),
                      buildGridButton(
                        "Faturamentos",
                        () {
                          // Navegar para a tela EngagementInfoScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IncomeInfoScreen()),
                          );
                        },
                      ),
                      buildGridButton(
                        "Motivos de P/C",
                        () {
                          // Navegar para a tela EngagementInfoScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerLossInfoScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isDeleting)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (isDeleting)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
