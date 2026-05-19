import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020B3A),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: const [

                      Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "De Bruyn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,

                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// XP CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF2563EB),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [

                    Text(
                      "Current XP",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "2,450 XP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Level 12 Learner 🚀",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// SECTION TITLE
              const Text(
                "Your Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// PROGRESS CARDS
              Row(
                children: [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFF11162A),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        children: const [

                          Icon(
                            Icons.menu_book_rounded,
                            color: Colors.blue,
                            size: 40,
                          ),

                          SizedBox(height: 15),

                          Text(
                            "12",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Courses",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFF11162A),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        children: const [

                          Icon(
                            Icons.emoji_events,
                            color: Colors.orange,
                            size: 40,
                          ),

                          SizedBox(height: 15),

                          Text(
                            "8",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Badges",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// DAILY STREAK
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF11162A),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: const [

                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 45,
                    ),

                    SizedBox(width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Daily Streak",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "7 days in a row 🔥",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}