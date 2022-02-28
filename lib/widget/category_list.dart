import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/provider/product_provider.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "selected category",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('category').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapShot) {
                if (snapShot.data == null) return CircularProgressIndicator();
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView(
                    children:
                        snapShot.data.docs.map((DocumentSnapshot document) {
                      return ListTile(
                        leading: CircleAvatar(
                            //ackgroundImage: NetworkImage(document['imageUrl']),
                            ),
                        title: Text(document['name']),
                        onTap: () {
                          Navigator.pop(context);
                          _provider.selectCategory(document['name']);
                        },
                      );
                    }).toList(),
                  ),
                );
              })
        ],
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Sub Category",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
              future: _services.category.doc(_provider.selectedCategory).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapShot) {
                if (snapShot.data == null) return CircularProgressIndicator();
                if (snapShot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapShot.data.data();
                  return data != null ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Main Category: '),

                                      FittedBox(
                                        child: Text(
                                          _provider.selectedCategory,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(thickness: 3,),
                          Container(
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListView.builder(
                                  itemBuilder: (BuildContext context, int index){
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        child: Text('${index + 1}'),
                                      ),
                                      title: Text(data['SubCat'][index]['name']),
                                      onTap: (){
                                        Navigator.pop(context);
                                        _provider.selectSubCategory(data['SubCat'][index]['name']);
                                      },
                                    );
                                  },
                                  itemCount: data['SubCat'] == null ? 0 : data['SubCat'].length,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ) : Text('No category selected');
                }
                return Center(child: CircularProgressIndicator(),);
              })
        ],
      ),
    );
  }
}
