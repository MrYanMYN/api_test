import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detection.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Detection> detectionObjects = [];

  // void initState() {
  //   getDetection();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Data: ',
            ),
            StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((event) => getDetection()),
                builder: (context, snapshot) {
                  if (snapshot.data.toString() != "[]" &&
                      snapshot.data.toString() != "null") {
                    String data = snapshot.data as String;
                    Map<String, dynamic> dataMap = jsonDecode(data)[0];
                    detectionObjects.add(Detection.fromJson(dataMap));
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: ListView.builder(
                        itemCount: detectionObjects.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Text(" ! "),
                            trailing: Text(
                                detectionObjects[index].lat.toString() +
                                    " " +
                                    detectionObjects[index].long.toString()),
                            title: Text("Detections: "),
                          );
                        }),
                  );
                })
            // Text(
            //   '$_detection',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
    );
  }
}
