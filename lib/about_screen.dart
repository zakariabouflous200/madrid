import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/real_madrid_logo.png', height: 100),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Real Madrid App',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              'À propos de app',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Cette application fournit les dernières nouvelles et des informations sur les joueurs du Real Madrid. Restez informé de tout ce qui concerne votre équipe préférée.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              'Contient',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. Dernières nouvelles du Real Madrid\n'
              '2. Informations détaillées sur le joueur\n'
              '3. À propos de l équipe et de l application',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              'Développeur',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- BOUFLOUS Zakariae ',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}