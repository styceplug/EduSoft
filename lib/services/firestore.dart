import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  //get collection of notes
  final CollectionReference notes =
  FirebaseFirestore.instance.collection('notes');

  //CREATE: add a new note
  Future<void> addNote(String title,String note) {
    return notes.add({
      'title':title,
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //READ: get notes from database

  Stream<QuerySnapshot> getNotesStream() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();

    return noteStream;
  }

  //UPDATE: update notes given a doc id

  Future<void> updateNotes(String docID,String title, String newNote) {
    return notes.doc(docID).update(
        {'note': newNote,
          'title':title,
          'timestamp': Timestamp.now()});
  }

//DELETE: delete notes given a doc id
  Future<void> deleteNotes(String docID){
    return notes.doc(docID).delete();
  }

}