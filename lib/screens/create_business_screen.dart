import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pac_novale/screens/show_business_screen.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  CreateBusinessScreenState createState() => CreateBusinessScreenState();
}

class CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessCNPJController = TextEditingController();
  final TextEditingController _businessMarketController = TextEditingController();
  final TextEditingController _businessInovationController = TextEditingController();
  final TextEditingController _businessStatusController = TextEditingController();
  final TextEditingController _businessEntryDateController = TextEditingController();
  final TextEditingController _businessExitDateController = TextEditingController();

  String? selectedValue = 'Empresa Incubada';
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _createCompany() async {
    final url = Uri.parse('http://localhost:3000/companies');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _businessNameController.text,
          'cnpj': _businessCNPJController.text,
          'market': _businessMarketController.text,
          'inovation': _businessInovationController.text,
          'status': _businessStatusController.text,
          'entryDate': _businessEntryDateController.text,
          'exitDate': _businessExitDateController.text,
          'type': selectedValue,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShowBusinessScreen()),
        );
      } else {
        _showErrorDialog('Failed to create company: ${response.body}');
      }
    } catch (error) {
      _showErrorDialog('Network error: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastrar Empresa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Insira o nome da empresa:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const Text(
                    'CNPJ:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessCNPJController,
                      decoration: const InputDecoration(
                        labelText: 'CNPJ da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Negócio:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessMarketController,
                      decoration: const InputDecoration(
                        labelText: 'Negócio da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Inovação:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessInovationController,
                      decoration: const InputDecoration(
                        labelText: 'Inovação da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Tipo da Empresa:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.teal,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: <String>['Empresa Incubada', 'Empresa em Tração', 'Empresa Finalizada']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Estágio:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessStatusController,
                      decoration: const InputDecoration(
                        labelText: 'Inovação da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Entrada:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessEntryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Data de Entrada',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Saída:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessExitDateController,
                      decoration: const InputDecoration(
                        labelText: 'Data de Saída',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _createCompany,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'CRIAR EMPRESA',
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