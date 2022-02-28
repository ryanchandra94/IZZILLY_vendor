import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';




class PublishProducts extends StatelessWidget {


  FirebaseServices _services = FirebaseServices();

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _services.product.where('published', isEqualTo: true).where('seller.selleruid', isEqualTo: user.uid).snapshots(),
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
                DataColumn(label: Text('Actions')),
              ],
              rows: _productsDetails(snapshot.data),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productsDetails(QuerySnapshot snapshot){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      if(document!=null){
        return DataRow(
            cells: [
              DataCell(
                  Container(child: Expanded(child: Text(document['productName'])),)
              ),
              DataCell(
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(document['productImage']),
                  ),)
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
          if(value == 'unpublish'){
            _services.unPublishProduct(
                id: data['productId']
            );
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'unpublish',
            child: ListTile(
              leading: Icon(Icons.check),
              title: Text('Un Publish'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Preview',
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Preview'),
            ),
          ),

        ]
    );
  }
}
