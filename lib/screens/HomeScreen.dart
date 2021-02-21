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
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NetworkHelper networkHelper = new NetworkHelper();
  List<Post> postsList = new List<Post>();
  void getAllPosts() async {
    try {
      Response response = await networkHelper.getAllPosts();
      List<dynamic> decodedJson = jsonDecode(response.body);
      PostsList postsList = PostsList.fromJson(decodedJson);
      setState(() {
        this.postsList = postsList.posts;
      });
    } catch (e) {
      print('error : $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllPosts();
    super.initState();
  }

  void logout() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged_in', false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Abid Suhail"),
              accountEmail: Text("Android Developer"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Toast.show('HOME', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text("Home"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Toast.show('Profile', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text("Profile"),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) {
              if (choice == 'Logout') {
                logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text('My Auth Token is : ${widget.user.getToken()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text('Data coming from server',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: postsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Toast.show('${postsList[index].title}', context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      },
                      child: ListTile(
                        leading: Icon(Icons.verified_user),
                        title: Text('${postsList[index].title}'),
                        subtitle: Text('${postsList[index].body}'),
                      ),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
