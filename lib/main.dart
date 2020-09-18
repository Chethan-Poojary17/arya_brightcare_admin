import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arya BrightCare',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _submit() async {
    if (_controller1.text == "" ||
        _controller2.text == "" ||
        _controller3.text == "" ||
        _controller4.text == "" ||
        base64String.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please fill all the fields'),
        duration: Duration(seconds: 3),
      ));
    } else {
      setState(() {
        _isLoad = true;
      });
      final response = await http
          .post("https://www.aryabrightcare.in/php/newBlogPost.php", body: {
        "title": title.trim(),
        "body": body.trim(),
        "source": source.trim(),
        "image": base64String,
        "category": category.trim(),
      });
      print(response.body);
      _controller1.clear();
      _controller2.clear();
      _controller3.clear();
      _controller4.clear();
      image = null;
      _isLoad = false;
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Uploaded the blog successfully'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  String title = "";
  String body = "", source = "", image1 = "", category = "";
  String base64String = "";
  bool _isLoad = false;

  Uint8List image;
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Arya Brightcare Admin",
          textAlign: TextAlign.center,
        ),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              width: _mediaQuery.width * 1,
              height: _mediaQuery.height * 0.3,
              child: Center(
                child: image != null ? Image.memory(image) : Text('No data...'),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () async {
                final fromPicker =
                    await ImagePickerWeb.getImage(outputType: ImageType.bytes)
                        .then((value) {
                  base64String = base64Encode(value);
                  //Uint8List _bytesImage=Base64Decoder().convert(base64Image);
                  setState(() {
                    image = value;
                  });
                });
              },
              child: Text(
                'Upload image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: TextFormField(
                controller: _controller1,
                decoration: InputDecoration(
                    labelText: 'Title', hintText: 'Enter the Title'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: TextFormField(
                controller: _controller2,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter the Description'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: TextFormField(
                controller: _controller3,
                decoration: InputDecoration(
                    labelText: 'Source', hintText: 'Enter the Source'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: TextFormField(
                controller: _controller4,
                decoration: InputDecoration(
                    labelText: 'Category', hintText: 'Enter the Category'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: _isLoad
                  ? Center(child: CircularProgressIndicator())
                  : RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          title = _controller1.text;
                          body = _controller2.text;
                          source = _controller3.text;
                          category = _controller4.text;
                          _submit();
                        });
                      },
                      child: Text(
                        'Submit Blog',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
