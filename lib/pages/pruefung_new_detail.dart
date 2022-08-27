import 'package:flutter/material.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/pruefung.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/frage.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/bemerkung.dart';

class PruefungNewDetailPage extends StatefulWidget {
  Pruefung pruefung;
  List<Frage> fragenData;
  PruefungNewDetailPage(
      {Key? key, required this.pruefung, required this.fragenData})
      : super(key: key);

  @override
  State<PruefungNewDetailPage> createState() => _PruefungNewDetailPageState();
}

class _PruefungNewDetailPageState extends State<PruefungNewDetailPage> {
  List<bool> istGeprueft = [];
  List<TextEditingController> bemerkungControllerList = [];
  List<Frage> fragenSorted = [];

  @override
  void initState() {
    sortFragen();
    getPruefungId();

    for (var i = 0; i <= fragenSorted.length; i++) {
      istGeprueft.add(false);

      //String name = 'bemerkungController' + i.toString();
      bemerkungControllerList.add(TextEditingController());
    }

    super.initState();
  }

  Future<void> getPruefungId() async {
    List<Pruefung> pruefungen = await getAllPruefung();
    setState(() {
      widget.pruefung.id = pruefungen.length + 1;
    });
  }

  void sortFragen() {
    for (var i = 0; i < widget.fragenData.length - 1; i++) {
      switch (widget.pruefung.groesse) {
        case 'gross':
          fragenSorted = widget.fragenData;
          break;
        case 'mittel':
          for (i = 0; i < widget.fragenData.length - 1; i++) {
            if (widget.fragenData[i].mittel == true ||
                widget.fragenData[i].klein == true) {
              fragenSorted.add(widget.fragenData[i]);
            }
          }
          break;
        case 'klein':
          for (i = 0; i < widget.fragenData.length - 1; i++) {
            if (widget.fragenData[i].klein == true) {
              fragenSorted.add(widget.fragenData[i]);
            }
          }
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.list),
        title: Text(
            'Monatsprüfung für ${widget.pruefung.zeitraum} am ${widget.pruefung.datum}'),
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Expanded(child: Text("")),
                Expanded(child: Text(widget.pruefung.zeitraum)),
                Expanded(child: Text(widget.pruefung.datum)),
                Expanded(child: Text(widget.pruefung.verantwortlicher)),
                Expanded(child: Text(widget.pruefung.groesse)),
                const Expanded(child: Text("")),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: fragenSorted.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: Text(fragenSorted[index].bezeichnung),
                    )),
                    Expanded(
                        child: Checkbox(
                      value: istGeprueft[index],
                      onChanged: (value) {
                        setState(() {
                          istGeprueft[index] = value!;
                        });
                      },
                    )),
                    Expanded(
                        child: TextFormField(
                      controller: bemerkungControllerList[index],
                    ))
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 50,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      children: const [Icon(Icons.cancel), Text('Abbrechen')],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 50,
                  width: 186,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool allDone = true;

                      List<Bemerkung> bemerkungen = [];

                      for (var i = 0; i < bemerkungControllerList.length; i++) {
                        print(bemerkungControllerList[i].text);
                        print(bemerkungControllerList[i].text.isNotEmpty);
                        if (bemerkungControllerList[i].text.isNotEmpty == true) {
                          
                          Bemerkung bemerkung = Bemerkung(
                              i,
                              bemerkungControllerList[i].text,
                              widget.pruefung.id,
                              widget.pruefung.zeitraum,
                              widget.fragenData[i].bezeichnung,
                              'offen');
                          print(bemerkung.bemerkung);
                          bemerkungen.add(bemerkung);
                        }
                      }

                      for (var i = 0; i < istGeprueft.length - 1; i++) {
                        if (istGeprueft[i] == false) {
                          allDone = false;
                        }
                      }

                      if (allDone == true) {
                        if (bemerkungen.isNotEmpty) {
                          print('Array länge: ' + bemerkungen.length.toString());
                          await sendNewBemerkungen(bemerkungen);
                        }

                        setNewPruefung(Pruefung(
                            widget.pruefung.id,
                            widget.pruefung.verantwortlicher,
                            widget.pruefung.groesse,
                            widget.pruefung.zeitraum,
                            widget.pruefung.datum));

                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.save),
                        Text('Prüfung Abschließen')
                      ],
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
