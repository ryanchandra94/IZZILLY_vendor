
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/Edit_product.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';



class UnPublishProducts extends StatelessWidget {


  FirebaseServices _services = FirebaseServices();

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _services.product.where('published', isEqualTo: false).where('seller.selleruid', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Something went wrong...');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('product'))),
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Info')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _productsDetails(snapshot.data, context),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productsDetails(QuerySnapshot snapshot, context){
      List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
        if(document!=null){
            return DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: 55,
                      child: Expanded(child: Text(document['productName'])),)
                  ),
                  DataCell(
                      Container(
                        width: 50,
                        child: Image.network(document['productImage']),)
                  ),
                  DataCell(
                      IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditViewProduct(
                              prodcutId: document['productId'],
                            )));
                          },
                        icon: Icon(Icons.info_outline),
                      )
                  ),
                  DataCell(
                      popUpButton(document.data())
                  ),
                ]
            );
        }
      }).toList();
      return newList;
  }

  Widget popUpButton(data, {BuildContext context}){

    FirebaseServices _services = FirebaseServices();

  return PopupMenuButton<String>(
    onSelected: (String value){
      if(value == 'publish'){
        _services.publishProduct(
            id: data['productId']
        );
      }

      if(value == 'delete'){
        _services.delelteProduct(
          id: data['productId']
        );
      }
    },
      itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: 'publish',
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('publish'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Delete Product'),
          ),
        ),
      ]
  );
  }
}
