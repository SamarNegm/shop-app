import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/profil.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/Editprofile';
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    'Edit Profile',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        elevation: 4,
                        shadowColor: Colors.black,
                        color: Color(0xffF4F4F4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            initialValue: 'samar',
                            decoration: InputDecoration(
                              counterStyle: TextStyle(
                                  fontSize: 20, color: Color(0xff707070)),
                              prefixText: 'Name: ',

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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
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
                          Navigator.of(context).pushNamed(profile.routeName);
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
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ))),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
