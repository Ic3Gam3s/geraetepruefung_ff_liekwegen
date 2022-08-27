import 'package:firebase_database/firebase_database.dart';

class Bemerkung {
  int id;
  String bemerkung;
  int pruefungId;
  String pruefungZeitraum;
  String fragenBezeichnung;
  String status;

  Bemerkung(this.id, this.bemerkung, this.pruefungId, this.pruefungZeitraum,
      this.fragenBezeichnung, this.status);
}

Future<void> sendNewBemerkungen(List<Bemerkung> data) async {
  List<Bemerkung> oldBemerkung = [];
  int startnumber = 0;

  print(data.toString());

  try {
    oldBemerkung = await getAllBemerkungen();
  } catch (e) {
    oldBemerkung = [];
    // print(e);
  }

  if (oldBemerkung.isEmpty) {
    startnumber = 0;
  } else {
    startnumber = oldBemerkung.length;
  }

  //print(startnumber);

  int id = startnumber + 1;

  for (var i = 0; i < data.length; i++) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bemerkungen/${id}");
    print(i);
    try {
      await ref.set({
        "bemerkung": data[i].bemerkung,
        "pruefungId": data[i].pruefungId,
        "pruefungZeitraum": data[i].pruefungZeitraum,
        "fragenBezeichnung": data[i].fragenBezeichnung,
        "status": data[i].status,
      });

      id++;
    } catch (e) {
      print(e);
    }
  }
}

Future<List<Bemerkung>> getAllBemerkungen() async {
  List<Bemerkung> data = [];

  DatabaseReference ref = FirebaseDatabase.instance.ref('Bemerkungen/');
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
      Bemerkung bemerkung = Bemerkung(
          i,
          map[i]['bemerkung'],
          map[i]['pruefungId'],
          map[i]['pruefungZeitraum'],
          map[i]['fragenBezeichnung'],
          map[i]['status']);
      data.add(bemerkung);
    }
  } catch (e) {
    print(e);
  }

  //print(data);

  return data;
}

Future<List<Bemerkung>> getBemerkungenToPruefung(int pruefId) async {
  List<Bemerkung> data = [];

  data = await getAllBemerkungen();

  for (var i = 0; i < data.length - 1; i++) {
    if (data[i].pruefungId != pruefId) {
      data.removeAt(i);
    }
  }

  return data;
}

Future<void> updateBemerkung(Bemerkung data) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Bemerkungen/${data.id}");

  try {
    await ref.set({
      "bemerkung": data.bemerkung,
      "pruefungId": data.pruefungId,
      "pruefungZeitraum": data.pruefungZeitraum,
      "fragenBezeichnung": data.fragenBezeichnung,
      "status": data.status,
    });
  } catch (e) {
    print(e);
  }
}


