import 'package:angular/angular.dart';

import 'package:firebase_firestore_ng/src/firebase_service.dart';

@Component(
    selector: 'layout-header',
    templateUrl: 'header_component.html',
    directives: const [coreDirectives])
class HeaderComponent {
  final FirebaseService service;
  HeaderComponent(this.service);
}
