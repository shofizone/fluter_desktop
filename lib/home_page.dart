import 'package:example_flutter/photo.dart';
import 'package:example_flutter/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';
import 'dart:convert';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  List<Photo> photos = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchUserdata();
    fetchPosts();
    super.initState();
  }

  fetchUserdata() async{
 await http.get("https://jsonplaceholder.typicode.com/users").then((res){
      var data = json.decode(res.body);
      data.forEach((d){
        users.add(User.fromJson(d));
      });
      print(data);
      setState(() {

      });
    });
  }

  fetchPosts() async{
    await http.get("https://jsonplaceholder.typicode.com/photos").then((res){
      var data = json.decode(res.body);
      data.forEach((d){
        photos.add(Photo.fromJson(d));
      });
      print(data);
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return ThreeColumnNavigation(
      title: Text('Demo'),
      showDetailsArrows: true,
      collapsedIconData: Icons.menu,
      backgroundColor: Theme.of(context).backgroundColor,
      sections: [
        MainSection(
          label: Text('Users'),
          icon: Icon(Icons.mail),
          itemCount: users.length,
          itemBuilder: (context, index, selected) {
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              selected: selected,
              title:  Text(users[index].name),
              subtitle:  Text(users[index].email),
            );
          },
          getDetails: (context, index) {
            return DetailsWidget(
              title: Text('Details'),
              child: users.length>0 ?ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: Icon(Icons.person),
                          radius: 50,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(users[index].name,style: TextStyle(fontSize: 18),),
                      ),
                    ],
                  ),

                  Padding(padding: const EdgeInsets.all(8.0), child: Text("Email: ${users[index].email}"),),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text("Address:"),),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text("${users[index].address.street}, ${users[index].address.suite}"),),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text(" ${users[index].address.suite}"),),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text("City: ${users[index].address.city}, Zip: ${users[index].address.zipcode}"),),

                ],
              ):Center(child: Text("No Data"),),
            );
          },
        ),
        MainSection(
          label: Text('Photos'),
          icon: Icon(Icons.send),
          itemCount: photos.length,
          itemBuilder: (context, index, selected) {
            return ListTile(
              leading: CircleAvatar(
               backgroundImage: NetworkImage(photos[index].thumbnailUrl),
              ),
              selected: selected,
              title: Text(photos[index].title),
            );
          },
          getDetails: (context, index) {
            return DetailsWidget(
              title: Text('Details'),
              child: photos.length>0? ListView(children: <Widget>[
                Container(padding: EdgeInsets.all(30),child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(photos[index].url))),
              Text(photos[index].title),
              ],):Center(
                child: Text(
                  "No data",
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}