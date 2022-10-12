import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imadeUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: "", price: 0, description: "", imageUrl: "");

  var _isInit = true;
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": ""
  };

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imadeUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "title": _editProduct.title,
          "description": _editProduct.description,
          "price": _editProduct.price.toString(),
          // "imageUrl": _editProduct.imageUrl
          "imageUrl": ""
        };
        _imadeUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imadeUrlController.text.startsWith("http") &&
              !_imadeUrlController.text.startsWith("https")) ||
          (!_imadeUrlController.text.endsWith(".png") &&
              !_imadeUrlController.text.endsWith(".jpg") &&
              !_imadeUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    }
    // Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues["title"],
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please provide a value.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        isFavorite: _editProduct.isFavorite,
                        id: _editProduct.id,
                        title: value,
                        description: _editProduct.description,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initValues["price"],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a price.";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    if (double.parse(value) <= 0) {
                      return "Please enter a number greater than zero.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        isFavorite: _editProduct.isFavorite,
                        id: _editProduct.id,
                        title: _editProduct.title,
                        description: _editProduct.description,
                        price: double.parse(value),
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initValues["description"],
                  decoration: InputDecoration(labelText: "Descriptiion"),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  focusNode: _descriptionFocusNode,
                  validator: ((value) {
                    if (value.isEmpty) {
                      return "Please enter a description.";
                    }
                    if (value.length < 10) {
                      return "Should be at least 10 characters long.";
                    }
                    return null;
                  }),
                  onSaved: (value) {
                    _editProduct = Product(
                        isFavorite: _editProduct.isFavorite,
                        id: _editProduct.id,
                        title: _editProduct.title,
                        description: value,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imadeUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(
                                _imadeUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: _initValues["imageUrl"],
                        decoration: InputDecoration(labelText: "Image Url"),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imadeUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          _saveForm();
                          setState(() {});
                        },
                        validator: ((value) {
                          if (value.isEmpty) {
                            return "Please enter an image URL.";
                          }
                          if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Please enter a valid URL.";
                          }
                          if (!value.endsWith(".png") &&
                              !value.endsWith(".jpg") &&
                              !value.endsWith(".jpeg")) {
                            return "Please enter a valid image URL.";
                          }
                          return null;
                        }),
                        onSaved: (value) {
                          _editProduct = Product(
                              isFavorite: _editProduct.isFavorite,
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: value);
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
