import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class VendorPage extends StatefulWidget {
  final String name;
  const VendorPage({Key key, @required this.name}) : super(key: key);
  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  SocketIO socketIO;
  List<Map<String, dynamic>> requests;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  bool joined;
  @override
  void initState() {
    requests = [];
    scrollController = ScrollController();
    socketIO = SocketIOManager().createSocketIO(
      'https://real-chat07.herokuapp.com',
      '/',
    );

    socketIO.init();
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(() => requests.add(data['message']));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    socketIO.subscribe("user-request", (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print(data);

      this.setState(() => requests.add(data));
      print('==========>${requests.length}');
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });

    joined = false;
    joinClient();
    super.initState();
  }

  Future<void> joinClient() async {
    await socketIO.connect();

    print(joined);
    if (joined) return;
    await socketIO.sendMessage(
        "vendor-join", json.encode({'name': widget.name}));
    joined = true;
  }

  Widget buildSingleMessage(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.indigo[600],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Text(
              requests[index]['name'],
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            TextButton(
                onPressed: () {
                  socketIO.sendMessage(
                      "vendor-accept-request",
                      json.encode({
                        'name': widget.name,
                        'client': requests[index]['id']
                      }));
                },
                child: Text("Accept Request"))
          ],
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.8,
      width: width,
      child: ListView.builder(
        // controller: scrollController,
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: height * 0.01),
              Text("Vendor",
                  style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: height * 0.03),
              buildMessageList(),
            ],
          ),
        ),
      ),
    );
  }
}
