import 'package:flutter/material.dart';
import 'package:real_chat_flutter/client_page.dart';
import 'package:real_chat_flutter/vendor_page.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: StartUpPage());
  }
}

class StartUpPage extends StatefulWidget {
  const StartUpPage({Key key}) : super(key: key);

  @override
  _StartUpPageState createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  final kMidnight = Color(0xff000033);
  final kBlue1 = Color(0xff3549B8);

  int userIndex = 0;
  TextEditingController nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: kMidnight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          userIndex = 0;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                        decoration: BoxDecoration(
                          color: userIndex == 0 ? kBlue1 : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('Client',
                            style: TextStyle(
                                color:
                                    userIndex == 0 ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userIndex = 1;
                        });
                        print(userIndex);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                        decoration: BoxDecoration(
                          color: userIndex != 0 ? kBlue1 : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('Vendor',
                            style: TextStyle(
                                color:
                                    userIndex != 0 ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 50),
              child: TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(hintText: 'Your Name'),
              ),
            ),
            InkWell(
              onTap: () {
                if (userIndex == 0)
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientPage(
                          name: nameCtrl.text,
                        ),
                      ));
                if (userIndex == 1)
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorPage(
                          name: nameCtrl.text,
                        ),
                      ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        kMidnight,
                        kBlue1,
                      ]),
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// console.log("User Joined : ", socket.id);
//
