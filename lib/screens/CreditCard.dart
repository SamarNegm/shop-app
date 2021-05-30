import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class CreditCard extends StatefulWidget {
  static const routeName = '/CreditCard';
  const CreditCard({Key key}) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CreditCardWidget(
                  textStyle: TextStyle(color: Color(0xff222831)),
                  cardBgColor: Theme.of(context).accentColor,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(
                        themeColor: Theme.of(context).primaryColor,
                        formKey: formKey,
                        onCreditCardModelChange: onCreditCardModelChange,
                        cardHolderName: '',
                        cardNumber: '',
                        cvvCode: '',
                        expiryDate: '',
                        obscureCvv: false,
                        obscureNumber: false,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder Name',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .7,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              textStyle: MaterialStateProperty.all(TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 25,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold)),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff222831)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ))),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: const Text(
                              'Validate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              print('valid!');
                              _showValidDialog(context, "Valid",
                                  "Your card successfully valid !!!");
                            } else {
                              print('invalid!');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<AlertDialog> _showValidDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18, color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
