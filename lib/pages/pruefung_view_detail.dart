import 'package:flutter/material.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/pruefung.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/bemerkung.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/frage.dart';

class PruefungViewDetailPage extends StatefulWidget {
  Pruefung pruefung;
  PruefungViewDetailPage({Key? key, required this.pruefung}) : super(key: key);

  @override
  State<PruefungViewDetailPage> createState() => PruefungViewDetailPageState();
}

class PruefungViewDetailPageState extends State<PruefungViewDetailPage> {
  TextEditingController zeitraumController = TextEditingController();
  TextEditingController erfassungController = TextEditingController();
  TextEditingController verantwortlicherController = TextEditingController();
  List<Bemerkung> bemerkungen = [];
  List<Frage> fragenSorted = [];
  List<Frage> fragen = [];

  @override
  void initState() {
    super.initState();
    zeitraumController.text = widget.pruefung.zeitraum;
    erfassungController.text = widget.pruefung.datum;
    verantwortlicherController.text = widget.pruefung.verantwortlicher;
    getFragen();
    getBemerkungen();
  }


  Future<void> getFragen() async {
    List<Frage> fragenData = await getAllFragen();

    print(widget.pruefung.groesse);

    for (var i = 0; i < fragenData.length; i++) {
      switch (widget.pruefung.groesse) {
        case 'gross':
          setState(() {
            fragenSorted = fragenData;
          });

          break;
        case 'mittel':
          for (i = 0; i < fragenData.length; i++) {
            if (fragenData[i].mittel == true || fragenData[i].klein == true) {
              setState(() {
                fragenSorted.add(fragenData[i]);
              });
            }
          }
          break;
        case 'klein':
          for (i = 0; i < fragenData.length; i++) {
            if (fragenData[i].klein == true) {
              setState(() {
                fragenSorted.add(fragenData[i]);
              });
            }
          }
          break;
        default:
      }
    }
  }

  void sortFragen(List<Frage> fragenData) {
    for (var i = 0; i < fragenData.length; i++) {
      switch (widget.pruefung.groesse) {
        case 'gross':
          setState(() {
            fragenSorted = fragenData;
          });

          break;
        case 'mittel':
          for (i = 0; i < fragenData.length; i++) {
            if (fragenData[i].mittel == true || fragenData[i].klein == true) {
              setState(() {
                fragenSorted.add(fragenData[i]);
              });
            }
          }
          break;
        case 'klein':
          for (i = 0; i < fragenData.length; i++) {
            if (fragenData[i].klein == true) {
              setState(() {
                fragenSorted.add(fragenData[i]);
              });
            }
          }
          break;
        default:
      }
    }
  }

  Future<void> getBemerkungen() async {
    List<Bemerkung> data = await getBemerkungenToPruefung(widget.pruefung.id);

    for (var i = 0; i <= data.length - 1; i++) {
      if (data[i].status != 'geschlossen') {
        setState(() {
          bemerkungen.add(data[i]);
        });
      }
    }
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

  Widget listRow() {
    return Row();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text("Prüfung ${widget.pruefung.id} ansehen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textFormWithHeader("Zeitraum", zeitraumController, true),
                textFormWithHeader(
                    "Erfassungsdatum", erfassungController, true),
                textFormWithHeader(
                    "Verantwortlicher", verantwortlicherController, true)
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: bemerkungen.isEmpty
                        ? const Center(
                            child: Text('Keine Bemerkungen gefunden'),
                          )
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text('Offene Bemerkungen',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: bemerkungen.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(bemerkungen[index].bemerkung),
                                      subtitle: Text(
                                          bemerkungen[index].fragenBezeichnung),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: fragenSorted.isEmpty
                        ? const Center(
                            child: Text('Keine Prüfungen gefunden'),
                          )
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text('Prüfungen',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: fragenSorted.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title:
                                          Text(fragenSorted[index].bezeichnung),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
