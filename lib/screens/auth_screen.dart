import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/models/users.dart';
import 'package:flutter_complete_guide/providers/Users.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
//            decoration: BoxDecoration(
////              gradient: LinearGradient(
////                colors: [
////                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
////                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
////                ],
////                begin: Alignment.topLeft,
////                end: Alignment.bottomRight,
////                stops: [0, 1],
////              ),
//            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16, left: 16, bottom: 8, top: 20),
                        child: Text(
                          'Welcome to .., ',
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//                      transform: Matrix4.rotationZ(-8 * pi / 180)
//                        ..translate(-10.0),
//                      // ..translate(-10.0),
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image(
                              image: AssetImage('assets/images/logo.png'))),
                    ),
                  ),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation<Size> _heightAnimation;
  TextEditingController tecName;
  TextEditingController tecEmail;
  TextEditingController tecConfirm;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
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
  }

  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).signin(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name'],
          _authData['email'],
          _authData['password'],
        );
        var x = Provider.of<Auth>(context, listen: false);
        print(Provider.of<Auth>(context, listen: false).isAuth.toString());
        print(Provider.of<Auth>(context, listen: false).token.toString());
        await Provider.of<Users>(context, listen: false).addUser(
            users(
              name: _authData['name'],
              email: _authData['email'],
            ),
            x.uerId,
            x.token);
      }
      Navigator.of(context).pushReplacementNamed(ProductDetailScreen.routeName);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      final errorMessage =
          ('Could not authenticate you. Please try again later.' +
              error.toString());
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 4),
        child: Text(
          _authMode == AuthMode.Login ? 'Log in' : 'Sign up',
          style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(56.0),
        ),
        elevation: 8.0,
        child: Container(
          // height: _authMode == AuthMode.Signup ? 320 : 260,
          height: deviceSize.height * 0.55,
          constraints: BoxConstraints(minHeight: _heightAnimation.value.height),
          width: deviceSize.width,

          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: deviceSize.height * .5,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (_authMode == AuthMode.Signup)
                      TextFormField(
                        controller: tecName,
                        key: Key('t1'),
                        decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 12),
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.perm_identity)),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid Name!';
                          }
                        },
                        onSaved: (value) {
                          _authData['name'] = value;
                        },
                      ),
                    TextFormField(
                      controller: tecEmail,
                      key: Key('t2'),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 12),
                          labelText: 'E-Mail',
                          prefixIcon: Icon(Icons.perm_identity)),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                    TextFormField(
                      key: Key('t3'),
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 12,
                          ),
                          prefixIcon: Icon(Icons.lock_outline)),
                      textInputAction: (_authMode == AuthMode.Signup)
                          ? TextInputAction.next
                          : TextInputAction.done,
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    if (_authMode == AuthMode.Signup)
                      TextFormField(
                        controller: tecConfirm,
                        key: Key('t4'),
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    SizedBox(
                      height: 60,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      SizedBox(
                        height: 50,
                        width: deviceSize.width * 0.94,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          child: ElevatedButton(
                            key: Key('rb1'),
                            child: Text(
                              _authMode == AuthMode.Login
                                  ? 'Sign in'
                                  : 'Sign up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            onPressed: _submit,
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .button
                                        .color)),
                                backgroundColor: MaterialStateProperty.all(
                                    HexColor('#222831')),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ))),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          '${_authMode == AuthMode.Login ? 'Sign up' : 'Sign in'} ',
                          style: TextStyle(
                              color: HexColor('#222831'), fontSize: 24),
                        ),
                        onPressed: _switchAuthMode,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
