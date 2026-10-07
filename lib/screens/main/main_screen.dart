import 'package:flutter/material.dart';
import 'package:tailorhub/screens/client/client_screen.dart';
import 'package:tailorhub/screens/main/dashboard.dart';
import 'package:tailorhub/screens/order/order_screen.dart';
import 'package:tailorhub/screens/template/template_screen.dart';
import 'package:tailorhub/widgets/custom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = [
    const Dashboard(),
    const ClientScreen(),
    const OrderScreen(),
    const TemplateScreen(),
    const ClientScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
