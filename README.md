# AngularDart + Firebase Firestore = ♥ demo

The application is written in [AngularDart](https://angulardart.dev) and uses the [Firebase library](https://pub.dev/packages/firebase).

![Dart + Firebase App](https://github.com/oonid/firebase-firestore-ng/blob/master/app.png)

## Before running

### Your credentials

Before running the app, update the `web/main.dart` file with your Firebase project's credentials:

```dart
initializeApp(
      apiKey: "TODO",
      authDomain: "TODO",
      databaseURL: "TODO",
      projectId: "TODO",
      storageBucket: "TODO");
```

### Google login

Enable Google login in Firebase console under the `Authentication/Sign-in method`.

Setup [OAuth2 Consent Screen](https://console.developers.google.com/apis/credentials/consent).

### Database rules

Set database rules on who can access the database under the `Database/Rules`. More info on [Database rules](https://firebase.google.com/docs/database/security/).

For example:

```
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read;
      allow write: if request.auth != null;
    }
  }
}
```

### Storage rules

Set storage rules on who can access the storage under the `Storage/Rules`. More info on [Storage rules](https://firebase.google.com/docs/storage/security/).

For example:

```
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read;
      allow write: if request.auth != null;
    }
  }
}
```
