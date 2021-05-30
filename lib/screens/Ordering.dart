import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/CreditCard.dart';

class Ordering extends StatefulWidget {
  static const routeName = '/Ordering';
  @override
  _OrderingState createState() => _OrderingState();
}

class _OrderingState extends State<Ordering> {
  String dropdownValue = 'Credit card';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                child: Text(
                  'Ordering',
                  style: TextStyle(
                      color: Color(0xff222831),
                      fontSize: 40,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      elevation: 4,
                      shadowColor: Colors.black,
                      color: Color(0xffF4F4F4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                                fontSize: 20, color: Color(0xff707070)),
                            labelText: 'Full Nmae',
                            fillColor: Color(0xffF4F4F4),
                            // border: OutlineInputBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(30)
                            //         )
                            // )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      elevation: 4,
                      shadowColor: Colors.black,
                      color: Color(0xffF4F4F4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                                fontSize: 20, color: Color(0xff707070)),
                            labelText: 'Address',
                            fillColor: Color(0xffF4F4F4),
                            // border: OutlineInputBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(30)
                            //         )
                            // )
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Card(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(30))),
                  //     elevation: 4,
                  //     shadowColor: Colors.black,
                  //     color: Color(0xffF4F4F4),
                  //     child: ListTile(
                  //         onTap: () {
                  //           //Open the Map
                  //         },
                  //         title: Text('Enter Address',
                  //             style: TextStyle(
                  //                 fontSize: 20, color: Color(0xff707070))),
                  //         trailing: Icon(Icons.navigate_next_rounded),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(30)),
                  //         )),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 60,
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
                              style: const TextStyle(color: Color(0xff616161)),
                              underline: Container(
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                )),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Credit card',
                                'Direct payment during receipt',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xff707070)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 57,
                    child: ElevatedButton(
                      onPressed: () {
                        if (dropdownValue == 'Credit card') {
                          Navigator.of(context).pushNamed(CreditCard.routeName);
                        }
                      },
                      child: Text('Continue'),
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold)),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff222831)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ))),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
