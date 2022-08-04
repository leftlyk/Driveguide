import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int userLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Driveguide',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            userLevel += 1;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                color: Colors.amber,
                padding: EdgeInsets.all(150.0),
                child: Text('Map'),
              ),
            ),
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(10.0),
              child: Text('Christchurch Tour', style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            Container(
              color: Colors.orange,
              padding: EdgeInsets.all(10.0),
              child: Text('45min of 1hr 30min', style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              color: Colors.pink,
              padding: EdgeInsets.all(10.0),
              width: 200,
              child: Text('On your left: Anzac Memorial Bridge'),
            ),
            SizedBox(height: 40.0),
            FlatButton(
              onPressed: () {},
              color: Colors.deepOrange,
              padding: EdgeInsets.all(10.0),
              child: Text('Pause Experience', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25.0,
                ),
              ),
            ),
          ],
        ),
    );
  }
}


