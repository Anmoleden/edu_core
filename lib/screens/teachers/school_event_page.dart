import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'event_category_filter.dart';
import 'event_details_page.dart';

class Event {
  final String title;
  final String location;
  final DateTime dateTime;
  final String category;
  final bool isBookmarked;

  Event({
    required this.title,
    required this.location,
    required this.dateTime,
    required this.category,
    this.isBookmarked = false,
  });

  Event copyWith({bool? isBookmarked}) {
    return Event(
      title: title,
      location: location,
      dateTime: dateTime,
      category: category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class SchoolEventPage extends StatefulWidget {
  @override
  _SchoolEventPageState createState() => _SchoolEventPageState();
}

class _SchoolEventPageState extends State<SchoolEventPage> {
  final Color black = Color(0xFF000000);
  final Color mediumGray = Color(0xFF8E8E93);
  final Color lightGray = Color(0xFFF2F2F7);
  final Color white = Colors.white;

  NepaliDateTime? selectedDate;
  final List<String> categories = ['All', 'Seminar', 'Sports', 'Cultural'];
  String selectedCategory = 'All';
  String searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  late List<Event> allEvents;

  @override
  void initState() {
    super.initState();
    allEvents = [
      Event(
        title: 'Science Exhibition',
        location: 'Main Hall',
        dateTime: NepaliDateTime(2082, 3, 3, 10, 0).toDateTime(),
        category: 'Seminar',
      ),
      Event(
        title: 'Football Match',
        location: 'Playground',
        dateTime: NepaliDateTime(2082, 5, 3, 10, 0).toDateTime(),
        category: 'Sports',
      ),
      Event(
        title: 'Farewell Ceremony',
        location: 'Auditorium',
        dateTime: NepaliDateTime(2082, 5, 3, 10, 0).toDateTime(),
        category: 'Cultural',
      ),
    ];
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _pickNepaliDate() async {
    final date = await showAdaptiveDatePicker(
      context: context,
      initialDate: selectedDate ?? NepaliDateTime.now(),
      firstDate: NepaliDateTime(2070),
      lastDate: NepaliDateTime(2090),
      language: Language.nepali,
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _refreshEvents() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  bool _isSameNepaliDate(NepaliDateTime d1, NepaliDateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  List<Event> get filteredEvents {
    return allEvents.where((event) {
      final matchesSearch =
          event.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              event.location.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' || event.category == selectedCategory;

      final matchesDate = selectedDate == null
          ? true
          : _isSameNepaliDate(
              NepaliDateTime.fromDateTime(event.dateTime), selectedDate!);

      return matchesSearch && matchesCategory && matchesDate;
    }).toList();
  }

  void toggleBookmark(Event event) {
    final index = allEvents.indexOf(event);
    if (index != -1) {
      setState(() {
        allEvents[index] = event.copyWith(isBookmarked: !event.isBookmarked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Events',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _searchFocusNode.unfocus(),
          child: Column(
            children: [
              // Nepali Date Picker
              GestureDetector(
                onTap: _pickNepaliDate,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05, vertical: 14),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedDate == null
                              ? '📅 Select Date'
                              : '📅 ${NepaliDateFormat("MMMM d, y").format(selectedDate!)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: mediumGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (selectedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = null;
                                });
                              },
                              child: Icon(Icons.clear,
                                  size: 18, color: mediumGray),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: mediumGray),
                    hintText: 'Search events',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onSubmitted: (_) => _searchFocusNode.unfocus(),
                ),
              ),

              SizedBox(height: 10),

              // Category Filter
              EventCategoryFilter(
                categories: categories,
                selected: selectedCategory,
                onSelected: (value) {
                  setState(() {
                    selectedCategory = value;
                    if (value == 'All') {
                      selectedDate = null; // ✅ Reset date when All is selected
                    }
                  });
                },
              ),

              SizedBox(height: 8),

              // Event List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshEvents,
                  child: filteredEvents.isEmpty
                      ? ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 40),
                            Center(
                              child: Text(
                                "No events found.",
                                style:
                                    TextStyle(color: mediumGray, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : AnimationLimiter(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05, vertical: 10),
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: Duration(milliseconds: 300),
                                child: SlideAnimation(
                                  verticalOffset: 40,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EventDetailsPage(event: event),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.06),
                                              blurRadius: 14,
                                              spreadRadius: 1,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.045,
                                              vertical: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.event_note,
                                                      color: mediumGray,
                                                      size: 20),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      event.title,
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: black,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        toggleBookmark(event),
                                                    child: Icon(
                                                      event.isBookmarked
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_border,
                                                      color: mediumGray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .access_time_filled_rounded,
                                                      size: 18,
                                                      color: mediumGray),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    '${event.dateTime.hour.toString().padLeft(2, '0')}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                                                    style: TextStyle(
                                                        fontSize: 14.5,
                                                        color: mediumGray),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.notifications_none,
                                                      size: 18,
                                                      color: mediumGray),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons.location_on_rounded,
                                                      size: 18,
                                                      color: mediumGray),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    event.location,
                                                    style: TextStyle(
                                                        fontSize: 14.5,
                                                        color: mediumGray),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
