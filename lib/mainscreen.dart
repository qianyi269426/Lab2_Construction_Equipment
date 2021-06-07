import 'package:constructor_equipment/loginscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight;
  double screenWidth;
  List productlist = [];
  String _titlecenter = "Loading...";
  TextEditingController _prnameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProduct(_prnameController.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('HOMEPAGE'),
        backgroundColor: Color.fromRGBO(191, 30, 46, 50),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("MENU",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.red.shade900),
            ),
            ListTile(
              title: Text("Services", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Renting", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Products", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("My Account", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Contact Us", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                title: Text("Logout", style: TextStyle(fontSize: 16)),
                onTap: _logout),
          ],
        ),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            TextFormField(
              controller: _prnameController,
              decoration: InputDecoration(
                hintText: "Search product",
                suffixIcon: IconButton(
                  onPressed: () => _searchProduct(_prnameController.text),
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            if (productlist.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: Center(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 1,
                          children: List.generate(productlist.length, (index) {
                            return Padding(
                                padding: const EdgeInsets.all(7),
                                child: Card(
                                  elevation: 10,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: screenHeight / 5,
                                        width: screenWidth / 1.1,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://javathree99.com/s269426/constructorequipment/images/product/${productlist[index]['prid']}.jpg",
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Product ID: " +
                                                  productlist[index]['prid'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Name: " +
                                                  productlist[index]['prname'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Type: " +
                                                  productlist[index]['prtype'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Price:RM " +
                                                  productlist[index]['prprice'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                              "Quantity: " +
                                                  productlist[index]['prqty'],
                                              style: TextStyle(fontSize: 16))),
                                      SizedBox(height: 2),
                                    ],
                                  )),
                                ));
                          })))),
          ],
        )),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (content) => NewProduct()));
        },
        child: Icon(Icons.add),
      ),*/
    );
  }

  void _loadProduct(String prname) {
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/loadproduct.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        var jsondata = json.decode(response.body);
        productlist = jsondata["products"];
        setState(() {
          print(productlist);
        });
      }
    });
  }

  void _logout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  _searchProduct(String prname) {
    print(prname);
    http.post(
        Uri.parse(
            "https://javathree99.com/s269426/constructorequipment/php/loadproduct.php"),
        body: {
          "productname": prname,
        }).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        setState(() {
          print(productlist);
          var jsondata = json.decode(response.body);
          productlist = jsondata["products"];
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }
}
