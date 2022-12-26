import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  var _initValues = {
    'title': '',
    'description': '',
    'price': 0,
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    setState(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if ((!_imageUrlController.text.startsWith('http') &&
                !_imageUrlController.text.startsWith('https')) ||
            (!_imageUrlController.text.endsWith('.png') &&
                !_imageUrlController.text.endsWith('.jpg') &&
                !_imageUrlController.text.endsWith('.jpeg'))) {
          return;
        }
        if (_imageUrlController.text.isEmpty) {
          _imageUrlController.clear();
        }
      }
    });
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'] as String,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (val) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFav: _editedProduct.isFav,
                        title: val as String,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please provide a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'] as String,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (val) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFav: _editedProduct.isFav,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(val as String),
                        imageUrl: _editedProduct.imageUrl);
                  },
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please provide a price';
                    }
                    if (double.tryParse(val) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(val) <= 0) {
                      return 'Please enter the number greater than zero.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'] as String,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  onSaved: (val) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFav: _editedProduct.isFav,
                        title: _editedProduct.title,
                        description: val as String,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please provide a description';
                    }
                    if (val.length < 10) {
                      return 'It should be atleast more than 10 characters';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        right: 10,
                        top: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFav: _editedProduct.isFav,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: val as String,
                          );
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          if (!val.startsWith('http') &&
                              !val.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (val.endsWith('.png') &&
                              val.endsWith('.jpg') &&
                              val.endsWith('.jpeg')) {
                            return 'Please neter a valid image URL';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
