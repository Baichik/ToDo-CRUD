import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/config/colors.dart';

class Complete extends StatefulWidget {
  const Complete({Key? key}) : super(key: key);

  @override
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          shadowColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: const Text(
            'To do list',
            style: TextStyle(color: textColor, fontSize: 24),
          )),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('completeTask').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Text('No tasks');
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  int reverse = snapshot.data!.docs.length - 1 - index;
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(159, 130, 130, 130),
                          blurRadius: 10,
                          spreadRadius: 0.2,
                          offset: Offset(2, 5.5),
                        )
                      ]),
                      child: Card(
                        elevation: 0,
                        color: const Color.fromARGB(255, 118, 255, 125),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(
                            snapshot.data!.docs[reverse].get('ct'),
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    ));
  }
}
