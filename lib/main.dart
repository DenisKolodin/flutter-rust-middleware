// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Our middleware class
class MiddleWare {
  // the methhod channel will talk to ios/android
  static const MethodChannel middlewareChannel =
  const MethodChannel('mimir.labs/middleware');
  // execute a command to the rust backend, we don't know when it will complete so we use a future
   static Future<String> execute(Command cmd) async {
     // hold the output
    String middleware;
    // let's give it a try
    try {
      // invoke the method and store the output in a sting
      final String call = await middlewareChannel.invokeMethod(
        // our method call to the ios/android backend is static to make life a little easier
          'middleWare',
          // we pass the actual method and arguments to the backend
          <String, dynamic>{
            'method': cmd.method,
            'params': cmd.params,
          }
      );
      // decode the output
      Map<String, dynamic> result = json.decode(call);
      // store the output string to return to the frontnd
      middleware = '${result['Ok']}!';

    } on PlatformException {
      // oops
      middleware = 'Failed to call ${cmd.method}.';
    }
    // return the result to the frontend
    return middleware;
  }
}

// our command class lets us pass any method and paramater to the rust backend
class Command {
  Command(this.method, this.params);

  final String method;
  final dynamic params;
}


class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => new _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {

  String _middleware = 'Call a method.';

  Future<void> middleware() async {
     String middleware =  await MiddleWare.execute(
        new Command('hello-json', 'Woahnahnah')
      );
     setState(() {
       _middleware = middleware;
     });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_middleware, key: const Key('Response')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('Call'),
                  onPressed: () => middleware(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
 runApp(new MaterialApp(home: new PlatformChannel()));
}
