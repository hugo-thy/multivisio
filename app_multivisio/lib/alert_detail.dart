import 'package:flutter/material.dart';
// Affiche les détails d'une alerte spécifique.​


class AlertDetailPage extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertDetailPage({Key? key, required this.alert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alert['title']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(alert['details']),
          ],
        ),
      ),
    );
  }
}
