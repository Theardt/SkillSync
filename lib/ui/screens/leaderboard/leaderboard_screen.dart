import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth < 700;

    final leaderboardUsers = [

      {
        "name": "De Bruyn",
        "xp": "2450 XP",
        "level": "Level 12",
        "rank": 1,
        "color": Colors.amber,
      },

      {
        "name": "Tristan",
        "xp": "2180 XP",
        "level": "Level 11",
        "rank": 2,
        "color": Colors.grey,
      },

      {
        "name": "Dominique",
        "xp": "2050 XP",
        "level": "Level 10",
        "rank": 3,
        "color": Colors.orange,
      },

      {
        "name": "Theardt",
        "xp": "1980 XP",
        "level": "Level 10",
        "rank": 4,
        "color": Colors.blue,
      },

      {
        "name": "Sarah",
        "xp": "1760 XP",
        "level": "Level 9",
        "rank": 5,
        "color": Colors.green,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
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
                children: [

                  Expanded(
                    child: PodiumCard(
                      rank: "#2",
                      name: leaderboardUsers[1]["name"] as String,
                      xp: leaderboardUsers[1]["xp"] as String,
                      color: Colors.grey,
                      height: 230,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: PodiumCard(
                      rank: "#1",
                      name: leaderboardUsers[0]["name"] as String,
                      xp: leaderboardUsers[0]["xp"] as String,
                      color: Colors.amber,
                      height: 270,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: PodiumCard(
                      rank: "#3",
                      name: leaderboardUsers[2]["name"] as String,
                      xp: leaderboardUsers[2]["xp"] as String,
                      color: Colors.orange,
                      height: 220,
                    ),
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

                  final isCurrentUser =
                      user["name"] == "De Bruyn";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppColors.card,

                      borderRadius:
                          BorderRadius.circular(20),

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
                            color: (user["color"] as Color)
                                .withValues(alpha: 0.15),

                            shape: BoxShape.circle,
                          ),

                          child: Center(
                            child: Text(
                              "#${user["rank"]}",
                              style: TextStyle(
                                color: user["color"] as Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        /// USER INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

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

                        /// XP
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,

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

                            const Row(
                              children: [

                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange,
                                  size: 18,
                                ),

                                SizedBox(width: 4),

                                Text(
                                  "7 Day Streak",
                                  style: TextStyle(
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
          color: color.withValues(alpha: 0.4),
          width: 2,
        ),
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          CircleAvatar(
            radius: 30,
            backgroundColor:
                color.withValues(alpha: 0.2),

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