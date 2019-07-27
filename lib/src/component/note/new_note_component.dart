import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:firebase_firestore_ng/src/firebase_service.dart';
import 'package:firebase_firestore_ng/src/model/note.dart';

@Component(
    selector: 'new-note',
    templateUrl: 'new_note_component.html',
    directives: const [coreDirectives, formDirectives])
class NewNoteComponent {
  final FirebaseService service;
  Note note = new Note();
  bool fileDisabled = false;

  @ViewChild("submit")
  HtmlElement submitButton;

  NewNoteComponent(this.service);

  uploadImage(e) async {
    fileDisabled = true;
    var file = (e.target as FileUploadInputElement).files[0];
    var image = await service.postItemImage(file);

    note.imageUrl = image.toString();
  }

  removeImage() {
    service.removeItemImage(note.imageUrl);

    note.imageUrl = null;
    fileDisabled = false;
  }

  submitForm() {
    service.postItem(note);

    submitButton.blur();
    note = new Note();
    fileDisabled = false;
  }
}
