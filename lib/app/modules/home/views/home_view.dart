import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final hc = HomeController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRYPT'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
              child: MaterialButton(
                  color: Colors.blue,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Encrypt a File',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      Icon(FlutterIcons.file_archive_faw5s,
                          color: Colors.white),
                    ],
                  ),
                  onPressed: hc.getEncryptedFile),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
              child: MaterialButton(
                  color: Colors.blueAccent,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Decrypt a File',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      Icon(FlutterIcons.file_archive_faw5, color: Colors.white),
                    ],
                  ),
                  onPressed: hc.getDecryptedFile),
            ),
          ],
        ),
      ),
    );
  }
}
