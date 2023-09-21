import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_path_project/pages/datos.dart';
import 'package:firebase_path_project/pages/maps.dart';
import 'package:firebase_path_project/pages/pagina_1.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iCoffeeApp'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.data_usage),
              title: Text('Datos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreparacionesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Cafeterías'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () {
                cerrarSesion(context);
              },
            ),
          ],
        ),
      ),
      body: Preparaciones(),
    );
  }

  void cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class Preparaciones extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Preparaciones> {
  String _selectedImage = '';

  void _onImageSelected(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  void _goToNextPage() {
    if (_selectedImage.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Page3(selectedImage: _selectedImage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              _buildImageTile('assets/images/v60.png'),
              _buildImageTile('assets/images/chemex.png'),
              _buildImageTile('assets/images/aeropress.png'),
              _buildImageTile('assets/images/prensa.png'),
              _buildImageTile('assets/images/moka.png'),
              _buildImageTile('assets/images/syphon.png'),
            ],
          ),
        ),
        if (_selectedImage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _goToNextPage,
              child: const Text('Siguiente'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageTile(String imagePath, [double scale = 1.0]) {
    return GestureDetector(
      onTap: () => _onImageSelected(imagePath),
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: EdgeInsets.all(1.0), 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.0), 
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
