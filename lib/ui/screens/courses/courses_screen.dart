import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants/app_colors.dart'; 

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

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
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;

    final horizontalPadding = isMobile ? 16.0 : isTablet ? 20.0 : 28.0;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   
                  Text(
                    "Available Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize + 6, // 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  /// LIVE FIREBASE DATA STREAM
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
                      builder: (context, snapshot) {
                        
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue, // 
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              "Error loading courses", 
                              style: TextStyle(color: Colors.white70)
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "No courses found.", 
                              style: TextStyle(color: Colors.white70)
                            ),
                          );
                        }

                        final courses = snapshot.data!.docs;

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final courseData = courses[index].data() as Map<String, dynamic>;
                            final title = courseData['title'] ?? 'Untitled Course';
                            final description = courseData['description'] ?? 'No description available.';

                            // Course card container designed like your progress cards
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue.withOpacity(0.3), // Sleek transparent dark fill
                                borderRadius: BorderRadius.circular(20), // Matches your app radius
                                border: Border.all(
                                  color: AppColors.primaryBlue.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                                    child: const Icon(
                                      Icons.menu_book_rounded, // Cloned icon style
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          description,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white38,
                                    size: 16,
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
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
