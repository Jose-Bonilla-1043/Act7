import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String productId;

  const EditProductPage({
    super.key,
    required this.productData,
    required this.productId,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _idProductoController;
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _tamanoController;
  late TextEditingController _colorController;
  late TextEditingController _precioController;
  late TextEditingController _marcaController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _idProductoController = TextEditingController(text: widget.productData['Id_producto']?.toString() ?? '');
    _nombreController = TextEditingController(text: widget.productData['Nombre']?.toString() ?? '');
    _descripcionController = TextEditingController(text: widget.productData['Descripcion']?.toString() ?? '');
    _tamanoController = TextEditingController(text: widget.productData['Tamaño']?.toString() ?? '');
    _colorController = TextEditingController(text: widget.productData['Color']?.toString() ?? '');
    _precioController = TextEditingController(text: widget.productData['Precio']?.toString() ?? '');
    _marcaController = TextEditingController(text: widget.productData['Marca']?.toString() ?? '');
  }

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

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        await updateProduct(widget.productId, {
          'Id_producto': _idProductoController.text,
          'Nombre': _nombreController.text,
          'Descripcion': _descripcionController.text,
          'Tamaño': _tamanoController.text,
          'Color': _colorController.text,
          'Precio': _precioController.text,
          'Marca': _marcaController.text,
        });
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
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
                ElevatedButton.icon(
                  label: const Text('Guardar Cambios'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _updateProduct,
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