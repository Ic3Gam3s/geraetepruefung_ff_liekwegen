import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/bemerkung_view.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:geraetepruefung_ff_liekwegen/pages/bemerkung_detail.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/pruefung_view.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/pruefung_new.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/dashboard.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/login_register.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geräte & Fahrzeugprüfung - FF Liekwegen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final _controller = SidebarXController(selectedIndex: 0);
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  void _changePage(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
      //print("selectedIndex " + selectedIndex.toString());
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
      _pageController.jumpToPage(selectedIndex);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.red[500],
      ),*/
      body: Row(
        children: [
          SidebarX(
            showToggleButton: false,
            controller: _controller,
            theme: SidebarXTheme(
              width: 100,
              //margin: EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                  color: Colors.red[400], shape: BoxShape.rectangle),
              selectedIconTheme: IconThemeData(
                color: Colors.amber
              )
            ),
            extendedTheme: SidebarXTheme(
              width: 250,
              //margin: EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                  color: Colors.red[400], shape: BoxShape.rectangle),
              selectedIconTheme: IconThemeData(
                color: Colors.amber
              )
            ),
            headerBuilder: (context, extended) {
              return const SizedBox(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Header"),
                ),
              );
            },
            footerDivider: _controller.extended == true ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copyright, color: Colors.amber,),
                      Text('Tech-Flame IT-Services', style: TextStyle(color: Colors.amber),)
                    ],
                  ),
                ),
              ],
            ) : SizedBox(height: 0,),
            items: [
              SidebarXItem(
                icon: Icons.home,
                label: 'Startseite',
                onTap: () {
                  _changePage(0);
                  _onPageChanged(0);
                },
              ),
              SidebarXItem(
                icon: Icons.new_label,
                label: 'Neue Pruefung erstellen',
                onTap: () {
                  _changePage(1);
                  _onPageChanged(1);
                },
              ),
              SidebarXItem(
                icon: Icons.label,
                label: 'Pruefungen anzeigen',
                onTap: () {
                  _changePage(2);
                  _onPageChanged(2);
                },
              ),
              SidebarXItem(
                icon: Icons.warning,
                label: 'Bemerkungen anzeigen',
                onTap: () {
                  _changePage(3);
                  _onPageChanged(3);
                },
              ),
            ],
          ),
          /*Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              height: double.infinity,
              width: MediaQuery.of(context).size.width >= 1200 ? 250
              : MediaQuery.of(context).size.width <= 800 ? 0 : 80,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///
                    /// Header
                    ///

                    MediaQuery.of(context).size.width >= 1200 ? 
                      SizedBox(
                        height: 150,
                        width: 250,
                      )
                    : SizedBox(height: 0,),

                    Divider(),

                    ///
                    /// Body
                    ///
                    
                    
                  ],
                ),
              ),
            ),
          ),*/
          Expanded(
            child: Center(
              child: PageView(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  dashboardPage(),
                  PruefungNewPage(),
                  PruefungViewPage(),
                  bemerkungViewPage()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
