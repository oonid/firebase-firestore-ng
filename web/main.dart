import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart';

import 'package:firebase_firestore_ng/app_component.template.dart' as ng;

void main() {
  initializeApp(apiKey: "", authDomain: "", databaseURL: "", storageBucket: "");

  runApp(ng.AppComponentNgFactory);
}
