import 'package:flutter/material.dart';


class CreateBusinessScreen extends StatefulWidget {
  @override
  _CreateBusinessScreenState createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessCNPJController = TextEditingController();
  final TextEditingController _businessMarketController = TextEditingController();
  final TextEditingController _businessInovationController = TextEditingController();
  final TextEditingController _businessStatusController = TextEditingController();
  final TextEditingController _businessEntryDateController = TextEditingController();
  final TextEditingController _businessExitDateController = TextEditingController();

  String? selectedValue = 'Empresa Incubada';


  DateTime? selectedDate;

  // Função para mostrar o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Data inicial no seletor
      firstDate: DateTime(2000), // Data mínima
      lastDate: DateTime(2100), // Data máxima
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Atualiza a data selecionada
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cadastrar Empresa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de seta para voltar
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Insira o nome da empresa:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  labelText: 'Nome da Empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              Row(
                children:[
                  Text(
                    'CNPJ:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessCNPJController,
                      decoration: InputDecoration(
                        labelText: 'CNPJ da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children:[
                  Text(
                    'Negócio:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessMarketController,
                      decoration: InputDecoration(
                        labelText: 'Negócio da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children:[
                  Text(
                    'Inovação:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessInovationController,
                      decoration: InputDecoration(
                        labelText: 'Inovação da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Tipo da Empresa:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24, // Tamanho do ícone
                    elevation: 16, // Elevação da lista ao ser aberta
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.teal,
                    ),
                    onChanged: (String? newValue) {

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
              SizedBox(height: 20),
              Row(
                children:[
                  Text(
                    'Estágio:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessStatusController,
                      decoration: InputDecoration(
                        labelText: 'Inovação da Empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children:[
                  Text(
                    'Entrada:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessEntryDateController,
                      decoration: InputDecoration(
                        labelText: 'Data de Entrada',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children:[
                  Text(
                    'Saída:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _businessExitDateController,
                      decoration: InputDecoration(
                        labelText: 'Data de Saída',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateBusinessScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                child: Text(
                  'CRIAR EMPRESA',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Colors.white
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
