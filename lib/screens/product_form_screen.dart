import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductFormScreen extends StatefulWidget {
  final String? uuid;

  const ProductFormScreen({super.key, this.uuid});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final apiService = ApiService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  bool _isLoading = false;
  Product? _editingProduct;

  @override
  void initState() {
    super.initState();
    if (widget.uuid != null) {
      _loadProduct(widget.uuid!);
    }
  }

  Future<void> _loadProduct(String uuid) async {
    setState(() => _isLoading = true);
    try {
      // FIXME Tu ne dois pas charger tous les produits mais plutot utilisé la route api qui permet de recuperer un seul produit
      // FIXME Du coup il faut fetch la routes /products/:uuid, Il te manque cette route dans ton api service
      final products = await apiService.fetchProducts();
      final product = products.firstWhere((p) => p.uuid == uuid);
      setState(() {
        _editingProduct = product;
        _nameController.text = product.name;
        _descriptionController.text = product.description;
        _priceController.text = product.price.toString();
        _imageController.text = product.image;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      // FIXME La chaine vide devrait être null sur l'uuid si tu pars du principe que tu veux forcement passer une Class Product à ton service
      // FIXME Mais clairement cette étape est inutile autant envoyé la donnée sur forme de Map<String, dynamic> dans ton service
      uuid: _editingProduct?.uuid ?? '',
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      image: _imageController.text,
    );

    setState(() => _isLoading = true);
    try {
      if (_editingProduct != null) {
        await apiService.updateProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit modifié avec succès')),
        );
      } else {
        await apiService.createProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit ajouté avec succès')),
        );
      }

      if (mounted) context.go('/'); // redirige et rafraîchit la liste
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // FIXME Tu n'as pas dispose les champs TextEditingController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.uuid != null ? 'Modifier Produit' : 'Ajouter Produit',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildField(_nameController, 'Nom'),
                    _buildField(_descriptionController, 'Description'),
                    _buildField(_priceController, 'Prix', isNumber: true),
                    _buildField(_imageController, 'URL de l’image'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        widget.uuid != null ? 'Modifier' : 'Ajouter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    // FIXME Tu testes uniquement que le champ doit etre rempli
    // FIXME Aucun test sur le format de l'url, ou sur le prix
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : null,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
    );
  }
}
