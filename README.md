# boonjae

A new Flutter project.

## Firebase Firestore
```
Firestore-root
  |
  --- users (collection)
  |    |
  |    --- $userOneUid (document)
  |    |     |
  |    |     --- //User data
  |    |
  |    --- $userTwoUid (document)
  |    |     |
  |    |     --- //User data
 
  --- requests (collection)
       |
       --- $userOneUid (document)
       |     |
       |     --- ownRequests (map)
       |     |      |
       |     |      --- $userTwoUid
       |     |
       |     --- friendRequests (map)
       |     |      |
       |     |      --- $userThreeUid
       |     |             |
```

## VSCode
Install the Flutter package and Pubspec Assist

## Mobile App Setup
1. Install dependencies
    * flutter pub get
    * cd ios -> pod install

## Local Development Emulators
* Install java
* follow the steps here: https://firebase.google.com/codelabs/get-started-firebase-emulators-and-flutter#0 
* 

## Possible areas to use Cloud Functions
* deleting a user
* scheduled functions: https://firebase.google.com/docs/functions/schedule-functions?gen=2nd


## todo
* https://medium.com/flutter-community/build-a-custom-bottom-navigation-bar-in-flutter-with-animated-icons-from-rive-13651bc80629 


## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## Tips
* run ```dart fix --apply``` to allow dart to fix some issues

## Resources
* firebase.flutter.dev
* https://flutter.dev/docs
* [simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).
* authentication: https://firebase.google.com/docs/auth/flutter/email-link-auth 
* image memory: https://firebase.google.com/docs/storage/flutter/download-files
