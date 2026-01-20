import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/constans/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/main.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';

import 'user_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  bool isLoading = true;

  //File? _selectedImage;
  String? userImagePath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      username = PreferencesManager().getString('StorageKey.username') ?? '';
      motivationQuote =
          PreferencesManager().getString('motivation_quote') ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString("user_image");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              Center(
                child: Text(
                  "My Profile",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      // we can use Positioned (only with stack)
                      children: [
                        CircleAvatar(
                          backgroundImage: userImagePath == null
                              ? AssetImage("assets/images/joe.jpg")
                              : FileImage(File(userImagePath!)),
                          radius: 60,
                          backgroundColor: Colors.transparent,
                        ),
                        GestureDetector(
                          onTap: () async {
                            _showImageSourceDialog(
                              context: context,
                              selectedFile: (XFile file) {
                                _saveImage(file);
                                setState(() {
                                  userImagePath = file.path;
                                });
                              },
                            );
                            // XFile? image = await ImagePicker().pickImage(
                            //   source: ImageSource.gallery,
                            // );
                            // if (image != null) {
                            //   setState(() {
                            //     _selectedImage = File(image.path);
                            //   });
                            //   //print("your image path is: ${image.path}");
                            // }
                            //_showButtonSheet(context);
                            //_showDateTime(context);
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ThemeController.isLight()
                                    ? Color(0xFFD1DAD6)
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                            ),
                            child: Icon(Icons.camera_alt_outlined, size: 26),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      username,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    SizedBox(height: 4),
                    Text(
                      motivationQuote,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Profile Info",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(height: 16),
              ListTile(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UserDetailsScreen(
                        userName: username,
                        motivationQuote: motivationQuote,
                      ),
                    ),
                  );
                  if (result != null && result) {
                    _loadData();
                  }
                },
                contentPadding: EdgeInsets.zero,
                leading: CustomSvgPicture(
                  path: "assets/images/ProfileIcon.svg",
                  colorFilter: Theme.of(context).colorScheme.secondaryFixed,
                  width: 24,
                  height: 24,
                ),
                title: Text("User Details"),
                trailing: CustomSvgPicture(
                  path: "assets/images/arrow.svg",
                  colorFilter: Theme.of(context).colorScheme.secondary,
                  width: 14,
                  height: 14,
                ),
              ),
              Divider(thickness: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CustomSvgPicture(
                  path: "assets/images/moonThemeChange.svg",
                  colorFilter: Theme.of(context).colorScheme.secondaryFixed,
                  width: 24,
                  height: 24,
                ),
                title: Text("Dark Mode"),
                trailing: ValueListenableBuilder(
                  valueListenable: ThemeController.themeNotifier,
                  builder: (BuildContext context, value, Widget? child) {
                    return Switch(
                      //activeTrackColor: Color(0xFF15B86C),
                      value: value == ThemeMode.dark,
                      onChanged: (bool value) async {
                        /// TODO CHANGE THEME
                        await ThemeController.toggleTheme();
                      },
                    );
                  },
                ),
              ),
              Divider(thickness: 1),
              ListTile(
                onTap: () {
                  /// TODO LOG OUT
                  PreferencesManager().remove(StorageKey.username);
                  PreferencesManager().remove("motivation_quote");
                  PreferencesManager().remove("tasks");
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                contentPadding: EdgeInsets.zero,
                leading: CustomSvgPicture(
                  width: 24,
                  height: 24,
                  path: "assets/images/log_out.svg",
                  colorFilter: Theme.of(context).colorScheme.secondaryFixed,
                ),
                title: Text("Log Out"),
                trailing: CustomSvgPicture(
                  path: "assets/images/arrow.svg",
                  colorFilter: Theme.of(context).colorScheme.secondary,
                  width: 14,
                  height: 14,
                ),
              ),
            ],
          );
  }

  void _saveImage(XFile file) async {
    // print(await getApplicationDocumentsDirectory());
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString("user_image", newFile.path);
    // print('${appDir.path}');
    // print('${file.path}');
    // print('${file.name}');
  }
}

void _showImageSourceDialog({
  required BuildContext context,
  required Function(XFile) selectedFile,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Center(
          child: Text(
            "Choose Image Source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                selectedFile(image);
                Navigator.pop(context);

                // setState(() {
                //   _selectedImage = File(image.path);
                // });
                //print("your image path is: ${image.path}");
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text("Camera"),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                selectedFile(image);
                Navigator.pop(context);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo),
                SizedBox(width: 8),
                Text("Gallery"),
              ],
            ),
          ),
        ],
      );
    },
  );
}

/*void _showDateTime(BuildContext context) async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    //lastDate: DateTime(2026, 10),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );
  print(selectedDate);
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: 12, minute: 15),
  );
  print("your selected time: $time");
}*/

//   _showButtonSheet(BuildContext context) {
//     return showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.9,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     color: Colors.red,
//                     width: MediaQuery.of(context).size.width,
//                     height: 50,
//                   ),
//                 );
//               },
//               itemCount: 3,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

/*
  _showButtonSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          initialChildSize: 0.5,
         expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                  ),
                );
              },
              controller: scrollController,
              itemCount: 3,
            );
          },
        );
      },
    );
  }
}
*/
