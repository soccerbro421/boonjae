import 'package:boonjae/src/policies/initialization_helper.dart';
import 'package:flutter/material.dart';
import 'package:iabtcf_consent_info/iabtcf_consent_info.dart';

class EditPrivacyView extends StatefulWidget {
  const EditPrivacyView({super.key});

  @override
  State<EditPrivacyView> createState() => _EditPrivacyViewState();
}

class _EditPrivacyViewState extends State<EditPrivacyView> {
  late Stream<BasicConsentInfo?> consentInfoStream;

  final _initializationHelper = InitializerHelper();


  @override
  void initState() {
    consentInfoStream = IabtcfConsentInfo.instance.consentInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('edit privacy')),
      body: StreamBuilder<BasicConsentInfo?>(
        stream: consentInfoStream,
        builder: (context, snapshot) => Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  snapshot.hasData
                      ? snapshot.data.toString()
                      : snapshot.hasError
                          ? 'Error: ${snapshot.error}'
                          : 'Loading...',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('click me to update'),
                onPressed: () async {
                  final scaffoldMessanger = ScaffoldMessenger.of(context);

                  final didChangePreferences =
                      await _initializationHelper.changePrivacyPreferences();
                  
                  
                  // String res = '';
                  // if (didChangePreferences) {
                  //   res = await InitializerHelper().saveUsersPrivacy(preferences: snapshot.data.toString());
                  // }

                  

                  scaffoldMessanger.showSnackBar(
                    SnackBar(
                      content: Text(didChangePreferences
                          ? 'Your preferences have been updated'
                          : 'no updates'),
                    ),
                  );


                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
