import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'avatar.dart';

class DrawerLayer extends StatefulWidget {
  final String filePath;
  final Function drawerState;
  final Function updatePath;
  final String imageKey;

  const DrawerLayer({
    super.key,
    required this.filePath,
    required this.updatePath,
    required this.drawerState,
    required this.imageKey,
  });

  @override
  State<DrawerLayer> createState() => _DrawerLayerState();
}

class _DrawerLayerState extends State<DrawerLayer> {
  String tempFilePath = ''; // when user not confirm

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Wrap(
                    spacing: 24, // horizontal spacing between avatars
                    runSpacing: 24, // vertical spacing between avatars
                    children: listPath.map((avatar) {
                      return IconButton(
                        icon: ClipOval(
                          child: Image.asset(
                            avatar.path,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              tempFilePath = avatar.path;
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    widget.drawerState();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 42,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (tempFilePath != '') {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(widget.imageKey, tempFilePath);
                      widget.updatePath(tempFilePath);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image is saved')));
                    } //save avatar for initialization
                  },
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.done,
                      size: 42,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
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
