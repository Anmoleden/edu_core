import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherFeedbackPage extends StatefulWidget {
  const TeacherFeedbackPage({super.key});

  @override
  State<TeacherFeedbackPage> createState() => _TeacherFeedbackPageState();
}

class _TeacherFeedbackPageState extends State<TeacherFeedbackPage> {
  String? selectedFeedbackType;
  double rating = 0;
  final TextEditingController feedbackController = TextEditingController();
  bool isAnonymous = false;
  File? attachedImage;

  final List<String> feedbackTypes = [
    'Suggestion',
    'Complaint',
    'General Feedback',
    'Issue Report',
  ];

  final List<Map<String, dynamic>> feedbackHistory = [];

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        attachedImage = File(result.files.single.path!);
      });
    }
  }

  Future<bool> confirmRemoveImage() async {
    return (await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Remove Image?'),
            content: const Text('Do you want to remove the attached image?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void showThankYouModal() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text('Thank you!',
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Your feedback has been submitted successfully.',
                  style: GoogleFonts.inter(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text('Close',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFeedbackDetails(Map<String, dynamic> feedback) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 24,
          right: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Feedback Details",
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _detailRow('Type', feedback['type']),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text("Rating: ",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black)),
                    RatingBarIndicator(
                      rating: feedback['rating'],
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
              _detailRow('Date',
                  "${feedback['date'].day}/${feedback['date'].month}/${feedback['date'].year}"),
              _detailRow('Status', feedback['status']),
              if (feedback['anonymous'] == true)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Submitted Anonymously",
                      style: GoogleFonts.inter(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700])),
                ),
              if (feedback['attachedImage'] != null) ...[
                const SizedBox(height: 16),
                Text("Attached Image:",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(feedback['attachedImage'],
                      width: double.infinity, height: 200, fit: BoxFit.cover),
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Close',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text("$label: ",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black)),
          Expanded(
              child: Text(value,
                  style:
                      GoogleFonts.inter(fontSize: 15, color: Colors.grey[800]),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color blackColor = Colors.black87;
    final Color grayColor = Colors.grey.shade600;
    final Color lightGray = Colors.grey.shade100;
    final Color whiteColor = Colors.white;
    final double scale = MediaQuery.of(context).size.width / 400;

    // Enable submit only if type selected and feedback not empty
    bool isSubmitEnabled = selectedFeedbackType != null &&
        feedbackController.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        centerTitle: true,
        leading: BackButton(color: blackColor),
        title: Text('Send Feedback',
            style: GoogleFonts.inter(
              fontSize: 18 * scale,
              fontWeight: FontWeight.w600,
              color: blackColor,
            )),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20 * scale,
              right: 20 * scale,
              top: 16 * scale,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Feedback Type',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * scale,
                      color: blackColor),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                  decoration: BoxDecoration(
                    border: Border.all(color: grayColor),
                    borderRadius: BorderRadius.circular(12),
                    color: whiteColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFeedbackType,
                      hint: Text('Choose a type',
                          style: GoogleFonts.inter(
                              color: grayColor, fontSize: 15 * scale)),
                      isExpanded: true,
                      items: feedbackTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type,
                                    style: GoogleFonts.inter(
                                        color: blackColor,
                                        fontSize: 15 * scale)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFeedbackType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Rate your experience',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * scale,
                      color: blackColor),
                ),
                const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 0,
                  maxRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 32 * scale,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4 * scale),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Your Feedback',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * scale,
                      color: blackColor),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: feedbackController,
                  maxLines: null,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write your feedback here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: grayColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blackColor),
                    ),
                  ),
                  onChanged: (_) =>
                      setState(() {}), // Update submit button state
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          isAnonymous = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'Submit Anonymously',
                      style: GoogleFonts.inter(fontSize: 16 * scale),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(
                            vertical: 14 * scale, horizontal: 20 * scale),
                      ),
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Attach Image'),
                    ),
                    const SizedBox(width: 16),
                    if (attachedImage != null)
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                attachedImage!,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () async {
                                  final confirm = await confirmRemoveImage();
                                  if (confirm) {
                                    setState(() {
                                      attachedImage = null;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSubmitEnabled
                        ? () {
                            // Add feedback to history list
                            feedbackHistory.add({
                              'type': selectedFeedbackType!,
                              'rating': rating,
                              'date': DateTime.now(),
                              'status': 'Pending',
                              'feedback': feedbackController.text.trim(),
                              'anonymous': isAnonymous,
                              'attachedImage': attachedImage,
                            });
                            // Reset form
                            setState(() {
                              selectedFeedbackType = null;
                              rating = 0;
                              feedbackController.clear();
                              isAnonymous = false;
                              attachedImage = null;
                            });
                            showThankYouModal();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSubmitEnabled ? Colors.black : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Submit Feedback',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (feedbackHistory.isNotEmpty) ...[
                  Text(
                    'Feedback History',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 20 * scale,
                        color: blackColor),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedbackHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final feedback = feedbackHistory[index];
                      return InkWell(
                        onTap: () => showFeedbackDetails(feedback),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: lightGray,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: grayColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      feedback['type'],
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: blackColor),
                                    ),
                                  ),
                                  RatingBarIndicator(
                                    rating: feedback['rating'],
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feedback['feedback'],
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: grayColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Status: ${feedback['status']}",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.blueGrey),
                              ),
                              Text(
                                "Date: ${feedback['date'].day}/${feedback['date'].month}/${feedback['date'].year}",
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: grayColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
