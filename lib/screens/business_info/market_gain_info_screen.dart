import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MarketGainInfoScreen extends StatefulWidget {
  @override
  _MarketGainInfoScreenState createState() => _MarketGainInfoScreenState();
}

class _MarketGainInfoScreenState extends State<MarketGainInfoScreen> {
  bool showViewMode = true; // Define o estado inicial como "Exibir Informações"
  bool showAverage = false; // Alterna entre Média e Soma
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? insertDate;

  // Método para selecionar apenas o mês e ano
  Future<void> _selectMonthYear(
      BuildContext context, bool isStart, bool isInsert) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
      locale: const Locale("pt", "BR"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // Adicione o tema, se necessário
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isInsert) {
          insertDate = picked;
        } else {
          if (isStart) {
            selectedStartDate = picked;
          } else {
            selectedEndDate = picked;
          }
        }
      });
    }
  }

  // Informações fictícias para demonstração
  final Map<String, String> info = {
    "NovosClientes": "15",
    "ClientesPerdidos": "8",
    "Prospectados": "5",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ganho de Mercado"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Switch para alternar entre Exibir e Adicionar Informações
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Modo atual: ${showViewMode ? "Somente exibir informações." : "Manipular e editar informações."}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: showViewMode,
                  onChanged: (value) {
                    setState(() {
                      showViewMode = value;
                    });
                  },
                ),
              ],
            ),
          ),
          if (showViewMode)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão para selecionar Data de Entrada
                  Column(
                    children: [
                      Text("Mês e Ano de Entrada:"),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectMonthYear(context, true, false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedStartDate != null
                                ? DateFormat("MM/yyyy")
                                    .format(selectedStartDate!)
                                : "Selecione o mês e ano",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.0),
                  // Botão para selecionar Data de Saída
                  Column(
                    children: [
                      Text("Mês e Ano de Saída:"),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectMonthYear(context, false, false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedEndDate != null
                                ? DateFormat("MM/yyyy").format(selectedEndDate!)
                                : "Selecione o mês e ano",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          // Adicionando o switch de "Média" e "Soma" aqui
          if (showViewMode) _buildCalculationSwitch(),
          // Exibe a tela correspondente com base no estado do switch
          Expanded(
            child:
                showViewMode ? _buildViewInformation() : _buildAddInformation(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 5.0),
      child: Card(
        elevation: 3, // Adiciona uma sombra leve
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
        color: Color.fromARGB(255, 230, 255, 252),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Soma",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 68, 68, 68)),
              ),
              Switch(
                value: showAverage,
                onChanged: (value) {
                  setState(() {
                    showAverage = value;
                  });
                },
              ),
              const Text(
                "Média",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 68, 68, 68)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewInformation() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
              "Novos Clientes:", info["NovosClientes"]!, Icons.co_present),
          SizedBox(height: 12),
          _buildInfoRow("Clientes Perdidos:", info["ClientesPerdidos"]!,
              Icons.menu_book_rounded),
          SizedBox(height: 12),
          _buildInfoRow(
              "Prospectados:", info["Prospectados"]!, Icons.cases_outlined),
        ],
      ),
    );
  }

  Widget _buildAddInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      child: Column(
        children: [
          // Campo para selecionar o mês
          Column(
            children: [
              Text("Selecionar a Data:"),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectMonthYear(context, false, true),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    insertDate != null
                        ? DateFormat("MM/yyyy").format(insertDate!)
                        : "Selecione o mês e ano",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(title: "Novos Clientes", value: "0"),
              SizedBox(height: 8),
              _buildTextField(title: "Clientes Perdidos", value: "0"),
              SizedBox(height: 8),
              _buildTextField(title: "Prospectados", value: "0"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Color(0xff00bfa5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String title, required String value}) {
    return TextField(
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
