import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';

import '../../core/constans/storage_key.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({
    super.key,
    required this.userName,
    required this.motivationQuote,
  });

  final String? userName;
  final String? motivationQuote;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController userNameController = TextEditingController();

  late final TextEditingController motivationQuoteController;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.userName!;
    motivationQuoteController = TextEditingController(
      text: widget.motivationQuote,
    );
  }

  //final String? userName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          
          child: Column(
            children: [
              CustomTextFormField(
                controller: userNameController,
                title: "User Details",
                hintText: 'yousif hafiz',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your name";
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: motivationQuoteController,
                title: "Motivation Quote",
                hintText: 'One task at a time. One step closer.',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Motivation Quote";
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    /*final pref = SharedPreferencesAsync();
                    await pref.setString(
                      "username",
                      userNameController.value.text,
                    );*/
                    await PreferencesManager().setString(
                      StorageKey.username,
                      userNameController.value.text,
                    );
                    await PreferencesManager().setString(
                      StorageKey.motivationQuote,
                      motivationQuoteController.value.text,
                    );
                    /*await pref.setString(
                      "motivation_quote",
                      motivationQuoteController.value.text,
                    );*/
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
