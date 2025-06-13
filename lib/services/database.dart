import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getProducts() async {
  List<Map<String, dynamic>> products = [];
  QuerySnapshot queryProducts = await db.collection('productos').get();

  for (var documento in queryProducts.docs) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    data['id'] = documento.id;
    products.add(data);
  }

  return products;
}

Future<void> addProduct(Map<String, dynamic> productData) async {
  await db.collection('productos').add(productData);
}

Future<void> updateProduct(String productId, Map<String, dynamic> productData) async {
  await db.collection('productos').doc(productId).update(productData);
}

Future<void> deleteProduct(String productId) async {
  await db.collection('productos').doc(productId).delete();
}