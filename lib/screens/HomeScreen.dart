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
  void getAllPosts() async
  {
    try {
      Response response = await networkHelper.getAllPosts();
      List<dynamic> decodedJson = jsonDecode(response.body);
      PostsList postsList = PostsList.fromJson(decodedJson);
      setState(() {
        this.postsList = postsList.posts;
      });
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
            ),ListTile(
            title: Text("Home"),
           /* trailing: Icon(Icons.arrow_forward),*/
          ),
            ListTile(
              title: Text("Profile"),
              /*trailing: Icon(Icons.arrow_forward),*/
            )],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
          child: Column(
              children: [
            Text('My Auth Token is : ${widget.user.getToken()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  child: Text('Dummy List data coming from server',
                      style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                ),
            Expanded(
              child: ListView.builder(
                  itemCount: postsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Toast.show('${postsList[index].title}', context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsets.all(1),
                        height: 50,
                        color: Colors.orange,
                        child: Center(child: Text('${postsList[index].title}')),
                      ),
                    );
                  }
              ),
            )
          ]),
        ),
      ),
    );
  }
}
