import 'package:flutter/material.dart';

class FAQsPage extends StatefulWidget {
  @override
  _FAQsPageState createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  final black = const Color(0xFF000000);
  final mediumGray = const Color(0xFF8E8E93);
  final lightGray = const Color(0xFFF2F2F7);

  final TextEditingController _searchController = TextEditingController();

  // Expanded state tracking
  Map<String, bool> expanded = {};

  // Example FAQs data
  final List<Map<String, dynamic>> faqs = [
    {
      'category': 'General',
      'items': [
        {'q': 'What is the school timing?', 'a': 'School starts at 8 AM and ends at 2 PM.'},
        {'q': 'How to contact the administration?', 'a': 'You can contact via the official email or phone.'},
      ],
    },
    {
      'category': 'Fees',
      'items': [
        {'q': 'When is the fee due?', 'a': 'Fees are due by the 10th of each month.'},
        {'q': 'Can I pay online?', 'a': 'Yes, you can pay via our online payment portal.'},
      ],
    },
    {
      'category': 'Exams',
      'items': [
        {'q': 'When are the final exams?', 'a': 'Final exams are held in March every year.'},
        {'q': 'Is there a re-exam policy?', 'a': 'Yes, re-exams are available under specific conditions.'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'FAQs',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: black,
            fontFamily: 'SanFrancisco',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search FAQs',
                  hintStyle: TextStyle(color: mediumGray),
                  prefixIcon: Icon(Icons.search, color: black),
                  filled: true,
                  fillColor: lightGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: faqs.length,
                itemBuilder: (context, catIndex) {
                  final category = faqs[catIndex]['category'] as String;
                  final items = faqs[catIndex]['items'] as List<Map<String, String>>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sticky category header style
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      // List of questions under this category
                      ...items.map((faq) {
                        final key = faq['q']!;
                        final bool isExpanded = expanded[key] ?? false;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: black.withOpacity(0.1),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ExpansionTile(
                            key: PageStorageKey<String>(key),
                            initiallyExpanded: isExpanded,
                            title: Text(
                              faq['q']!,
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  faq['a']!,
                                  style: TextStyle(
                                    color: mediumGray,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                            onExpansionChanged: (val) {
                              setState(() {
                                expanded[key] = val;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
            // Submit a Question Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement submit a question
                  },
                  child: const Text(
                    'Submit a Question',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Helpful Links (bottom)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Divider(color: lightGray),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Terms of Service',
                      style: TextStyle(
                        color: black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
