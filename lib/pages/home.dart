import 'package:flutter/material.dart';
import 'package:myapp/pages/employee.dart';
import 'package:myapp/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Productos",
          style: TextStyle(color: Color(0xFF2196F3)), // Azul
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF2196F3)), // Azul
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)), // Azul
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.black87),
              ),
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos disponibles',
                style: TextStyle(color: Colors.black87),
              ),
            );
          }

          final productos = snapshot.data!;
          
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              final productoId = producto['id'];
              
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID: ${producto['Id_producto'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFFFFC107), // AMARILLO (ID)
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF2196F3)), // Azul
                                onPressed: () => _showEditDialog(context, producto, productoId),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFFF44336)), // Rojo
                                onPressed: () async {
                                  await deleteProduct(productoId);
                                  if (mounted) setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Nombre', producto['Nombre'], isBlue: true),
                      _buildInfoRow('Descripción', producto['Descripcion'], isBlue: false),
                      _buildInfoRow('Tamaño', producto['Tamaño'], isBlue: true),
                      _buildInfoRow('Color', producto['Color'], isBlue: false),
                      _buildInfoRow('Precio', producto['Precio'], isBlue: true),
                      _buildInfoRow('Marca', producto['Marca'], isBlue: false),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: const Color(0xFFFFC107), // AMARILLO (botón flotante)
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(BuildContext context) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => const ProductDialog(),
    );
    if (updated == true && mounted) {
      setState(() {});
    }
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> productData, String productId) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => ProductDialog(
        productData: productData,
        productId: productId,
      ),
    );
    if (updated == true && mounted) {
      setState(() {});
    }
  }

  Widget _buildInfoRow(String label, dynamic value, {required bool isBlue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBlue ? const Color(0xFF2196F3) : const Color(0xFFFFC107), // AMARILLO cuando isBlue=false
            ),
          ),
          Text(
            value?.toString() ?? 'No especificado',
            style: TextStyle(
              color: isBlue ? const Color(0xFF2196F3) : const Color(0xFFFFC107), // AMARILLO cuando isBlue=false
            ),
          ),
        ],
      ),
    );
  }
}