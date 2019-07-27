import 'dart:html';
import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

import 'package:firebase_firestore_ng/src/model/note.dart';

@Injectable()
class FirebaseService {
  final fb.Auth auth;
  final fs.CollectionReference databaseRef; // changed from fb.DatabaseReference
  final fb.StorageReference storageRef;
  final List<Note> notes = [];
  fb.User user;
  bool loading = true;

  FirebaseService()
      : auth = fb.auth(),
        // change fb.database().ref() to fb.firestore().collection()
        databaseRef = fb.firestore().collection("notes"),
        storageRef = fb.storage().ref("notes");

  init() {
    databaseRef.onSnapshot.listen((querySnapshot) {
      for (var change in querySnapshot.docChanges()) {
        var docSnapshot = change.doc;
        switch (change.type) {
          case "added": // substitute onChildAdded.listen()
            var val = docSnapshot.data();
            var item = Note(val[jsonTagText], val[jsonTagTitle],
                val[jsonTagImgUrl], docSnapshot.id);
            notes.insert(0, item);
            break;
          case "removed": // substitute onChildRemoved.listen()
            var val = docSnapshot.data();
            // Removes also the image from storage.
            var imageUrl = val[jsonTagImgUrl];
            if (imageUrl != null) {
              removeItemImage(imageUrl);
            }
            notes.removeWhere((n) => n.key == docSnapshot.id);
            break;
        }
      }
      loading = false; // substitute onValue.listen()
    });

    // Setups listening on the child_removed event on the database ref.
//    databaseRef.onChildRemoved.listen((e) {
//      fb.DataSnapshot data = e.snapshot;
//      var val = data.val();
//
//      // Removes also the image from storage.
//      var imageUrl = val[jsonTagImgUrl];
//      if (imageUrl != null) {
//        removeItemImage(imageUrl);
//      }
//      notes.removeWhere((n) => n.key == data.key);
//    });

    // Sets loading to true when path changes
//    databaseRef.onValue.listen((e) {
//      loading = false;
//    });

    // Sets user when auth state changes
    auth.onIdTokenChanged.listen((e) {
      user = e;
    });
  }

  // Pushes a new item as a Map to database.
  postItem(Note item) async {
    try {
      // substitute await databaseRef.push(Note.toMap(item)).future;
      await databaseRef.add(Map<String, dynamic>.from(Note.toMap(item)));
    } catch (e) {
      print("Error in writing to database: $e");
    }
  }

  // Removes item with a key from database.
  removeItem(String key) async {
    try {
      // substitute await databaseRef.child(key).remove();
      await databaseRef.doc(key).delete();
    } catch (e) {
      print("Error in deleting $key: $e");
    }
  }

  // Puts image into a storage.
  postItemImage(File file) async {
    try {
      var task = storageRef.child(file.name).put(file);
      task.onStateChanged
          .listen((_) => loading = true, onDone: () => loading = false);

      var snapshot = await task.future;
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error in uploading to storage: $e");
    }
  }

  // Removes image with an imageUrl from the storage.
  removeItemImage(String imageUrl) async {
    try {
      var imageRef = fb.storage().refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
      print("Error in deleting $imageUrl: $e");
    }
  }

  // Signs in with the Google auth provider.
  signInWithGoogle() async {
    var provider = new fb.GoogleAuthProvider();
    try {
      await auth.signInWithPopup(provider);
    } catch (e) {
      print("Error in sign in with Google: $e");
    }
  }

  signOut() async {
    await auth.signOut();
  }
}
