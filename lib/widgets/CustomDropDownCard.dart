import 'package:flutter/material.dart';

class CustomDropdownCard extends StatelessWidget {
  final String title;
  final String content;
  final List<String> options;
  final Function(String) onOptionSelected;

  const CustomDropdownCard({
    Key? key,
    required this.title,
    required this.content,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayContent = content;

    if (title == 'Entrada' || title == 'Saída') {
      displayContent = formatDate(content);
    }

    return GestureDetector(
      onLongPress: () => openDropdownDialog(context, displayContent),
      child: SizedBox(
        width: double.infinity, // Faz o card ocupar a largura total
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          color: const Color.fromARGB(255, 241, 241, 241),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$title: $displayContent',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  void openDropdownDialog(BuildContext context, String currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedValue = currentValue;

        return AlertDialog(
          title: Text('Selecione um valor para $title'),
          content: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedValue = newValue;
                onOptionSelected(newValue);
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }

  String formatDate(String date) {
    // Simulação de formatação de data
    return 'Data formatada ($date)';
  }
}
