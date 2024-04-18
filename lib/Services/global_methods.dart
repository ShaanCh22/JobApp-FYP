import 'package:flutter/material.dart';

class GlobalMethod {
  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xff1D1D2F),
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Error Occurred',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: TextButton(
                    onPressed: () {
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Color(0xff5800FF), fontSize: 18),
                    )),
              )
            ],
          );
        });
  }
}
