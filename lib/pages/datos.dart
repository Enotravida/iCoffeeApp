import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class PreparacionesPage extends StatefulWidget {
  @override
  _PreparacionesPageState createState() => _PreparacionesPageState();
}

class _PreparacionesPageState extends State<PreparacionesPage> {
  final _auth = FirebaseAuth.instance;
  String? _uid;
  String? _userEmail;
  String? _selectedPreparacion;
  List<String> _preparaciones = [];

  @override
  void initState() {
    super.initState();
    _getUserID();
    _fetchPreparaciones();
  }

  void _getUserID() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
        _userEmail = user.email; 
      });
    }
  }

  // Obtener todos los origenes distintos disponibles en Firestore
void _fetchPreparaciones() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('coffees')
        .where('uid', isEqualTo: _uid)
        .get();
    for (var doc in snapshot.docs) {
      var preparacion = doc['preparacion'] as String;  // Nota el cambio de 'origen' a 'preparacion'
      if (!_preparaciones.contains(preparacion)) {
        setState(() {
          _preparaciones.add(preparacion);
        });
      }
    }
  }
  void _showPreparacionDetails(
    String documentId,
    String tipo,
    String origen,
    int gramosCafe,
    int agua,
    String? finca,
    String? region,
    String? altura,
    String? variedad,
    String? proceso,
    String? tueste,
    String? acidez,
    String? notas,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Detalle preparación'),
        content: SingleChildScrollView( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tipo: $tipo'),
              Text('Origen: $origen'),
              Text('Gramos de Café: $gramosCafe g'),
              Text('Agua: $agua ml'),
              if (finca != null) Text('Finca: $finca'),
              if (region != null) Text('Región: $region'),
              if (altura != null) Text('Altura: $altura m'),
              if (variedad != null) Text('Variedad: $variedad'),
              if (proceso != null) Text('Proceso: $proceso'),
              if (tueste != null) Text('Tueste: $tueste'),
              if (acidez != null) Text('Acidez: $acidez'),
              if (notas != null) Text('Notas: $notas'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              _deletePreparacion(documentId);
              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
          ElevatedButton(
            onPressed: () {
              _downloadPDF(
                tipo, 
                origen, 
                gramosCafe, 
                agua, 
                finca, 
                region, 
                altura, 
                variedad, 
                proceso, 
                tueste, 
                acidez, 
                notas
              );
            },
            child: Text('Descargar PDF'),
          ),
        ],
      ),
    );
  }

  void _deletePreparacion(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('coffees').doc(documentId).delete();
      // Acciones adicionales tras eliminar el registro, si es necesario.
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo eliminar el registro: $e'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

void _downloadPDF(
  String tipo,
  String origen,
  int gramosCafe,
  int agua,
  String? finca,
  String? region,
  String? altura,
  String? variedad,
  String? proceso,
  String? tueste,
  String? acidez,
  String? notas,
) async {
  final pdf = pw.Document();
  final contentStyle = pw.TextStyle(fontSize: 18);
  final titleStyle = pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold);

  final Uint8List imageBytes = (await rootBundle.load('assets/images/fondo.png')).buffer.asUint8List();
  final pw.ImageProvider pdfImage = pw.MemoryImage(imageBytes);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context) => pw.Stack(
        children: [
          pw.Positioned.fill(
            child: pw.Image(pdfImage, fit: pw.BoxFit.cover),
          ),
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('iCoffeeApp', style: titleStyle),
                pw.SizedBox(height: 20),
                pw.Text('Tipo: $tipo', style: contentStyle),
                pw.Text('Origen: $origen', style: contentStyle),
                pw.Text('Gramos de Café: $gramosCafe g', style: contentStyle),
                pw.Text('Agua: $agua ml', style: contentStyle),
                if (finca != null) pw.Text('Finca: $finca', style: contentStyle),
                if (region != null) pw.Text('Región: $region', style: contentStyle),
                if (altura != null) pw.Text('Altura: $altura m', style: contentStyle),
                if (variedad != null) pw.Text('Variedad: $variedad', style: contentStyle),
                if (proceso != null) pw.Text('Proceso: $proceso', style: contentStyle),
                if (tueste != null) pw.Text('Tueste: $tueste', style: contentStyle),
                if (acidez != null) pw.Text('Acidez: $acidez', style: contentStyle),
                if (notas != null) pw.Text('Notas: $notas', style: contentStyle),
                pw.Text('Usuario: $_userEmail', style: contentStyle),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Uint8List pdfBytes = await pdf.save();
  Printing.sharePdf(bytes: pdfBytes, filename: 'iCoffeeApp.pdf');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preparaciones'),
      ),
      body: _uid != null
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedPreparacion,
                    hint: Text('Filtrar por Metodo de Preparación'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPreparacion = newValue;
                      });
                    },
                    items: _preparaciones.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('coffees')
                        .where('uid', isEqualTo: _uid)
                        .where('preparacion', isEqualTo: _selectedPreparacion) 
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error al obtener los datos'),
                        );
                      } else {
                        final coffees = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: coffees.length,
                          itemBuilder: (context, index) {
                            final coffeeData =
                                coffees[index].data() as Map<String, dynamic>;
                            final documentId = coffees[index].id;
                            final tipo = coffeeData['tipo'];
                            final origen = coffeeData['origen'];
                            final gramosCafe = coffeeData['gramos'];
                            final agua = coffeeData['agua'];
                            return ListTile(
                              title: Text('Preparación ${index + 1}'),
                              onTap: () {
                                _showPreparacionDetails(
                                  documentId,
                                  tipo,
                                  origen,
                                  gramosCafe,
                                  agua,
                                  coffeeData['finca'],
                                  coffeeData['region'],
                                  coffeeData['altura'],
                                  coffeeData['variedad'],
                                  coffeeData['proceso'],
                                  coffeeData['tueste'],
                                  coffeeData['acidez'],
                                  coffeeData['notas'],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text('Usuario no autenticado'),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PreparacionesPage(),
  ));
}
