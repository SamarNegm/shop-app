import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/icons/my_flutter_app_icons.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  File _storedImage;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 200,
    );
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _storedImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }
//  Future<void> _takePicture() async {
//    final imageFile = await ImagePicker().getImage(
//      source: ImageSource.gallery,
//      maxWidth: 600,
//    );
//    setState(() {
//      _storedImage = imageFile as File;
//    });
////    final appDir = await syspaths.getApplicationDocumentsDirectory();
////    final fileName = path.basename(imageFile.path);
//  //  final savedImage = await imageFile.copy('${appDir.path}/$fileName');
//  }

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _type = FocusNode();
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'type': '',
  };
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'type': _editedProduct.type,
        };
        //   _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    //_imageUrlController.dispose();
    _type.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (_storedImage == null && _editedProduct.imageUrl == '') {
      print('hi');

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Please pick an image')));
      return;
    }
    if (!isValid) {
      return null;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        throw error;
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, _storedImage);
      } catch (error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
//      } finally {
//        setState(() {
//          isLoading = false;
//        });
//        Navigator.of(context).pop();
//      }
        ;
      }
    }
    setState(() {
      print('aloha3');
      isLoading = false;
      Navigator.of(context).pop();
    });
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                color: Colors.grey[200]),
                            child: FittedBox(
                              child: _editedProduct.imageUrl != ''
                                  ? Image.network(_editedProduct.imageUrl)
                                  : _storedImage == null
                                      ? Container(
                                          color: Colors.grey[350],
                                        )
                                      : Image.file(_storedImage),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ]),

                    FlatButton.icon(
                      icon: Icon(
                        Icons.image_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        'Pick image',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: getImage,
                    ),
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            type: _editedProduct.type);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_type);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          type: _editedProduct.type,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['type'],
                      decoration: InputDecoration(labelText: 'type'),
                      textInputAction: TextInputAction.next,
                      focusNode: _type,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a type.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            type: value);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            type: _editedProduct.type);
                      },
                    ),

//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: <Widget>[
//                        Container(
//                          width: 100,
//                          height: 100,
//                          margin: EdgeInsets.only(
//                            top: 8,
//                            right: 10,
//                          ),
//                          decoration: BoxDecoration(
//                            border: Border.all(
//                              width: 1,
//                              color: Colors.grey,
//                            ),
//                          ),
//                          child: _imageUrlController.text.isEmpty
//                              ? Text('Enter a URL')
//                              : FittedBox(
//                                  child: Image.network(
//                                    _imageUrlController.text,
//                                    fit: BoxFit.cover,
//                                  ),
//                                ),
//                        ),
//                        Expanded(
//                          child: TextFormField(
//                            decoration: InputDecoration(labelText: 'Image URL'),
//                            keyboardType: TextInputType.url,
//                            textInputAction: TextInputAction.done,
//                            controller: _imageUrlController,
//                            focusNode: _imageUrlFocusNode,
//                            onFieldSubmitted: (_) {
//                              _saveForm();
//                            },
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'Please enter an image URL.';
//                              }
//                              print(value.toString() +
//                                  '***************************** hi there');
//                              if (!value.startsWith('http') &&
//                                  !value.startsWith('https')) {
//                                return 'Please enter a valid URL.';
//                              }
//                              if (!value.endsWith('.png') &&
//                                  !value.endsWith('.jpg') &&
//                                  !value.endsWith('.jpeg')) {
//                                return 'Please enter a valid image URL.';
//                              }
//                              return null;
//                            },
//                            onSaved: (value) {
//                              _editedProduct = Product(
//                                title: _editedProduct.title,
//                                price: _editedProduct.price,
//                                description: _editedProduct.description,
//                                imageUrl: value,
//                                id: _editedProduct.id,
//                                isFavorite: _editedProduct.isFavorite,
//                              );
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
