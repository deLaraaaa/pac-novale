import 'package:flutter/material.dart';

class ShowBusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/novale_hub_logo.jpeg', // Caminho da imagem
              height: 150, // Defina o tamanho que achar melhor
            ),
            SizedBox(height: 100),
            Text(
              'Você não possui nenhuma \nempresa cadastrada.',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontFamily: 'Roboto'
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                print('Cadastrar Empresa pressed');
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              child: Text(
                'CADASTRAR EMPRESA',
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
    );
  }
}
