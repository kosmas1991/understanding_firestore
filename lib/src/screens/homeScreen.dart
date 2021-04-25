import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final GoogleSignInAccount googleSignInAccount;

  const HomeScreen({Key key, this.googleSignInAccount}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('last_collection');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GoogleUserCircleAvatar(identity: widget.googleSignInAccount),
                  Text(
                    widget.googleSignInAccount.displayName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),
            ElevatedButton(
              child: Text('create collection ref'),
              onPressed: () {
                ref.add({"midas": "kosmidas"});
                setState(() {});
              },
            ),
            Container(
              height: 400,
              child: StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> myBigList = [];
                  if (snapshot.hasData) {
                    QuerySnapshot data = snapshot.data;
                    data.docs.forEach((element) {
                      myBigList.add(element.data());
                    });
                    //return Text(myBigList.toString());
                    return ListView.builder(
                      itemCount: myBigList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(myBigList[index]
                                  .keys
                                  .map((e) => e)
                                  .toString()),
                              Text(myBigList[index]["midas"]),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    //TODO: no data at all
                    return Text('no data');
                  }
                },
                stream: ref.snapshots(),
              ),
            ),
            ElevatedButton(
              child: Text('delete one collection ref'),
              onPressed: () {
                ref.get().then((value) {
                  value.docs[0].reference.delete();
                });

              },
            ),
            ElevatedButton(
              child: Text('update first collection ref'),
              onPressed: () {
                ref.get().then((value) {
                  value.docs[0].reference.update({'midas':'test'});
                });

              },
            )

          ],
        ),
      ),
    );
  }
}
