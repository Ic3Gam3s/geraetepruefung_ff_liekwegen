import 'package:firebase_database/firebase_database.dart';

class Pruefung {
  int id;
  String zeitraum;
  String datum;
  String verantwortlicher;
  String groesse;

  Pruefung(
      this.id, this.verantwortlicher, this.groesse, this.zeitraum, this.datum);

  String getZeitraum(String datum) {
    String Zeitraum = "Monat/Jahr";

    return Zeitraum;
  }
}

Future<List<Pruefung>> getAllPruefung() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Pruefung/');
  List<Pruefung> data = [];
  Query query = ref.orderByKey();

  DataSnapshot snapshot;
  List<dynamic> map = [];

  try {
    snapshot = await query.get();
    map = snapshot.child('/').value as List<dynamic>;
  } catch (e) {
    print(e);
  }

  //Map? map = snapshot.child('/').value as Map?;

  //print(map);
  try {
    /*
    for (var key in map!.keys) {
      Pruefung pruefung = Pruefung(
          key, // Id
          map[key.toString()]['verantwortlicher'], // Verantwortlicher
          map[key.toString()]['groesse'], // Größe
          map[key.toString()]['zeitraum'], // Zeitraum
          map[key.toString()]['datum'] //Datum
          );
      data.add(pruefung);
    }
    */
    for (var i = 1; i < map.length; i++) {
      Pruefung pruefung = Pruefung(i, map[i]['verantwortlicher'],
          map[i]['groesse'], map[i]['zeitraum'], map[i]['datum']);
      data.add(pruefung);
    }
  } catch (e) {
    print(e);
  }

  return data;
}

Future<bool> setNewPruefung(Pruefung data) async {
  bool ready = false;

  List<Pruefung> pruefungen = await getAllPruefung();

  if (pruefungen.isEmpty) {
    data.id = 1;
  } else {
    data.id = pruefungen.length + 1;
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref("Pruefung/${data.id}");

  try {
    await ref.set({
      "verantwortlicher": data.verantwortlicher,
      "groesse": data.groesse,
      "zeitraum": data.zeitraum,
      "datum": data.datum,
    });
    ready = true;
  } catch (e) {
    print(e);
    ready = false;
  }

  return ready;
}
