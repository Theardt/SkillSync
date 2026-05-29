import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../helpers/level_calculator.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('xp', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No learners found yet. Be the first! 🚀",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            // Map Firestore documents to compounding LevelData entities
            final leaderboardUsers = docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final xpVal = data['xp'] ?? 0;
              final streakVal = data['currentStreak'] ?? 0;
              final levelData = LevelCalculator.calculate(xpVal);
              return {
                "uid": doc.id,
                "name": data['name'] ?? 'Anonymous',
                "xp": "$xpVal XP",
                "xpNum": xpVal,
                "level": "Level ${levelData.level}",
                "streak": streakVal,
              };
            }).toList();

            // Safe rank bounds checks
            final hasRank1 = leaderboardUsers.isNotEmpty;
            final hasRank2 = leaderboardUsers.length > 1;
            final hasRank3 = leaderboardUsers.length > 2;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  const Text(
                    "Leaderboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Top learners competing this week 🚀",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 35),

                  /// TOP 3 PODIUM
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // RANK 2 (Silver - Left)
                      Expanded(
                        child: hasRank2
                            ? PodiumCard(
                                rank: "#2",
                                name: leaderboardUsers[1]["name"] as String,
                                xp: leaderboardUsers[1]["xp"] as String,
                                color: Colors.grey,
                                height: 230,
                              )
                            : const EmptyPodiumCard(rank: "#2", height: 230),
                      ),
                      const SizedBox(width: 16),

                      // RANK 1 (Gold - Center)
                      Expanded(
                        child: hasRank1
                            ? PodiumCard(
                                rank: "#1",
                                name: leaderboardUsers[0]["name"] as String,
                                xp: leaderboardUsers[0]["xp"] as String,
                                color: Colors.amber,
                                height: 270,
                              )
                            : const EmptyPodiumCard(rank: "#1", height: 270),
                      ),
                      const SizedBox(width: 16),

                      // RANK 3 (Bronze - Right)
                      Expanded(
                        child: hasRank3
                            ? PodiumCard(
                                rank: "#3",
                                name: leaderboardUsers[2]["name"] as String,
                                xp: leaderboardUsers[2]["xp"] as String,
                                color: Colors.orange,
                                height: 220,
                              )
                            : const EmptyPodiumCard(rank: "#3", height: 220),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  /// RANKING TITLE
                  const Text(
                    "Global Rankings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// RANKING LIST
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leaderboardUsers.length,
                    itemBuilder: (context, index) {
                      final user = leaderboardUsers[index];
                      final isCurrentUser = currentUser?.uid == user["uid"];

                      // Color indicators for ranks
                      Color rankColor;
                      if (index == 0) {
                        rankColor = Colors.amber;
                      } else if (index == 1) {
                        rankColor = Colors.grey;
                      } else if (index == 2) {
                        rankColor = Colors.orange;
                      } else {
                        rankColor = Colors.blue;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: isCurrentUser
                              ? Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            /// RANK
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: rankColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "#${index + 1}",
                                  style: TextStyle(
                                    color: rankColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),

                            /// USER INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    user["name"] as String,
                                    maxLines: 1,
                                    minFontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user["level"] as String,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// XP & STATIC STREAK (Streak remains static)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  user["xp"] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${user["streak"]} Day Streak",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
}

class PodiumCard extends StatelessWidget {
  final String rank;
  final String name;
  final String xp;
  final Color color;
  final double height;

  const PodiumCard({
    super.key,
    required this.rank,
    required this.name,
    required this.xp,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              Icons.person,
              color: color,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            rank,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            name,
            maxLines: 1,
            minFontSize: 8,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            xp,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyPodiumCard extends StatelessWidget {
  final String rank;
  final double height;

  const EmptyPodiumCard({
    super.key,
    required this.rank,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white10,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white10,
            child: const Icon(
              Icons.person_outline,
              color: Colors.white24,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            rank,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Empty",
            style: TextStyle(
              color: Colors.white30,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
