import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_path_project/pages/menu.dart';
import 'package:flutter/material.dart';

class Coffee {
  final String tipo;
  final String origen;
  final int gramos;
  final int agua;
  final String imagen;
  final String? finca;
  final String? region;
  final String? altura;
  final String? variedad;
  final String? proceso;
  final String? tueste;
  final String? acidez;
  final String? notas;
  final String? preparacion;

  Coffee({
    required this.tipo,
    required this.origen,
    required this.gramos,
    required this.agua,
    required this.imagen,
    this.finca,
    this.region,
    this.altura,
    this.variedad,
    this.proceso,
    this.tueste,
    this.acidez,
    this.notas,
    this.preparacion,
  });
}

class Page3 extends StatefulWidget {
  final String selectedImage;

  Page3({required this.selectedImage});

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _uid; 
  String _tipo = '';
  String _origen = '';
  int _gramos = 0;
  int _agua = 0;
  String? _finca;
  String? _region;
  String? _altura;
  String? _variedad;
  String? _proceso;
  String? _tueste;
  String? _acidez;
  String? _notas;
  String? preparacion;
  bool _showAdditionalData = false; 

  @override
  void initState() {
    super.initState();
    _getUserID();
    _getMetodoFromImage();
  }

  void _getMetodoFromImage() {
    List<String> parts = widget.selectedImage.split('/');
    String filenameWithExtension = parts.last;
    List<String> nameParts = filenameWithExtension.split('.');
    preparacion = nameParts.first; // Guardamos el nombre del archivo sin extensión.
  }

  void _getUserID() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final coffee = Coffee(
        tipo: _tipo,
        origen: _origen,
        gramos: _gramos,
        agua: _agua,
        imagen: widget.selectedImage,
        finca: _finca,
        region: _region,
        altura: _altura,
        variedad: _variedad,
        proceso: _proceso,
        tueste: _tueste,
        acidez: _acidez,
        notas: _notas,
        preparacion: preparacion,
      );

      _saveToFirestore(coffee);
    }
  }

  void _saveToFirestore(Coffee coffee) async {
    try {
      if (_uid != null) {
        Map<String, dynamic> data = {
          'uid': _uid,
          'tipo': coffee.tipo,
          'origen': coffee.origen,
          'gramos': coffee.gramos,
          'agua': coffee.agua,
          'imagen': coffee.imagen,
          'preparacion': coffee.preparacion,
        };

        if (coffee.finca != null && coffee.finca!.isNotEmpty) data['finca'] = coffee.finca;
        if (coffee.region != null && coffee.region!.isNotEmpty) data['region'] = coffee.region;
        if (coffee.altura != null && coffee.altura!.isNotEmpty) data['altura'] = coffee.altura;
        if (coffee.variedad != null && coffee.variedad!.isNotEmpty) data['variedad'] = coffee.variedad;
        if (coffee.proceso != null && coffee.proceso!.isNotEmpty) data['proceso'] = coffee.proceso;
        if (coffee.tueste != null && coffee.tueste!.isNotEmpty) data['tueste'] = coffee.tueste;
        if (coffee.acidez != null && coffee.acidez!.isNotEmpty) data['acidez'] = coffee.acidez;
        if (coffee.notas != null && coffee.notas!.isNotEmpty) data['notas'] = coffee.notas;

        await _firestore.collection('coffees').add(data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La receta ha sido guardada correctamente')));
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo guardar en Firestore: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iCoffeeRecipe'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.selectedImage),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Tipo de café'),
                      value: _tipo.isEmpty ? null : _tipo,
                      items: ['Arábica', 'Robusta'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _tipo = newValue!;
                        });
                      },
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Selecciona un tipo de café'
                          : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Origen del café'),
                      textCapitalization: TextCapitalization.sentences,
                      onSaved: (value) {
                        _origen = value ?? '';
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Introduce el origen del café'
                          : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Gramos (gr)'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _gramos = int.parse(value ?? '0');
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Introduce la cantidad de gramos'
                          : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Agua (ml)'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _agua = int.parse(value ?? '0');
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Introduce la cantidad de agua'
                          : null,
                    ),
                    ListTile(
                      title: Text('Datos adicionales'),
                      trailing: Switch(
                        value: _showAdditionalData,
                        onChanged: (value) {
                          setState(() {
                            _showAdditionalData = value;
                          });
                        },
                      ),
                    ),
                    if (_showAdditionalData) ...[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Finca'),
                        onSaved: (value) {
                          _finca = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Región'),
                        onSaved: (value) {
                          _region = value;
                        },
                      ),
                                            TextFormField(
                        decoration: InputDecoration(labelText: 'Altura'),
                        onSaved: (value) {
                          _region = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Variedad'),
                        onSaved: (value) {
                          _variedad = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Proceso'),
                        onSaved: (value) {
                          _proceso = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Tueste'),
                        onSaved: (value) {
                          _tueste = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Acidez'),
                        onSaved: (value) {
                          _acidez = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Notas'),
                        onSaved: (value) {
                          _notas = value;
                        },
                      ),
                    ],
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Guardar'),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Mostrar datos en una ventana emergente o en un nuevo Widget, como prefieras.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Detalles del Café'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Tipo: $_tipo'),
                                      Text('Origen: $_origen'),
                                      Text('Gramos: $_gramos'' gr'),
                                      Text('Agua: $_agua' ' ml'),
                                      if(_finca != null) Text('Finca: $_finca'),
                                      if(_region != null) Text('Región: $_region'),
                                      if(_variedad != null) Text('Variedad: $_variedad'),
                                      if(_proceso != null) Text('Proceso: $_proceso'),
                                      if(_tueste != null) Text('Tueste: $_tueste'),
                                      if(_acidez != null) Text('Acidez: $_acidez'),
                                      if(_notas != null) Text('Notas: $_notas'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Visualizar Datos'),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Menu()), 
                          );
                        },
                        child: Text('Ir al Menú'),
                                    ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
