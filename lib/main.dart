import 'dart:async';
import 'dart:io';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream/stream.dart';
import 'package:stream/image_controller.dart';
import 'package:stream/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;
  String filePath = 'null';

  @override
  Widget build(BuildContext context) {
    final lightThemeSurface = Colors.lightBlueAccent.shade400;
    final darkThemeSurface = Colors.blueGrey.shade500;
    final darkTheme = Colors.grey.shade900;
    final lightTheme = Colors.grey.shade300;
    final lightThemeTextColor = Colors.grey.shade900;
    final darkThemeTextColor = Colors.grey.shade300;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'video Stream',
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: isDarkTheme ? darkThemeSurface : lightThemeSurface,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            iconSize: 30),
        snackBarTheme: SnackBarThemeData(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          insetPadding: const EdgeInsets.all(16),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isDarkTheme
              ? lightTheme.withOpacity(0.7)
              : darkTheme.withOpacity(0.7),
          contentTextStyle: GoogleFonts.abyssinicaSil(
            color: isDarkTheme ? lightThemeTextColor : darkThemeTextColor,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme ? darkThemeSurface : lightThemeSurface,
          shape: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              borderSide: BorderSide.none),
        ),
        scaffoldBackgroundColor: isDarkTheme ? darkTheme : lightTheme,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.cabin(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? darkThemeTextColor : lightThemeTextColor),
          headlineMedium: GoogleFonts.pacifico(
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: isDarkTheme ? darkThemeTextColor : lightThemeTextColor),
          headlineSmall: GoogleFonts.cabin(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDarkTheme ? darkThemeTextColor : lightThemeTextColor),
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        isDark: isDarkTheme,
        toggleTheme: () {
          setState(() {
            isDarkTheme = !isDarkTheme;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool isDark;
  final Function() toggleTheme;

  const MyHomePage(
      {super.key, required this.isDark, required this.toggleTheme});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController userID = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController liveID = TextEditingController();
  String filePath = '';
  String imageKey = 'imagePath';
  bool drawerState = false;

  @override
  void initState() {
    super.initState();
    initialization();
    // _requestPermissions();
  }

  void _updateImage(String newPath) {
    setState(() {
      filePath = newPath;
    });
  }

  void _updateState() {
    setState(() {
      drawerState = !drawerState;
    });
  }

  Future<void> initialization() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(imageKey);
    if (imagePath != null) {
      setState(() {
        filePath = imagePath;
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Video Streaming',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            IconButton(
              icon: Icon(
                widget.isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).textTheme.headlineMedium?.color,
              ),
              onPressed: widget.toggleTheme, // change theme light/dark
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, bottom: 82),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: filePath != ''
                            ? ClipOval(
                                child: filePath.contains(
                                        'assets') // to detect read from storage/assets
                                    ? Image.asset(
                                        filePath,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(filePath),
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.fill,
                                      ),
                              )
                            : null),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14),
                      controller: userID,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'userID',
                        labelStyle: Theme.of(context).textTheme.headlineMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: userName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'user Name',
                        labelStyle: Theme.of(context).textTheme.headlineMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 14),
                      controller: liveID,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'liveID',
                        labelStyle: Theme.of(context).textTheme.headlineMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        _requestPermissions() ;
                        if (userID.text != '' &&
                            userName.text != '' &&
                            liveID.text != '') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Stream(
                                  filePath: filePath,
                                  username: userName.text,
                                  userID: userID.text,
                                  isHost: true,
                                );
                              },
                            ),
                          );
                        } else {
                          _showSnackBar(context, 'fill user ID and user name');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).appBarTheme.backgroundColor ??
                              Colors.transparent,
                        ),
                      ),
                      child: Text(
                        'host',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        _requestPermissions() ;
                        if (userID.text != '' &&
                            userName.text != '' &&
                            liveID.text != '') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Stream(
                                  filePath: filePath,
                                  username: userName.text,
                                  userID: userID.text,
                                  isHost: false,
                                );
                              },
                            ),
                          );
                        } else {
                          _showSnackBar(context, 'fill user ID and user name');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).appBarTheme.backgroundColor ??
                              Colors.transparent,
                        ),
                      ),
                      child: Text(
                        'join',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            drawerState
                ? DrawerLayer(
                    imageKey: imageKey,
                    drawerState: _updateState,
                    filePath: filePath,
                    updatePath: _updateImage,
                  )
                : CircularMenu(
                    toggleButtonAnimatedIconData: AnimatedIcons.add_event,
                    toggleButtonColor:
                        Theme.of(context).appBarTheme.backgroundColor ??
                            Colors.transparent,
                    animationDuration: const Duration(seconds: 1),
                    radius: MediaQuery.of(context).size.width / 5,
                    toggleButtonSize: 28,
                    items: [
                      CircularMenuItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ImageManager(
                                    imageKey: imageKey,
                                    isCamera: false,
                                    isLoad: false,
                                    updateImage: _updateImage,
                                  );
                                },
                              ),
                            );
                          },
                          icon: Icons.image_search,
                          color: Colors.purple,
                          boxShadow: const [
                            BoxShadow(blurRadius: 10, color: Colors.purple)
                          ]),
                      CircularMenuItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ImageManager(
                                    imageKey: imageKey,
                                    isCamera: true,
                                    isLoad: false,
                                    updateImage: _updateImage,
                                  );
                                },
                              ),
                            );
                          },
                          icon: Icons.camera,
                          color: Colors.lightBlueAccent.shade400,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.lightBlueAccent.shade400)
                          ]),
                      CircularMenuItem(
                        icon: Icons.emoji_emotions_outlined,
                        onTap: () {
                          _updateState();
                        },
                        color: Colors.greenAccent,
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, color: Colors.greenAccent)
                        ],
                      ),
                    ],
                    alignment: Alignment.bottomLeft,
                  ),
          ],
        ),
      ),
    );
  }
}
