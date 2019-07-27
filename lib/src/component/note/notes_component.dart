import 'package:angular/angular.dart';

import 'package:firebase_firestore_ng/src/firebase_service.dart';
import 'package:firebase_firestore_ng/src/model/note.dart';

@Component(
    selector: 'notes',
    templateUrl: 'notes_component.html',
    directives: const [coreDirectives])
class NotesComponent implements OnInit {
  final FirebaseService service;
  List<Note> notes = [];

  NotesComponent(this.service);

  @override
  ngOnInit() {
    notes = service.notes;
  }
}
