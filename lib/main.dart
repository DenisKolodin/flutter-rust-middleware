// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => new _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel methodChannel =
  const MethodChannel('mimir.labs/middleware');

  String _middleware = 'Call a method.';

  Future<Null> _middleWare(funcall) async {
    String middleware;
    try {
      final String call = await methodChannel.invokeMethod(
          'middleWare',
          funcall
      );
      Map<String, dynamic> result = json.decode(call);
      middleware = '${result['Ok']}!';
    } on PlatformException {
      middleware = 'Failed to call method.';
    }
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
                  onPressed: () => _middleWare({
                    'method': 'hello-json',
                    'params': 'Nicolas is the greatest'
                  }),
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