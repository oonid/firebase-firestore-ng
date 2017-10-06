import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../firebase_service.dart';
import '../../model/note.dart';

@Component(
    selector: 'new-note',
    templateUrl: 'new_note_component.html',
    directives: const [CORE_DIRECTIVES, formDirectives])
class NewNoteComponent {
  final FirebaseService service;

  Note note;

  @ViewChild("submit")
  ElementRef submitButton;


  bool fileDisabled = false;

  NewNoteComponent(this.service) : this.note = new Note();

  uploadImage(e) async {
    //TODO spinner
    // spinner.classes.add("is-active");
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

    submitButton.nativeElement.blur();
    note = new Note();
  }
}
