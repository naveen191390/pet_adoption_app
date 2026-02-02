import 'package:flutter/material.dart';
import 'package:pet_app/view/home.dart';
import 'package:pet_app/view/adopt.dart';
import 'package:pet_app/view/myadptn.dart';

class BottomNavvv extends StatefulWidget {
  const BottomNavvv({super.key});

  @override
  State<BottomNavvv> createState() => _BottomNavvvState();
}

class _BottomNavvvState extends State<BottomNavvv> {
  int currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> pages = [
    const Adoptt(),
    const PetListScreen(),
    const MyAdoptionsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 70,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1E1E1E),
                selectedItemColor: Colors.amberAccent,
                unselectedItemColor: Colors.grey,
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() => currentIndex = index);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pets_rounded),
                    label: 'Adopt',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_rounded),
                    label: 'My Adoptions',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
