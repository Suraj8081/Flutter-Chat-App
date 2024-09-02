import 'package:flutter/material.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:my_chat/screen/chat_screen.dart';
import 'package:my_chat/screen/profile_screen.dart';
import 'package:my_chat/screen/update_screen.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  int _selectedPosition = 0;

  void _onTap(index) {
    setState(() {
      _selectedPosition = index;
    });
  }

  Widget _setScreen(int index) {
    switch (index) {
      case 0:
        return const ChatScreen();
      case 1:
        return const UpdateScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const ChatScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _setScreen(_selectedPosition),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: getThemeColor(context).primary,
        selectedItemColor: getThemeColor(context).onPrimary,
        unselectedItemColor: Colors.grey[400],
        onTap: _onTap,
        currentIndex: _selectedPosition,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_outlined),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}
