import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';

class BannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Card(
        child: StreamBuilder<QuerySnapshot>(
      stream: _services.vendorBanner.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return new SizedBox(
                height: 150,
                  width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    SizedBox(
                      height:200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                          child: Image.network(
                            document['imageUrl'],
                            fit: BoxFit.fill,
                          )),
                    ),
                    Positioned(
                      right:10,
                      top: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red,
                          onPressed: (){
                            EasyLoading.show(status: 'Deleting...');
                            _services.delelteBanner(id: document.id);
                            EasyLoading.dismiss();
                          },
                        )
                      ),
                    )
                  ],
                )
              );
            }).toList(),
          ),
        );
      },
    ));
  }
}
