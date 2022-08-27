import 'package:flutter/material.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/pruefung.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/frage.dart';
import 'package:geraetepruefung_ff_liekwegen/classes/bemerkung.dart';

class bemerkungViewPage extends StatefulWidget {
  bemerkungViewPage({Key? key}) : super(key: key);

  @override
  State<bemerkungViewPage> createState() => _bemerkungViewPageState();
}

class _bemerkungViewPageState extends State<bemerkungViewPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.red[400],
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                TabBar(
                  controller: tabController,
                  tabs: const [
                    Text("Offene Bemerkungen"),
                    Text("Abgeschlossene Bemerkungen")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: <Widget>[OpenBemerkungTab(), ClosedBemerkungTab()]),
    );
  }
}

///
/// Offenen Bemerkungen
///

class OpenBemerkungTab extends StatefulWidget {
  OpenBemerkungTab({Key? key}) : super(key: key);

  @override
  State<OpenBemerkungTab> createState() => _OpenBemerkungTabState();
}

class _OpenBemerkungTabState extends State<OpenBemerkungTab> {
  List<Bemerkung> bemerkungen = [];
  List<Bemerkung> offeneBemerkungen = [];

  @override
  void initState() {
    getRelevantBemerkung();

    super.initState();
  }

  Future<void> getRelevantBemerkung() async {
    try {
      bemerkungen = await getAllBemerkungen();
    } catch (e) {
      print("Keine Bemerkungen gefunden");
      print('Error: $e');
    }

    //print(bemerkungen.toString());

    removeIrrelevantBemerkung(bemerkungen);
  }

  void removeIrrelevantBemerkung(List<Bemerkung> bemerkungen) {
    offeneBemerkungen = [];

    for (var i = 0; i < bemerkungen.length; i++) {
      if (bemerkungen[i].status == 'offen') {
        setState(() {
          offeneBemerkungen.add(bemerkungen[i]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Card(
            elevation: 4,
            child: TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.replay_outlined),
                  Text('Liste aktualisieren'),
                ],
              ),
              onPressed: () {
                getRelevantBemerkung();
              },
            ),
          ),
        ),
        offeneBemerkungen.isEmpty
            ? const Center(
                child: Text("Keine offenen Bemerkungen gefunden"),
              )
            : bemerkungList(offeneBemerkungen),
      ],
    );
  }
}

///
/// Geschlossene Bemerkungen
///

class ClosedBemerkungTab extends StatefulWidget {
  ClosedBemerkungTab({Key? key}) : super(key: key);

  @override
  State<ClosedBemerkungTab> createState() => _ClosedBemerkungTabState();
}

class _ClosedBemerkungTabState extends State<ClosedBemerkungTab> {
  List<Bemerkung> bemerkungen = [];
  List<Bemerkung> geschlosseneBemerkungen = [];

  @override
  void initState() {
    getRelevantBemerkung();

    super.initState();
  }

  Future<void> getRelevantBemerkung() async {
    try {
      bemerkungen = await getAllBemerkungen();
    } catch (e) {
      print("Keine Bemerkungen gefunden");
      print('Error: $e');
    }

    //print(bemerkungen.toString());

    removeIrrelevantBemerkung(bemerkungen);
  }

  void removeIrrelevantBemerkung(List<Bemerkung> bemerkungen) {
    geschlosseneBemerkungen = [];

    for (var i = 0; i < bemerkungen.length; i++) {
      if (bemerkungen[i].status == 'geschlossen') {
        setState(() {
          geschlosseneBemerkungen.add(bemerkungen[i]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Card(
            elevation: 4,
            child: TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.replay_outlined),
                  Text('Liste aktualisieren'),
                ],
              ),
              onPressed: () {
                getRelevantBemerkung();
              },
            ),
          ),
        ),
        geschlosseneBemerkungen.isEmpty
            ? const Center(
                child: Text("Keine geschlossenen Bemerkungen gefunden"),
              )
            : bemerkungList(geschlosseneBemerkungen),
      ],
    );
  }
}

///
/// List Widget
///

Widget bemerkungList(List<Bemerkung> data) {
  return Padding(
    padding: EdgeInsets.all(20.0),
    child: ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Card(
            elevation: 4,
            child: ListTile(
              isThreeLine: true,
              title: Text(
                data[index].bemerkung,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '\nPrüfung: ${data[index].pruefungZeitraum}\nFrage: ${data[index].fragenBezeichnung}'),
              onTap: () async {
                Bemerkung changedBemerkung = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) =>
                        bemerkungDetail(data[index], context));

                if (changedBemerkung != data[index]) {
                  updateBemerkung(changedBemerkung);
                }
              },
            ),
          ),
        );
      },
    ),
  );
}

AlertDialog bemerkungDetail(Bemerkung data, BuildContext context) {
  return AlertDialog(
    title: Text('${data.bemerkung}\nStatus: ${data.status}',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
    content: SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Prüfung',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      Text('ID: ${data.pruefungId}'),
                      Text('Zeitraum: ${data.pruefungZeitraum}')
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Frage',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      Text('Fragenbezeichnung: ${data.fragenBezeichnung}'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    actions: [
      Card(
        elevation: 4,
        child: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              data.status == 'offen'
                  ? Icon(Icons.lock_outline)
                  : Icon(Icons.lock_open_outlined),
              data.status == 'offen'
                  ? Text('Bemerkung Schließen!')
                  : Text('Bemerkung Öffnen!'),
            ],
          ),
          onPressed: () {
            if (data.status == 'offen') {
              data.status = 'geschlossen';
            } else if (data.status == 'geschlossen') {
              data.status = 'offen';
            }

            updateBemerkung(data);

            Navigator.of(context).pop(data);
          },
        ),
      ),
      Card(
        elevation: 4,
        child: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.close),
              Text('Fenster Schließen'),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop(data);
          },
        ),
      )
    ],
  );
}
