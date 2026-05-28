import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  int hoveredCardIndex = -1;
  int hoveredCourseIndex = -1;

  int liveStreakCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 0.78,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //retrieve signed in users display name - if null, default = learner
    final currentUser = FirebaseAuth.instance.currentUser;
    final userName = currentUser?.displayName ?? "Learner";

    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;

    final horizontalPadding = isMobile
        ? 16.0
        : isTablet
            ? 20.0
            : 28.0;

    final sectionSpacing = isMobile ? 24.0 : 40.0;

    final titleSize = isMobile ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
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
                          const SizedBox(height: 10),
                          const Text(
                            "2,450 XP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Level 12 Learner 🚀",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  value: _animation.value,
                                  minHeight: 12,
                                  backgroundColor: Colors.white24,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "780 XP until Level 13",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// SECTION TITLE
                    Text(
                      "Your Progress",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PROGRESS CARDS
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildProgressCard(
                                icon: Icons.menu_book_rounded,
                                color: Colors.blue,
                                value: "12",
                                label: "Courses",
                              ),
                              const SizedBox(height: 20),
                              buildProgressCard(
                                icon: Icons.emoji_events,
                                color: Colors.orange,
                                value: "8",
                                label: "Badges",
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: buildProgressCard(
                                  icon: Icons.menu_book_rounded,
                                  color: Colors.blue,
                                  value: "12",
                                  label: "Courses",
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: buildProgressCard(
                                  icon: Icons.emoji_events,
                                  color: Colors.orange,
                                  value: "8",
                                  label: "Badges",
                                ),
                              ),
                            ],
                          ),

                    const SizedBox(height: 30),

                    /// DAILY STREAK
                        StreamBuilder<DocumentSnapshot>(
                          stream: currentUser != null
                              ? FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.uid)
                                  .snapshots()
                              : null,
                          builder: (context, snapshot) {
                            int streakCount = 0; // Changed to int for consistency

                            // Check if data is available and extract streak safely
                            if (snapshot.hasData && snapshot.data!.exists) {
                              final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                              // CHANGED: Matches 'currentStreak' from profile screen and expects an int
                              streakCount = data['currentStreak'] ?? 0; 

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted && liveStreakCount != streakCount) {
                                      setState(() {
                                        liveStreakCount = streakCount;
                                      });
                                    }
                                  });
                                }

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              // ... [rest of your container decoration remains the same]
                              child: isMobile
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 45),
                                        const SizedBox(height: 15),
                                        const Text(
                                          "Daily Streak",
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "$streakCount days in a row 🔥", // Injected the int seamlessly
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 45),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Daily Streak",
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "$streakCount days in a row 🔥", // Injected the int seamlessly
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            );
                          },
                        ),
                    const SizedBox(height: 30),

                    /// RECOMMENDED COURSES
                    Text(
                      "Recommended Courses",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildCourseCard(
                      index: 0,
                      title: "Flutter Development",
                      subtitle: "Build modern mobile applications",
                      progress: 0.7,
                      progressText: "70% Completed",
                      icon: Icons.code,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 20),

                    buildCourseCard(
                      index: 1,
                      title: "Cyber Security Basics",
                      subtitle: "Learn networking and cyber defense",
                      progress: 0.45,
                      progressText: "45% Completed",
                      icon: Icons.security,
                      color: Colors.orange,
                    ),

                    SizedBox(height: sectionSpacing),

                    /// RECENT ACTIVITY
                    Text(
                      "Recent Activity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildActivityCard(
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      title: "Completed Flutter Quiz",
                      subtitle: "You scored 92% on Widgets Basics",
                      time: "2 hours ago",
                    ),

                    const SizedBox(height: 15),

                    buildActivityCard(
                      icon: Icons.emoji_events,
                      iconColor: Colors.orange,
                      title: "New Badge Earned",
                      subtitle: "Consistency Master Badge unlocked",
                      time: "Yesterday",
                    ),

                    const SizedBox(height: 15),

                    buildActivityCard(
                                icon: Icons.local_fire_department,
                                iconColor: Colors.red,
                                title: "Daily Streak Updated",
                                subtitle: liveStreakCount > 0 
                                    ? "$liveStreakCount day learning streak maintained"
                                    : "Start your learning streak today!",
                                time: "Today",
                              ),

                              const SizedBox(height: 15),

                    const SizedBox(height: 15),

                    buildActivityCard(
                      icon: Icons.play_circle_fill,
                      iconColor: Colors.blue,
                      title: "Lesson Completed",
                      subtitle: "Finished State Management module",
                      time: "3 days ago",
                    ),

                    SizedBox(height: sectionSpacing),

                    /// ANALYTICS SECTION
                    Text(
                      "Learning Analytics",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    GridView.count(
                      crossAxisCount: isMobile ? 1 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isMobile ? 1.9 : 1.6,
                      children: [
                        buildAnalyticsCard(
                          title: "Study Hours",
                          value: "14h",
                          subtitle: "This Week",
                          icon: Icons.access_time,
                          color: Colors.blue,
                          index: 0,
                        ),
                        buildAnalyticsCard(
                          title: "Quiz Average",
                          value: "92%",
                          subtitle: "Excellent",
                          icon: Icons.bar_chart,
                          color: Colors.green,
                          index: 1,
                        ),
                        buildAnalyticsCard(
                          title: "Lessons Done",
                          value: "18",
                          subtitle: "Completed",
                          icon: Icons.check_circle,
                          color: Colors.orange,
                          index: 2,
                        ),
                        buildAnalyticsCard(
                          title: "Weekly Goals",
                          value: "4/5",
                          subtitle: "Almost There",
                          icon: Icons.flag,
                          color: Colors.purple,
                          index: 3,
                        ),
                      ],
                    ),

                    SizedBox(height: sectionSpacing),
                    SizedBox(height: sectionSpacing),

                    /// WEEKLY LEARNING CHART
                    Text(
                      "Weekly Learning Activity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      height: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: BarChart(
                        BarChartData(
                          backgroundColor: Colors.transparent,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.white12,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    "${value.toInt()}h",
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = [
                                    'M',
                                    'T',
                                    'W',
                                    'T',
                                    'F',
                                    'S',
                                    'S'
                                  ];

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      days[value.toInt()],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          maxY: 6,
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: 2,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: 4,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: 1,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: 5,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 4,
                              barRods: [
                                BarChartRodData(
                                  toY: 3,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 5,
                              barRods: [
                                BarChartRodData(
                                  toY: 2,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 6,
                              barRods: [
                                BarChartRodData(
                                  toY: 4,
                                  color: Colors.blue,
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCourseCard({
    required int index,
    required String title,
    required String subtitle,
    required double progress,
    required String progressText,
    required IconData icon,
    required Color color,
  }) {
    bool isHovered = hoveredCourseIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredCourseIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredCourseIndex = -1;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -8 : 0,
          0,
        ),
        width: double.infinity,
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width < 700 ? 16 : 20,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? color.withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.15),
              blurRadius: isHovered ? 20 : 0,
              spreadRadius: isHovered ? 2 : 0,
              offset: Offset(
                0,
                isHovered ? 10 : 4,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.white12,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              progressText,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isHovered ? 1.03 : 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Continue Learning",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 40,
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
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

  Widget buildActivityCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnalyticsCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    final bool isHovered = hoveredCardIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredCardIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredCardIndex = -1;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -6 : 0,
          0,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? color.withValues(alpha: 0.18)
                  : color.withValues(alpha: 0.12),
              blurRadius: isHovered ? 18 : 10,
              spreadRadius: isHovered ? 1 : 0,
              offset: Offset(
                0,
                isHovered ? 6 : 3,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
