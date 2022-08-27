import 'package:firebase_database/firebase_database.dart';

class Frage {
  int id;
  String bezeichnung;
  //String Teil;
  bool gross;
  bool mittel;
  bool klein;

  Frage(this.id, this.bezeichnung,  this.gross, this.mittel,
      this.klein);
}

Future<List<Frage>> getAllFragen() async {
  List<Frage> data = [];

  DatabaseReference ref = FirebaseDatabase.instance.ref('Fragen/');
  Query query = ref.orderByKey();

  DataSnapshot snapshot;
  List<dynamic> map = [];

  try {
    snapshot = await query.get();
    map = snapshot.child('/').value as List<dynamic>;
  } catch (e) {
    print(e);
  }

  try {
    for (var i = 1; i < map.length; i++) {
      Frage frage = Frage(i, map[i]['bezeichnung'], map[i]['gross'], map[i]['mittel'], map[i]['klein']);
      data.add(frage);
    }
  } catch (e) {
    print(e);
  }

  //print(data);

  return data;
}

void setList(List<Frage> data) async {
  for (var i = 0; i <= data.length - 1; i++) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Fragen/${data[i].id}");

    try {
      await ref.set({
        "bezeichnung": data[i].bezeichnung,
        "gross": data[i].gross,
        "mittel": data[i].mittel,
        "klein": data[i].klein,
      });
    } catch (e) {
      print(e);
    }
  }
}
