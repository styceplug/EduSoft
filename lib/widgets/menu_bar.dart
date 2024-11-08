import 'package:flutter/material.dart';
import 'package:school_management/screens/main_screens/assignment_screen.dart';
import 'package:school_management/screens/main_screens/home_screen.dart';
import 'package:school_management/screens/main_screens/chat_screen.dart';
import 'package:school_management/screens/main_screens/profile_screen.dart';
import 'package:school_management/screens/main_screens/users_screen.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/dimensions.dart';
import 'package:iconsax/iconsax.dart';

class FloatingBar extends StatefulWidget {
  const FloatingBar({super.key});

  @override
  State<FloatingBar> createState() => _FloatingBarState();
}

class _FloatingBarState extends State<FloatingBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(child: HomeScreen()),
    const Center(child: ChatScreen()),
    const Center(child: AssignmentScreen()),
    const Center(child: UsersScreen()),
    const Center(child: ProfileScreen()),
  ];

  final List<String> screenName = [
    'Home',
    'Chat',
    'Assig\nnment',
    'Users',
    'Profile',
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _screens[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              height: Dimensions.height50+Dimensions.height30,
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: Dimensions.radius10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Navigation bar background with inactive items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavItem(Iconsax.home, 0),
                      _buildNavItem(Iconsax.message, 1),
                      _buildNavItem(Iconsax.note, 2),
                      _buildNavItem(Iconsax.user, 3),
                      _buildNavItem(Iconsax.menu, 4),
                    ],
                  ),

                  // Active item floating out of the container
                  if (_currentIndex == 0)
                    Positioned(
                      left: Dimensions.width30,
                      bottom: Dimensions.height15,
                      child: _buildActiveNavItem(Iconsax.home),
                    ),
                  if (_currentIndex == 1)
                    Positioned(
                      left: Dimensions.width40 * 2.4,
                      bottom: Dimensions.height15,
                      child: _buildActiveNavItem(Iconsax.message),
                    ),
                  if (_currentIndex == 2)
                    Positioned(
                      right: Dimensions.width167 - Dimensions.width5,
                      bottom: Dimensions.height15,
                      child: _buildActiveNavItem(Iconsax.note),
                    ),
                  if (_currentIndex == 3)
                    Positioned(
                      right: Dimensions.width40 * 2.4,
                      bottom: Dimensions.height15,
                      child: _buildActiveNavItem(Iconsax.user),
                    ),
                  if (_currentIndex == 4)
                    Positioned(
                      right: Dimensions.width30,
                      bottom: Dimensions.height15,
                      child: _buildActiveNavItem(Iconsax.menu),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //inactiveIcon
  Widget _buildNavItem(IconData icon, int index) {
    bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Icon(
          icon,
          size: 24,
          color: isActive
              ? Colors.transparent
              : Colors.grey, // Transparent icon for active item
        ),
      ),
    );
  }

  // activeIcon
  Widget _buildActiveNavItem(IconData icon) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: Dimensions.height65,
          width: Dimensions.width50+Dimensions.width10,
          decoration: BoxDecoration(
            color: AppColors.primaryColor, // Active item background color
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.4),
                blurRadius: Dimensions.radius10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: Dimensions.iconSize30,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: Dimensions.height5),
        Text(screenName[_currentIndex],style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w600),)
      ],
    );
  }
}
