import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final String companyName;
  final String companyCNPJ;
  final Color color; // Add color parameter

  const CompanyCard({
    required this.companyName,
    required this.companyCNPJ,
    required this.color, // Add color parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF26B4A6), // Set the background color of the card
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color, // Use the color for the letter symbol
          child: Text(
            companyName[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          companyName,
          style: const TextStyle(color: Colors.white), // Ensure text is readable
        ),
        subtitle: Text(
          companyCNPJ,
          style: const TextStyle(color: Colors.white), // Ensure text is readable
        ),
      ),
    );
  }
}
