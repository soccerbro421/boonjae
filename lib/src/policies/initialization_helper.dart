import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iabtcf_consent_info/iabtcf_consent_info.dart';
import 'package:uuid/uuid.dart';

class InitializerHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveUsersPrivacy({required String preferences}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      Map<String, dynamic> json = {};
      json['consentInfo'] = preferences;
      json['date'] = DateTime.now();
      String consentId = const Uuid().v1();

      await _firestore
          .collection('GDPR-consent')
          .doc(currentUserId)
          .collection('myConsent')
          .doc(consentId)
          .set(json);

      return 'success';
    } catch (err) {
      return err.toString();
    }
  }

  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    // final params = ConsentRequestParameters();

    final params = ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
            debugGeography: DebugGeography.debugGeographyEea));

    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        await _loadForm();
        BasicConsentInfo? currentInfo =
            await IabtcfConsentInfo.instance.consentInfo().first;
        saveUsersPrivacy(preferences: currentInfo.toString());
      } else {
        await _initialize();
      }

      completer.complete();
    }, (error) {
      completer.complete(error);
    });

    return completer.future;
  }

  Future<bool> changePrivacyPreferences() async {
    final completer = Completer<bool>();

    ConsentInformation.instance
        .requestConsentInfoUpdate(ConsentRequestParameters(), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        ConsentForm.loadConsentForm((consentForm) {
          consentForm.show((formError) async {
            await _initialize();
            BasicConsentInfo? currentInfo =
                await IabtcfConsentInfo.instance.consentInfo().first;
            saveUsersPrivacy(preferences: currentInfo.toString());
            completer.complete(true);
          });
        }, (formError) {
          completer.complete(false);
        });
      } else {
        completer.complete(false);
      }
    }, (error) {
      completer.complete(false);
    });

    return completer.future;
  }

  Future<FormError?> _loadForm() {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show(
            (FormError? formError) {
              // Handle dismissal by reloading form
              completer.complete(_loadForm());
            },
          );
        } else {
          await _initialize();
          completer.complete();
        }
      },
      (FormError formError) {
        completer.complete(formError);
        // Handle the error
      },
    );

    return completer.future;
  }

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();
  }
}
