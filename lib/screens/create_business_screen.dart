import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pac_novale/screens/show_business_screen.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  CreateBusinessScreenState createState() => CreateBusinessScreenState();
}

class CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessCNPJController = TextEditingController();
  final TextEditingController _businessMarketController =
      TextEditingController();
  final TextEditingController _businessInovationController =
      TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _exitDateController = TextEditingController();

  String selectedTypeValue = "Nenhuma";
  final List<String> types = ["Incubada", "Âncora", "Coworking"];

  String selectedStatusValue = "Nenhuma";
  final List<String> status = ['Ideação', 'Operação', 'Tração', 'Scale-Up'];

  DateTime? _selectedEntryDate;
  DateTime? _selectedExitDate;

  String? selectedValue = 'Empresa Incubada';
  bool isLoading = false;

  Future<void> _selectEntryDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedEntryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedEntryDate) {
      setState(() {
        _selectedEntryDate = picked;
        _entryDateController.text = DateFormat('MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectExitDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedExitDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedExitDate) {
      setState(() {
        _selectedExitDate = picked;
        _exitDateController.text = DateFormat('MM/yyyy').format(picked);
      });
    }
  }

  String _formatDateForFirestore(DateTime? date) {
    if (date == null) return '';
    final DateFormat formatter = DateFormat('yyyy-MM');
    return formatter.format(date);
  }

  Future<void> _createCompany() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url =
        Uri.parse('https://pac-novale-api.onrender.com/create_companies');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Name': _businessNameController.text,
          'CNPJ': _businessCNPJController.text,
          'Market': _businessMarketController.text,
          'Inovation': _businessInovationController.text,
          'Status': selectedStatusValue,
          'EntryDate': _formatDateForFirestore(_selectedEntryDate),
          'ExitDate': _formatDateForFirestore(_selectedExitDate),
          'Type': selectedTypeValue,
          'Activate': true,
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
    } finally {
      setState(() {
        isLoading = false;
      });
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

  Widget buildDropdownCard(
    BuildContext context,
    String title,
    String selectedValue,
    List<String> options,
    Function(String) onOptionSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        final String? chosenOption = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: options
                    .map((option) => ListTile(
                          title: Text(option),
                          onTap: () => Navigator.pop(context, option),
                        ))
                    .toList(),
              ),
            );
          },
        );

        if (chosenOption != null) {
          onOptionSelected(chosenOption);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '$title: $selectedValue',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: Form(
                  key: _formKey,
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
                      TextFormField(
                        controller: _businessNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome da Empresa',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome da empresa';
                          }
                          return null;
                        },
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
                            child: TextFormField(
                              controller: _businessCNPJController,
                              decoration: const InputDecoration(
                                labelText: 'CNPJ da Empresa',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira o CNPJ da empresa';
                                }
                                return null;
                              },
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
                            child: TextFormField(
                              controller: _businessMarketController,
                              decoration: const InputDecoration(
                                labelText: 'Negócio da Empresa',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira o negócio da empresa';
                                }
                                return null;
                              },
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
                            child: TextFormField(
                              controller: _businessInovationController,
                              decoration: const InputDecoration(
                                labelText: 'Inovação da Empresa',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira a inovação da empresa';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildDropdownCard(
                        context,
                        "Tipo de Empresa",
                        selectedTypeValue,
                        types,
                        (String newValue) {
                          setState(() {
                            selectedTypeValue = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      buildDropdownCard(
                        context,
                        "Estágio da Empresa",
                        selectedStatusValue,
                        status,
                        (String newValue) {
                          setState(() {
                            selectedStatusValue = newValue;
                          });
                        },
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
                            child: GestureDetector(
                              onTap: () => _selectEntryDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _entryDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Data de Entrada',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, selecione a data de entrada';
                                    }
                                    return null;
                                  },
                                ),
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
                            child: GestureDetector(
                              onTap: () => _selectExitDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _exitDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Data de Saída',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, selecione a data de saída';
                                    }
                                    return null;
                                  },
                                ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
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
