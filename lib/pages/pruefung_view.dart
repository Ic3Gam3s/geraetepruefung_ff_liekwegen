import 'package:flutter/material.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/pruefung.dart';
import 'package:geraetepruefung_ff_liekwegen/pages/pruefung_view_detail.dart';

class PruefungViewPage extends StatefulWidget {
  PruefungViewPage({Key? key}) : super(key: key);

  @override
  State<PruefungViewPage> createState() => _PruefungViewPageState();
}

class _PruefungViewPageState extends State<PruefungViewPage> {
  final Pruefung _listHeader =
      Pruefung(0, "Verantwortlicher", "Größe", "Zeitraum", "Erfassung");

  List<Pruefung> pruefung = [];

  @override
  void initState() {
    super.initState();

    getPruefungen();
  }

  Future<void> getPruefungen() async {
    List<Pruefung> auslese = await getAllPruefung();

    auslese.sort((a, b) => a.zeitraum.compareTo(b.zeitraum),);
    
    setState(() {
      pruefung = auslese;
    });
  }

  Widget listRow(Pruefung item) {
    String offeneBemerkungen = "Offene Bemerkungen";

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: Text("")),
        Expanded(child: Text(item.zeitraum)),
        Expanded(child: Text(item.datum)),
        Expanded(child: Text(item.verantwortlicher)),
        Expanded(child: Text(offeneBemerkungen)),
        Expanded(child: Text("")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        //Header
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: listRow(_listHeader),
        ),
        const Divider(),
        //Items
        Expanded(
          child: ListView.builder(
            itemCount: pruefung.length,
            itemBuilder: (BuildContext context, int index) {
              /*return Card(
                elevation: 4,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    height: 50,
                    child: Container(
                      //color: index % 2 == 0 ? Colors.white : Colors.grey,
                      child: listRow(pruefung[index]),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PruefungViewDetailPage(
                                pruefung: pruefung[index],
                              )),
                    );
                  },
                ),
              );*/
              return Card(
                elevation: 4,
                child: ListTile(
                  title: listRow(pruefung[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PruefungViewDetailPage(
                                pruefung: pruefung[index],
                              )),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}
