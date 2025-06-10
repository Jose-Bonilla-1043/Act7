import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _idProductoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _tamanoController = TextEditingController();
  final _colorController = TextEditingController();
  final _precioController = TextEditingController();
  final _marcaController = TextEditingController();

  @override
  void dispose() {
    _idProductoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _tamanoController.dispose();
    _colorController.dispose();
    _precioController.dispose();
    _marcaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await addProduct({
        'Id_producto': _idProductoController.text,
        'Nombre': _nombreController.text,
        'Descripcion': _descripcionController.text,
        'Tamaño': _tamanoController.text,
        'Color': _colorController.text,
        'Precio': _precioController.text,
        'Marca': _marcaController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_idProductoController, 'ID Producto'),
                const SizedBox(height: 16),
                _buildTextField(_nombreController, 'Nombre'),
                const SizedBox(height: 16),
                _buildTextField(_descripcionController, 'Descripción'),
                const SizedBox(height: 16),
                _buildTextField(_tamanoController, 'Tamaño'),
                const SizedBox(height: 16),
                _buildTextField(_colorController, 'Color'),
                const SizedBox(height: 16),
                _buildTextField(_precioController, 'Precio', isNumber: true),
                const SizedBox(height: 16),
                _buildTextField(_marcaController, 'Marca'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Guardar Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'Por favor ingrese un número válido';
        }
        return null;
      },
    );
  }
}