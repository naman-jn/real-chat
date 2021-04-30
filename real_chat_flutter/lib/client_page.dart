import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class ClientPage extends StatefulWidget {
  final String name;

  const ClientPage({Key key, @required this.name}) : super(key: key);
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  SocketIO socketIO;
  List<String> requests;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  bool joined;
  final kMidnight = Color(0xff000033);
  final kBlue1 = Color(0xff3549B8);
  @override
  void initState() {
    //Initializing the message list
    requests = List<String>();
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'https://real-chat07.herokuapp.com',
      '/',
    );
    //Call init before doing anything with socket
    socketIO.init();
    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      // Map<String, dynamic> data = json.decode(jsonData);
      // this.setState(() => requests.add(data['message']));
      this.setState(() => requests.add(jsonData));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    socketIO.subscribe("vendor-accept-request", (jsonData) {
      print(jsonData);
      Map<String, dynamic> data = json.decode(jsonData);

      this.setState(() => requests.add(data['name'] + "-> Has accepted"));
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
        "client-join", json.encode({'name': widget.name}));
    joined = true;
  }

  Widget buildSingleMessage(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.indigo[600],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          requests[index],
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.7,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.5,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Write Anything...',
        ),
        controller: textController,
      ),
    );
  }

  Widget buildSendButton() {
    return InkWell(
      onTap: () {
        if (textController.text.isNotEmpty) {
          socketIO.sendMessage(
              "client-join", json.encode({'name': widget.name}));
          socketIO.sendMessage(
              "user-request", json.encode({'name': textController.text}));
          //Add the message to the list
          this.setState(() => requests.add(textController.text));
          textController.text = '';
          //Scrolldown the list to show the latest message
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 600),
            curve: Curves.ease,
          );
        }
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
          "Send Request",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width * 0.5,
      child: Column(
        children: <Widget>[
          buildChatInput(),
          SizedBox(
            height: 10,
          ),
          buildSendButton(),
        ],
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
              Text("Client",
                  style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: height * 0.03),
              buildMessageList(),
              buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }
}
