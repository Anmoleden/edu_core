import 'package:flutter/material.dart';
class ResourcesPage extends StatefulWidget {
  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final black = Color(0xFF000000);
  final mediumGray = Color(0xFF8E8E93);
  final lightGray = Color(0xFFF2F2F7);

  String selectedCategory = 'All';
  final categories = ['All', 'Books', 'Videos', 'Docs'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Resources',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: mediumGray),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search resources',
                          hintStyle: TextStyle(color: mediumGray),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Tabs (Scrollable)
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: mediumGray.withOpacity(0.3), width: 1),
                ),
                color: Colors.white,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = categories[index] == selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = categories[index]),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? black : Colors.white,
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : mediumGray,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            // Resource Cards list (placeholder)
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    shadowColor: black.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file, color: mediumGray),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Resource Title $index',
                                    style: TextStyle(
                                        color: black, fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text('Description or Grade',
                                    style: TextStyle(color: mediumGray, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.bookmark_border, color: mediumGray),
                            onPressed: () {},
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Download', style: TextStyle(color: black)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
