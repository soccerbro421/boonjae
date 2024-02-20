import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/services/report_service.dart';
import 'package:flutter/material.dart';

class ReportPostView extends StatefulWidget {
  final PostModel post;

  const ReportPostView({
    super.key,
    required this.post,
  });

  @override
  _ReportPostViewState createState() => _ReportPostViewState();
}

class _ReportPostViewState extends State<ReportPostView> {
  String selectedReason = '';
  TextEditingController otherReasonController = TextEditingController();

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Report')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // List of reporting reasons
              for (String reason in ['Bullying', 'Hateful', 'Nudity', 'Other'])
                ListTile(
                  title: Text(reason),
                  leading: Radio<String>(
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value!;
                      });
                    },
                  ),
                ),

              // Text box for the "Other" option
              if (selectedReason == 'Other')
                TextFormField(
                  controller: otherReasonController,
                  decoration:
                      const InputDecoration(labelText: 'Type your reason'),
                ),

              SizedBox(height: 30),
              // Submit button
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  
                  if (selectedReason == 'Other') {
                    selectedReason = otherReasonController.text;
                  }
             
                  String res = await ReportService().reportPost(post: widget.post, reason: selectedReason);
                  showSnackBar(res);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
