import 'package:flutter/material.dart';
import 'main_element.dart';
import 'about_screen.dart';
import 'players_screen.dart';


void main() {
  runApp(RealMadridApp());
}

class RealMadridApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Madrid App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/real_madrid_logo.png', height: 100),
          SizedBox(height: 20),
          Text(
            'Bienvenue sur l application Real Madrid',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
    MainElementScreen(),
    PlayersScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Madrid'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Nouvelles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Joueurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'À propos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, 
      ),
    );
  }
}