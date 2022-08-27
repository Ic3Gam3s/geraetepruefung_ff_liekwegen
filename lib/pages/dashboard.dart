import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:geraetepruefung_ff_liekwegen/pages/login_register.dart';

class dashboardPage extends StatefulWidget {
  dashboardPage({Key? key}) : super(key: key);

  @override
  State<dashboardPage> createState() => _dashboardPageState();
}

class _dashboardPageState extends State<dashboardPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.logout, color: Colors.amber,),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ausloggen', style: TextStyle(color: Colors.amber),),
                  )
                ],
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2.0, color: Colors.amber)
              ),
              onPressed: () => logOutUser(context),
            ),
          )
        ],
      ),

      body: Container(),
    );
  }
}