import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020B3A),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// MAIN HEADER TITLE
              const Text(
                "Courses",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// LIVE FIREBASE DATA STREAM
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  // Connects to your live 'Courses' collection folder
                  stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
                  builder: (context, snapshot) {
                    
                    // A: While waiting for Firebase to respond, show a loading spinner
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.purple),
                      );
                    }

                    // B: If a connection error occurs, print a warning notice
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error loading data: ${snapshot.error}", 
                          style: const TextStyle(color: Colors.white)
                        ),
                      );
                    }

                    // C: Extract the matching data documents
                    final courseDocs = snapshot.data?.docs ?? [];

                    // D: If the collection is empty, display this notice
                    if (courseDocs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No courses found in database collection.", 
                          style: TextStyle(color: Colors.white60)
                        ),
                      );
                    }

                    /// 3-COLUMN TILE GRID
                    return GridView.builder(
                      itemCount: courseDocs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final document = courseDocs[index];
                        
                        // Pulls the 'title' string value from your console document view
                        final String courseName = document['title'] ?? 'Unnamed Course';

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF11162A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.purple,
                              width: 2.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              courseName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}
