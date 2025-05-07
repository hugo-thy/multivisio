import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'alert_detail.dart';
// represente un point d'entree de application flutter , en configurant les routes 
void main() {
  runApp(MyApp()); // lance l application dans classe MyApp
}

class MyApp extends StatelessWidget { // classe represente le racine de l'application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCTV Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardPage(), // route d'entree de l'application affichant le dashboard ( dashboard.dart)
        '/alert': (context) {
          final alert = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AlertDetailPage(alert: alert);
        },
      },
    );
  }
}
