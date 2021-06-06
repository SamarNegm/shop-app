import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/inputFild.dart';
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
  String dropdownValue = 'spoons';

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

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _type = FocusNode();
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List productsData = [];
  var isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    type: 'spoons',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'type': 'spoons',
  };
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      print('id 2 is ' + productId.toString());
      if (productId != null) {
        try {
          var items = Provider.of<Products>(context, listen: false).items;
          print(items.length.toString() + ' items');
        } catch (error) {
          print(error.toString());
          throw (error);
        }
        await Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts(true, '');
        productsData =
            await Provider.of<Products>(context, listen: false).items;
        print('poddata len2  ' + productsData.length.toString());
        _editedProduct = await Provider.of<Products>(context, listen: false)
            .findById(productId);
        print('id 2 is ' + _editedProduct.description);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'type': _editedProduct.type,
        };
        //   _imageUrlController.text = _editedProduct.imageUrl;
        setState(() {
          _isInit = false;
        });
      } else {
        setState(() {
          _isInit = false;
        });
      }
    }

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

      ScaffoldMessenger.of(context)
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
      print('hi not null');
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct, productsData);
      } catch (error) {
        print('error ' + error.toString());
        isLoading = false;
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
        throw error;
      }
    } else {
      try {
        print('ed product type' + _editedProduct.type);
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, _storedImage);
      } catch (error) {
        isLoading = false;
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
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
      body: _isInit || isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                elevation: 4,
                                shadowColor: Colors.black,
                                color: Color(0xffF4F4F4),
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
                            ),
                          ]),
                      TextButton.icon(
                        icon: Icon(
                          Icons.image_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          'Pick image',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: getImage,
                      ),
                      MyInputFild(
                        initialValue: _initValues['title'],
                        text: 'Title',
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
                      MyInputFild(
                        initialValue: _initValues['price'],
                        text: 'Price',
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
                      SizedBox(
                        height: 65,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          elevation: 4,
                          shadowColor: Colors.black,
                          color: Color(0xffF4F4F4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                isExpanded: true,
                                style: const TextStyle(
                                    fontSize: 15, color: Color(0xff616161)),
                                underline: Container(
                                  decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  )),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _editedProduct = Product(
                                        title: _editedProduct.title,
                                        price: _editedProduct.price,
                                        description: _editedProduct.description,
                                        imageUrl: _editedProduct.imageUrl,
                                        id: _editedProduct.id,
                                        isFavorite: _editedProduct.isFavorite,
                                        type: newValue);
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'spoons',
                                  'cups',
                                  'dishes',
                                  'kettle'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff707070)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      MyInputFild(
                        textInputAction: TextInputAction.done,
                        initialValue: _initValues['description'],
                        text: 'Description',
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              key: Key('rb2'),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              onPressed: _saveForm,
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle( 
                                          color: Theme.of(context)
                                              .primaryTextTheme
                                              .button
                                              .color)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff222831)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ))),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
