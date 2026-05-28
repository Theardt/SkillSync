import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    
    // CHANGED: Moved user extraction up here to use it for the entire screen state
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // CHANGED: StreamBuilder now wraps the entire body instead of just the header.
        // This lets the statistics grid below dynamically read Firestore data.
        child: user == null
            ? const Center(
                child: Text("Not logged in", style: TextStyle(color: Colors.white)),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Error loading profile",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // Establish defaults if data fields aren't present yet
                  final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                  
                  final String name = data['name'] ?? user.displayName ?? 'No Name';
                  final String email = data['email'] ?? user.email ?? '';
                  
                  // CHANGED: Safely pull the current streak value from your database document
                  final int streakCount = data['currentStreak'] ?? 0;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white, size: 40),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        /// XP CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue,
                                AppColors.darkBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Current XP",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "2,450 XP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: const LinearProgressIndicator(
                                  value: 0.78,
                                  minHeight: 12,
                                  backgroundColor: Colors.white24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "780 XP until Level 13",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        /// STATS TITLE
                        const Text(
                          "Your Statistics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// STATS GRID
                        GridView.count(
                          crossAxisCount: isMobile ? 2 : 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                          children: [
                            const ProfileStatCard(
                              icon: Icons.menu_book,
                              value: "12",
                              label: "Courses",
                              color: Colors.blue,
                            ),
                            const ProfileStatCard(
                              icon: Icons.emoji_events,
                              value: "8",
                              label: "Badges",
                              color: Colors.orange,
                            ),
                            const ProfileStatCard(
                              icon: Icons.access_time,
                              value: "14h",
                              label: "Study Time",
                              color: Colors.green,
                            ),
                            
                            // CHANGED: Swapped out the static "7" value for your live streak string count
                            ProfileStatCard(
                              icon: Icons.local_fire_department,
                              value: streakCount.toString(),
                              label: "Streak",
                              color: Colors.red,
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        /// ACHIEVEMENTS TITLE
                        const Text(
                          "Achievements",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: const [
                            AchievementBadge(
                              title: "Flutter Beginner",
                              icon: Icons.code,
                              color: Colors.blue,
                            ),
                            AchievementBadge(
                              title: "Quiz Master",
                              icon: Icons.quiz,
                              color: Colors.orange,
                            ),
                            AchievementBadge(
                              title: "7 Day Streak",
                              icon: Icons.local_fire_department,
                              color: Colors.red,
                            ),
                            AchievementBadge(
                              title: "Fast Learner",
                              icon: Icons.bolt,
                              color: Colors.green,
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        /// ACTION BUTTONS
                        Column(
                          children: [
                            // CHANGED: Passed the required 'context' parameter down to all the buttons below
                            buildActionButton(
                              context: context,
                              icon: Icons.edit,
                              title: "Edit Profile",
                              onTap: () {
                                Navigator.pushNamed(context, '/edit_profile');
                              },
                            ),
                            const SizedBox(height: 15),
                            buildActionButton(
                              context: context,
                              icon: Icons.settings,
                              title: "Settings",
                              onTap: () {
                                // TODO: Add Settings navigation
                              },
                            ),
                            const SizedBox(height: 15),
                            buildActionButton(
                              context: context,
                              icon: Icons.logout,
                              title: "Logout",
                              color: Colors.red,
                              onTap: () async {
                                print("LOGOUT BUTTON PRESSED");
                                await FirebaseAuth.instance.signOut();
                                
                                // CHANGED: Added context.mounted check to securely prevent unmounted layout errors during async navigation routes
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  // CHANGED: Modified signature to include 'required BuildContext context' so it can communicate with navigator
  Widget buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color color = Colors.blue,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(icon, color: color),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
