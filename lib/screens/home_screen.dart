import 'package:chatapp/helpers.dart';
import 'package:chatapp/pages/calls_page.dart';
import 'package:chatapp/pages/contacts_page.dart';
import 'package:chatapp/pages/message_page.dart';
import 'package:chatapp/pages/notifications_page.dart';
import 'package:chatapp/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:chatapp/app.dart';

class HomeScreen extends StatelessWidget{

  static Route get route => MaterialPageRoute(
    builder: (context) => HomeScreen(),
  );

  HomeScreen({Key?key}):super(key:key);

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier('Messages');

  final pages = const [
    MessagePage(),
    NotificationsPage(),
    CallsPage(),
    ContactsPage()
  ];

  final pageTitles = const [
    'Messages',
    'Notifications',
    'Calls',
    'Contacts'
  ];

  void _onNavigationItemSelected(index){
    title.value = pageTitles[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, String value, _) => Text(value),
        ),
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: Icons.search,
            onTap: (){
              logger.i('Todo search');
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Hero(
              tag: 'hero-profile-picture',
              child: Avatar.small(
                  url: context.currentUserImage,
                  onTap: () {
                    Navigator.of(context).push(ProfileScreen.route);
                  },
              ),
            ),
          )],
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _){
          return pages[value];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onItemSelected: _onNavigationItemSelected
      ),
    );
  }
}


class BottomNavigationBar extends StatefulWidget{
  const BottomNavigationBar({
    Key?key,
    required this.onItemSelected
  }):super(key:key);

  final ValueChanged<int> onItemSelected;

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index){
     setState(() {
       selectedIndex = index;
     });
     widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavigationBarItem(
                  index: 0,
                  label: 'Messages',
                  icon: CupertinoIcons.bubble_left_bubble_right_fill,
                  isSelected: (selectedIndex == 0),
                  onTap: handleItemSelected
                ),
                _NavigationBarItem(
                  index: 1,
                  label: 'Notifications',
                  icon: CupertinoIcons.bell_solid,
                  isSelected: (selectedIndex == 1),
                  onTap: handleItemSelected
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GlowingActionButton(
                      color: Color(0xFF3B76F6),
                      icon: CupertinoIcons.add,
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => const Dialog(
                            child: AspectRatio(
                                aspectRatio: 8 / 7,
                                child: ContactsPage(),
                            ),
                          )
                        );
                      }),
                ),
                _NavigationBarItem(
                  index: 2,
                  label: 'Calls',
                  icon: CupertinoIcons.phone_fill,
                  isSelected: (selectedIndex == 2),
                  onTap: handleItemSelected
                ),
                _NavigationBarItem(
                  index: 3,
                  label: 'Contacts',
                  icon: CupertinoIcons.person_2_fill,
                  isSelected: (selectedIndex == 3),
                  onTap: handleItemSelected
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget{
  const _NavigationBarItem({
    Key?key,
    required this.index,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }):super(key:key);

  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                icon,
                size: 20,
                color: isSelected ? Color(0xFF3B76F6) : null,
            ),
            const SizedBox(height: 8),
            Text(
                label,
                style: isSelected
                    ? const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B76F6)
                    )
                    : const TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}