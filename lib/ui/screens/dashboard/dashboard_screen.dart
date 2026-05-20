import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  int hoveredCardIndex = -1;
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
    return Scaffold(
      backgroundColor: const Color(0xFF020B3A),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                /// HEADER
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

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
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF2563EB),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

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
                        borderRadius:
                            BorderRadius.circular(20),

                        child: AnimatedBuilder(
                          animation: _animation,

                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _animation.value,
                              minHeight: 12,
                              backgroundColor:
                                  Colors.white24,
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
                        padding:
                            const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF11162A),
                          borderRadius:
                              BorderRadius.circular(18),
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
                                fontWeight:
                                    FontWeight.bold,
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
                        padding:
                            const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF11162A),
                          borderRadius:
                              BorderRadius.circular(18),
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
                                fontWeight:
                                    FontWeight.bold,
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
                    borderRadius:
                        BorderRadius.circular(18),
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            "Daily Streak",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
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

                const SizedBox(height: 30),

                /// RECOMMENDED COURSES
                const Text(
                  "Recommended Courses",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                buildCourseCard(
                  title: "Flutter Development",
                  subtitle:
                      "Build modern mobile applications",
                  progress: 0.7,
                  progressText: "70% Completed",
                  icon: Icons.code,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                buildCourseCard(
                  title: "Cyber Security Basics",
                  subtitle:
                      "Learn networking and cyber defense",
                  progress: 0.45,
                  progressText: "45% Completed",
                  icon: Icons.security,
                  color: Colors.orange,
                ),

                const SizedBox(height: 40),

                /// RECENT ACTIVITY
                const Text(
                  "Recent Activity",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
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
                  subtitle: "7 day learning streak maintained",
                  time: "Today",
                ),

                const SizedBox(height: 15),

                buildActivityCard(
                  icon: Icons.play_circle_fill,
                  iconColor: Colors.blue,
                  title: "Lesson Completed",
                  subtitle: "Finished State Management module",
                  time: "3 days ago",
                ),

                const SizedBox(height: 40),

                /// ANALYTICS SECTION
                const Text(
                  "Learning Analytics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),

                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,

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

                const SizedBox(height: 40),
                const SizedBox(height: 40),

/// WEEKLY LEARNING CHART
const Text(
  "Weekly Learning Activity",
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

Container(
  height: 320,
  padding: const EdgeInsets.all(20),

  decoration: BoxDecoration(
    color: const Color(0xFF11162A),
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
    );
  }

Widget buildCourseCard({
  required String title,
  required String subtitle,
  required double progress,
  required String progressText,
  required IconData icon,
  required Color color,
}) {

  return StatefulBuilder(
    builder: (context, setHoverState) {

      bool isHovered = false;

      return MouseRegion(

        onEnter: (_) {
          setHoverState(() {
            isHovered = true;
          });
        },

        onExit: (_) {
          setHoverState(() {
            isHovered = false;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,

          transform: Matrix4.translationValues(
            0,
            isHovered ? -20 : 0,
            0,
          ),

          width: double.infinity,
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: const Color(0xFF11162A),
            borderRadius: BorderRadius.circular(18),

            boxShadow: [

              BoxShadow(
                color: isHovered
                    ? color.withOpacity(0.35)
                    : Colors.black.withOpacity(0.15),

                blurRadius: isHovered ? 60 : 10,
                spreadRadius: isHovered ? 8 : 1,

                offset: Offset(
                  0,
                  isHovered ? 10 : 4,
                ),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(14),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
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
                borderRadius:
                    BorderRadius.circular(20),

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
                  duration:
                      const Duration(milliseconds: 250),

                  scale: isHovered ? 1.06 : 1,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
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
    },
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
        color: const Color(0xFF11162A),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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
        isHovered ? -12 : 0,
        0,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF11162A),
        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(
            color: isHovered
                ? color.withOpacity(0.18)
                : color.withOpacity(0.12),

            blurRadius: isHovered ? 30 : 10,
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

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

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