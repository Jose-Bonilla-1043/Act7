import 'package:flutter/material.dart';
import 'package:myapp/services/database.dart';

class ProductDialog extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String? productId;

  const ProductDialog({super.key, this.productData, this.productId});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idProductoController;
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _tamanoController;
  late final TextEditingController _colorController;
  late final TextEditingController _precioController;
  late final TextEditingController _marcaController;

  @override
  void initState() {
    super.initState();
    _idProductoController = TextEditingController(text: widget.productData?['Id_producto']?.toString() ?? '');
    _nombreController = TextEditingController(text: widget.productData?['Nombre']?.toString() ?? '');
    _descripcionController = TextEditingController(text: widget.productData?['Descripcion']?.toString() ?? '');
    _tamanoController = TextEditingController(text: widget.productData?['Tamaño']?.toString() ?? '');
    _colorController = TextEditingController(text: widget.productData?['Color']?.toString() ?? '');
    _precioController = TextEditingController(text: widget.productData?['Precio']?.toString() ?? '');
    _marcaController = TextEditingController(text: widget.productData?['Marca']?.toString() ?? '');
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

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final productData = {
        'Id_producto': _idProductoController.text,
        'Nombre': _nombreController.text,
        'Descripcion': _descripcionController.text,
        'Tamaño': _tamanoController.text,
        'Color': _colorController.text,
        'Precio': _precioController.text,
        'Marca': _marcaController.text,
      };

      try {
        if (widget.productId == null) {
          await addProduct(productData);
        } else {
          await updateProduct(widget.productId!, productData);
        }
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        widget.productId == null ? 'Agregar Producto' : 'Editar Producto',
        style: const TextStyle(
          color: Color(0xFF2196F3),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Color(0xFFFFC107)),
          ),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
          ),
          child: Text(widget.productId == null ? 'Agregar' : 'Guardar'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF2196F3)),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFC107)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2196F3)),
        ),
      ),
      style: const TextStyle(color: Colors.black87),
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