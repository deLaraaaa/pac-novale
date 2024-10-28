import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${companyDetails['Name'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text('CNPJ: ${companyDetails['CNPJ'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text(
                      'Negócio: ${companyDetails['Market'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text(
                      'Inovação: ${companyDetails['Inovation'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text(
                      'Estágio: ${companyDetails['Status'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text(
                      'Entrada: ${companyDetails['EntryDate'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text(
                      'Saída: ${companyDetails['ExitDate'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Tipo: ${companyDetails['Type'] ?? 'Não disponível'}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
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
