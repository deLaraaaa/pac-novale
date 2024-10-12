import 'package:flutter/material.dart';
import 'package:pac_novale/screens/create_business_screen.dart';

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
              'assets/novale_hub_logo.jpeg',
              height: 150,
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
