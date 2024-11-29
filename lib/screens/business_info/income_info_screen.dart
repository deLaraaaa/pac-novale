import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class IncomeInfoScreen extends StatefulWidget {
  @override
  _IncomeInfoScreenState createState() => _IncomeInfoScreenState();
}

class _IncomeInfoScreenState extends State<IncomeInfoScreen> {
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
  final Map<String, String> info = {"Faturamento": "15"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Engajamento"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Switch para alternar entre Exibir e Adicionar Informações
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Modo atual: ${showViewMode ? "Somente exibir informações." : "Manipular e editar informações."}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão para selecionar Data de Entrada
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      // Botão para selecionar Data de Saída
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ? DateFormat("MM/yyyy")
                                      .format(selectedEndDate!)
                                      : "Selecione o mês e ano",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Adicionando o switch de "Média" e "Soma" aqui
              if (showViewMode) _buildCalculationSwitch(),
              SizedBox(height: 20.0),
              if (showViewMode)
                Center(
                  // Adicionando o widget Center para centralizar o botão
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedStartDate != null &&
                          selectedEndDate != null &&
                          (selectedEndDate!
                              .isAtSameMomentAs(selectedStartDate!) ||
                              selectedEndDate!.isAfter(selectedStartDate!))) {
                        getCompanieInfo(selectedStartDate, selectedEndDate);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      backgroundColor: Color(0xffaba3cc), // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Listar",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              // Exibe a tela correspondente com base no estado do switch
              showViewMode ? _buildViewInformation() : _buildAddInformation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
      child: Card(
        elevation: 3, // Adiciona uma sombra leve
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
        color: Color.fromARGB(255, 230, 255, 252),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          _buildInfoRow("Faturamento:", info["Faturamento"]!, Icons.co_present),
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
              _buildTextField(title: "Faturamento", value: "0"),
            ],
          ),
          SizedBox(height: 50.0),
          // Botão de Salvar
          ElevatedButton(
            onPressed: () {
              // Ação ao salvar (aqui apenas um exemplo com print)
              print("Informações salvas!");
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
              backgroundColor: Color(0xff00bfa5), // Cor do botão
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Salvar",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
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
