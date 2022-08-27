import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/pruefung.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/pruefung_new_detail.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/liste_bearbeiten.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/frage.dart';

class PruefungNewPage extends StatefulWidget {
  PruefungNewPage({Key? key}) : super(key: key);

  @override
  State<PruefungNewPage> createState() => _PruefungNewPageState();
}

class _PruefungNewPageState extends State<PruefungNewPage> {
  TextEditingController zeitraumController = TextEditingController();
  TextEditingController erfassungController = TextEditingController();
  TextEditingController verantwortlicherController = TextEditingController();
  String groesse = 'gross';

  List<Frage> fragenData = [];

  @override
  void initState() {
    super.initState();

    zeitraumController.text = "${DateTime.now().month}/${DateTime.now().year}";
    erfassungController.text =
        "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}";

    getFragen();
  }

  Widget textFormWithHeader(
      String header, TextEditingController controller, bool disabled) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(header),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: TextField(
            controller: controller,
            readOnly: disabled,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
          ),
        )
      ],
    ));
  }

  void getFragen() async {
    fragenData = await getAllFragen();
    //print(fragenData);
  }

  String getGroesse(String zeitraum) {
    String data = "";
    List splitted = zeitraum.split('/');
    String monat = splitted[0];

    switch (monat) {
      case '1':
        data = 'klein';
        break;
      case '2':
        data = 'mittel';
        break;
      case '3':
        data = 'klein';
        break;
      case '4':
        data = 'klein';
        break;
      case '5':
        data = 'gross';
        break;
      case '6':
        data = 'klein';
        break;
      case '7':
        data = 'klein';
        break;
      case '8':
        data = 'mittel';
        break;
      case '9':
        data = 'klein';
        break;
      case '10':
        data = 'klein';
        break;
      case '11':
        data = 'gross';
        break;
      case '12':
        data = 'klein';
        break;
      default:
    }

    return data;
  }

  void navigateToDetail() {
    //setNewPruefung(Pruefung(0, verantwortlicherController.text, groesse,
    //    zeitraumController.text, erfassungController.text));
    bool doNavigate = true;

    if (doNavigate == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PruefungNewDetailPage(
                  pruefung: Pruefung(
                      0,
                      verantwortlicherController.text,
                      getGroesse(zeitraumController.text),
                      zeitraumController.text,
                      erfassungController.text),
                  fragenData: fragenData,
                )),
      );
    }
  }

  void navigateToListChange() {
    //setNewPruefung(Pruefung(0, verantwortlicherController.text, groesse,
    //    zeitraumController.text, erfassungController.text));

    var temp = Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListeChangeDetailPage(
                fragenData: fragenData,
              )),
    );

    try {
      List<Frage> newfragenData = temp as List<Frage>;

      if (newfragenData == fragenData && newfragenData.isNotEmpty) {
        fragenData = newfragenData;
      }
    } catch (e) {
      print(e);
    }
  }

  void openDatePicker() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );

    if (selected != null) {
      setState(() {
        erfassungController.text =
            '${selected.day}.${selected.month}.${selected.year}';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Datum konnte nicht übertragen werden')));
    }
  }

  Future<void> openZeitraumPicker() async {
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    List<String> zeitraeume = [];

    for (var i = 0; i < 10; i++) {
      zeitraeume.add('${month}/${year}');
      month--;

      if (month < 1) {
        month = 12;
        year--;
      }
    }

    String seleected = await showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => LayoutBuilder(
            builder: ((context, constraints) => AlertDialog(
                  title: const ListTile(
                    title: Text('Zeitraum auswählen'),
                    subtitle: Text('Zum auswählen Kachel gedrückt halten'),
                  ),
                  content: SizedBox(
                    height: constraints.maxHeight * .5,
                    width: constraints.maxWidth * .3,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: zeitraeume.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Center(
                                child: Text(zeitraeume[index]),
                              ),
                              onLongPress: () {
                                Navigator.pop(context, zeitraeume[index]);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ))));

    setState(() {
      zeitraumController.text = seleected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 50,
              width: 160,
              child: ElevatedButton(
                onPressed: () => navigateToListChange(),
                child: Row(
                  children: [Icon(Icons.list), Text('Liste Bearbeiten')],
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Prüfungszeitraum'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                child: TextField(
                                  controller: zeitraumController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                  onTap: () => openZeitraumPicker(),
                                ),
                              )
                            ],
                          )),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Erfassungsdatum'),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: TextField(
                                    controller: erfassungController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                    onTap: () => openDatePicker(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textFormWithHeader("Verantwortlicher",
                              verantwortlicherController, false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => navigateToDetail(),
                  child: Row(
                    children: [
                      Icon(Icons.check_box_outlined),
                      Text('Prüfung Durchführen')
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
