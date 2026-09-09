import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/home_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "What are you\ncooking today?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const CustomSearchBar(),

              const SizedBox(height: 20),

              const HomeBanner(),
            ],
          ),
        ),
      ),
    );
  }
}