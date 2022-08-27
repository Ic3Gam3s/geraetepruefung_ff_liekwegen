import 'package:flutter/material.dart';

import 'package:geraetepruefung_ff_liekwegen/classes/frage.dart';

class ListeChangeDetailPage extends StatefulWidget {
  List<Frage> fragenData;

  ListeChangeDetailPage({Key? key, required this.fragenData}) : super(key: key);

  @override
  State<ListeChangeDetailPage> createState() => _ListeChangeDetailPageState();
}

class _ListeChangeDetailPageState extends State<ListeChangeDetailPage> {
  List<Frage> fragen = [];

  TextEditingController bezeichnungController = TextEditingController();
  bool grossBool = true;
  bool mittelBool = false;
  bool kleinBool = false;

  @override
  void initState() {
    fragen = widget.fragenData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.list),
        title: Text('Prüfliste Bearbeiten'),
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.amber,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Container()),
                  Expanded(child: Text('Bezeichnung')),
                  Expanded(child: Center(child: Text('Halbjahr'))),
                  Expanded(child: Center(child: Text('Vierteljahr'))),
                  Expanded(child: Center(child: Text('Monatlich'))),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                child: ListView.separated(
                  itemCount: fragen.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_circle_up),
                                onPressed: (() {
                                  Frage tempFrage = Frage(
                                      fragen[index].id,
                                      fragen[index].bezeichnung,
                                      fragen[index].gross,
                                      fragen[index].mittel,
                                      fragen[index].klein);

                                  setState(() {
                                    try {
                                      fragen[index] = fragen[index - 1];
                                      fragen[index - 1] = tempFrage;
                                    } catch (e) {
                                      print(e);
                                    }
                                  });
                                })),
                            SizedBox(
                              width: 25,
                            ),
                            IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: (() {
                                  setState(() {
                                    fragen.remove(index);
                                  });
                                })),
                            SizedBox(
                              width: 25,
                            ),
                            IconButton(
                                icon: Icon(Icons.arrow_circle_down),
                                onPressed: (() {
                                  Frage tempFrage = Frage(
                                      fragen[index].id,
                                      fragen[index].bezeichnung,
                                      fragen[index].gross,
                                      fragen[index].mittel,
                                      fragen[index].klein);

                                  setState(() {
                                    try {
                                      fragen[index] = fragen[index + 1];
                                      fragen[index + 1] = tempFrage;
                                    } catch (e) {
                                      print(e);
                                    }
                                  });
                                })),
                          ],
                        )),
                        Expanded(child: Text(fragen[index].bezeichnung)),
                        Expanded(
                          child: Checkbox(
                            value: fragen[index].gross,
                            onChanged: ((value) {
                              setState(() {
                                fragen[index].gross = value!;
                              });
                            }),
                          ),
                        ),
                        Expanded(
                          child: Checkbox(
                            value: fragen[index].mittel,
                            onChanged: ((value) {
                              setState(() {
                                fragen[index].mittel = value!;
                              });
                            }),
                          ),
                        ),
                        Expanded(
                          child: Checkbox(
                            value: fragen[index].klein,
                            onChanged: ((value) {
                              setState(() {
                                fragen[index].klein = value!;
                              });
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
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
                        children: [Icon(Icons.cancel), Text('Abbrechen')],
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
                      width: 185,
                      child: ElevatedButton(
                          onPressed: () async {
                            var newFrage = await showDialog(
                                context: context,
                                builder: (_) => ListCreateAlert());

                            try {
                              newFrage.id = fragen.length + 1;

                              setState(() {
                                fragen.add(newFrage);
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add),
                              Text('Prüfung Hinzufügen')
                            ],
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
                      width: 160,
                      child: ElevatedButton(
                          onPressed: () {
                            setList(fragen);

                            Navigator.pop(context, fragen);
                          },
                          child: Row(
                            children: [Icon(Icons.save), Text('Speichern')],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white
                          ),
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

class ListCreateAlert extends StatefulWidget {
  ListCreateAlert({Key? key}) : super(key: key);

  @override
  State<ListCreateAlert> createState() => _ListCreateAlertState();
}

class _ListCreateAlertState extends State<ListCreateAlert> {
  TextEditingController bezeichnungController = TextEditingController();
  bool grossBool = false;
  bool mittelBool = false;
  bool kleinBool = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [Icon(Icons.add), Text("Prüfung Hinzufügen")],
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bezeichnung'),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: bezeichnungController,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Text('Halbjährlich')),
              Expanded(child: Text('Vierteljährlich')),
              Expanded(child: Text('Monatlich'))
            ],
          ),
          Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
                child: Checkbox(
                    value: grossBool,
                    onChanged: ((value) {
                      setState(() {
                        grossBool = value!;
                      });
                    }))),
            Expanded(
                child: Checkbox(
                    value: mittelBool,
                    onChanged: ((value) {
                      setState(() {
                        mittelBool = value!;
                      });
                    }))),
            Expanded(
                child: Checkbox(
                    value: kleinBool,
                    onChanged: ((value) {
                      setState(() {
                        kleinBool = value!;
                      });
                    }))),
          ]),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                height: 50,
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      Frage newFrage = Frage(0, bezeichnungController.text, grossBool, mittelBool, kleinBool);

                      Navigator.pop(context, newFrage);
                    },
                    child: Row(
                      children: const [Icon(Icons.save), Text('Speichern')],
                    ))),
          ),
        ],
      ),
    );
  }
}
