import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/constans/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/features/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  //String name = "";

  @override
  Widget build(BuildContext context) {
    /*print(MediaQuery.of(context).size);
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).orientation); // اتجاه الشاشة*/
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: Column(
          // or use ListView to use scrolling
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgPicture.withoutColor(
                  path: "assets/images/Vector.svg",
                  //colorFilter: Theme.of(context).primaryColor,
                  width: 42,
                  height: 42,
                ),
                //Image.asset("assets/images/Vector.png", height: 42, width: 42),
                SizedBox(width: 16),
                Text("Tasky", style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
            SizedBox(height: 116),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Tasky ",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    CustomSvgPicture.withoutColor(
                      path: "assets/images/waving-hand.svg",
                      //colorFilter: Color(0xFFFED0AC),
                      width: 28,
                      height: 28,
                    ),
                    /*Image.asset(
                      "assets/images/waving-hand-medium-light-skin-tone-svgrepo-com 1.png",
                      width: 28,
                      height: 28,
                    ),*/
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Your productivity journey starts here.",
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall!.copyWith(fontSize: 16),
                ),
                SizedBox(height: 24),
                CustomSvgPicture.withoutColor(
                  path: "assets/images/welcome.svg",
                  width: 215,
                  height: 205,
                ),

                SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      CustomTextFormField(
                        maxLines: 1,
                        controller: controller,
                        validator: (String? v) {
                          if (v == null || v.trim().isEmpty) {
                            return "please enter your full name";
                          }
                          if (v.trim().length > 25) {
                            return "Name must not exceed 25 characters";
                          } else {}
                          return null;
                        },
                        title: "Full Name",
                        hintText: "e.g. Yousif Hafiz",
                        fontSize: 16,
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          //print(controller.text);
                          //print(name);
                          if (_key.currentState?.validate() ?? false) {
                            await PreferencesManager().setString(
                              StorageKey.username,
                              controller.value.text,
                            );
                            /*final asyncPrefs = SharedPreferencesAsync();
                            await asyncPrefs.setString(
                              'username',
                              controller.value.text,
                            );*/
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          } else {
                            return;
                          }
                          /*ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 10,
                                content: Text("please enter your full name"),
                              ),
                            );
                          }*/
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            40,
                          ),

                          //fixedSize: Size(343, 43),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          "Let’s Get Started",
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style
                              ?.textStyle
                              ?.resolve({})
                              ?.copyWith(fontSize: 20),

                          //style: Theme.of(context).elevatedButtonTheme
                          /*TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),*/
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*class welcomeScreenTwo extends StatelessWidget {
  welcomeScreenTwo({super.key});

  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF181818),
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF181818),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/Vector.svg",
                        width: 375,
                        height: 45,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Tasky",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 28,
                          letterSpacing: 0.5,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 116),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Tasky ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          fontSize: 24,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      SvgPicture.asset("assets/images/waving-hand.svg"),
                    ],
                  ),
                  SizedBox(height: 8),

                  Text(
                    "Your productivity journey starts here.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 24),
                  SvgPicture.asset(
                    "assets/images/welcome.svg",
                    width: 215,
                    height: 205,
                  ),
                  SizedBox(height: 28),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Full Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: controller,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "inter your name";
                      }
                      return null;
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "e.g. Sarah Khalid",
                      hintStyle: TextStyle(
                        color: Color(0xFF6D6D6D),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Color(0xFF282828),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      // هنا تتحكم في شكل رسالة الخطأ
                      errorStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final sharedP = SharedPreferencesAsync();
                        sharedP.setString("username", controller.value.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreeanTwo(),
                          ),
                        );
                      }
                      if (controller.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your name")),
                        );
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF15B86C),
                      foregroundColor: Color(0xFFFFFCFC),
                      fixedSize: Size(MediaQuery.of(context).size.width, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(100),
                      ),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        wordSpacing: 8,
                      ),
                    ),
                    child: Text("Let’s Get Started"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
