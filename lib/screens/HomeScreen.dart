import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:login_application_1/model/post.dart';
import 'package:login_application_1/model/postslist.dart';
import 'package:login_application_1/model/user.dart';
import 'package:login_application_1/networking/networkhelper.dart';
import 'package:login_application_1/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NetworkHelper networkHelper = new NetworkHelper();
  List<Widget> allposts = new List<Widget>();
  Future<List<Widget>> getAllPosts() async
  {
    List<Widget> containers = new List<Widget>();
    try {
      Response response = await networkHelper.getAllPosts();
      List<dynamic> decodedJson = jsonDecode(response.body);
      PostsList postsList = PostsList.fromJson(decodedJson);
      for(Post postItem in postsList.posts)
        {
          containers.add(Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(3),
            height: 50,
            color: Colors.deepOrangeAccent,
            child: Center(child: Text(postItem.title)),
          ));
        }
      setState(() {
        allposts = containers;
      });
      return containers;
    }
    catch(e)
    {
      print('error : $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllPosts();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
          child: Column(
              children: [
            Text('My Token is ${widget.user.getToken()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 15,
            ),
            Opacity(
              opacity: 1,
              child: FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('logged_in', false);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  child: Text('List data coming from server',
                      style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(1),
                children: allposts,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
