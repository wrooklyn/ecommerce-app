
import 'package:ecommerce/pages/cart/cart.dart';
import 'package:ecommerce/pages/home/main_food_page.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex=0;

  List pages=[
    MainFoodPage(),
    Container(child: Center(child: Text("Next page"))),
    CartPage(prevPage:"screen",),
    Container(child: Center(child: Text("Next next next page")))

  ];

  void onTapNav(int index){
    setState(() {
      _selectedIndex=index;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 240, 238, 238),
                blurRadius: 4,
                offset: Offset(0,-2)
              ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: const Color.fromARGB(255, 225, 224, 224),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0,
          currentIndex: _selectedIndex,
          onTap: onTapNav,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: Dimensions.iconSize24*1.3),
              label: "home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined, size: Dimensions.iconSize24*1.3),
              label: "history"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: Dimensions.iconSize24*1.3),
              label: "cart"
            ), 
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: Dimensions.iconSize24*1.3),
              label: "profile"
            )
          ]
        ),
      )
    );
  }
}