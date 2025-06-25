import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class ApplyLeavePage extends StatefulWidget {
  @override
  _ApplyLeavePageState createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  String reason = '';
  List<String> uploadedFiles = [];
  bool isHalfDay = false;
  String? halfDayTime; // "First Half" or "Second Half"

  bool _canApplyLeave = false;
  bool _isSubmitting = false;

  final List<String> leaveTypes = [
    "Sick Leave",
    "Casual Leave",
    "Maternity Leave",
    "Paternity Leave",
    "Earned Leave",
  ];

  final List<String> halfDayOptions = ["First Half", "Second Half"];

  @override
  void initState() {
    super.initState();
    _checkLeaveUsageAndShowDialog();
  }

  Future<void> _checkLeaveUsageAndShowDialog() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final bool hasFreeLeave = await _fetchLeaveUsage();
    final String message = hasFreeLeave
        ? "You have 1 free leave day available this month."
        : "You have already used your free leave day. Any additional leave days will deduct your salary per day.";

    final bool proceed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: const Text("Leave Usage Information"),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Proceed"),
                ),
              ],
            );
          },
        ) ??
        false;

    if (proceed) {
      setState(() => _canApplyLeave = true);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _fetchLeaveUsage() async {
    return true;
  }

  Future<void> selectNepaliDate({required bool isStart}) async {
    final now = nepali.NepaliDateTime.now();
    final picked = await nepali.showAdaptiveDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: nepali.NepaliDateTime(2090, 12),
    );

    if (picked != null) {
      setState(() {
        final dateTime = picked.toDateTime();
        if (isStart) {
          startDate = dateTime;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = startDate;
          }
        } else {
          if (startDate == null) {
            _showErrorDialog("Please select Start Date first.");
          } else if (dateTime.isBefore(startDate!)) {
            _showErrorDialog("End Date cannot be before Start Date.");
          } else {
            endDate = dateTime;
          }
        }
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      final newFiles = result.paths
          .whereType<String>()
          .map(path.basename)
          .where((file) => !uploadedFiles.contains(file))
          .toList();

      if (newFiles.isEmpty) {
        _showSnack("No new files selected.");
      } else {
        setState(() => uploadedFiles.addAll(newFiles));
      }
    }
  }

  void submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (startDate == null || endDate == null || selectedLeaveType == null) {
      _showErrorDialog("Please fill all required fields.");
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      _showErrorDialog("End Date cannot be before Start Date.");
      return;
    }

    if (isHalfDay && halfDayTime == null) {
      _showErrorDialog("Please select First or Second Half.");
      return;
    }

    final duration = endDate!.difference(startDate!).inDays + 1;
    if (!isHalfDay && duration > 3) {
      _showErrorDialog("Leave duration must be 3 days or less.");
      return;
    }

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isSubmitting = false);

      _showSuccessDialog("Leave application submitted successfully.");

      setState(() {
        selectedLeaveType = null;
        startDate = null;
        endDate = null;
        reason = '';
        uploadedFiles.clear();
        isHalfDay = false;
        halfDayTime = null;
        _formKey.currentState!.reset();
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorDialog("Failed to submit leave application. Please try again.");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Validation Error"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK")),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK")),
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 16)),
      subtitle: Text(
        date == null
            ? "Select date"
            : nepali.NepaliDateFormat('yyyy MMMM dd, EEE')
                .format(nepali.NepaliDateTime.fromDateTime(date)),
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      trailing:
          const Icon(Icons.calendar_today_outlined, color: Colors.black54),
      onTap: onTap,
      horizontalTitleGap: 0,
      minVerticalPadding: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (!_canApplyLeave) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Apply for Leave"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text("Apply for Leave",
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdownCard(),
                const SizedBox(height: 20),
                _buildHalfDayToggle(),
                if (isHalfDay) _buildHalfDayOption(),
                const SizedBox(height: 20),
                _buildDateCard(),
                const SizedBox(height: 20),
                _buildReasonCard(),
                const SizedBox(height: 24),
                const Text("Supporting Documents (Optional)",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 18)),
                const SizedBox(height: 8),
                _buildUploadChip(),
                if (uploadedFiles.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildUploadedFileList(screenWidth),
                ],
                const SizedBox(height: 36),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: "Leave Type",
          labelStyle: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16),
          border: InputBorder.none,
        ),
        dropdownColor: Colors.white,
        value: selectedLeaveType,
        items: leaveTypes
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: (value) => setState(() => selectedLeaveType = value),
        validator: (value) =>
            value == null ? "Please select a leave type" : null,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        isExpanded: true,
      ),
    );
  }

  Widget _buildHalfDayToggle() {
    return SwitchListTile.adaptive(
      value: isHalfDay,
      onChanged: (val) => setState(() {
        isHalfDay = val;
        if (!val) halfDayTime = null;
      }),
      title: const Text("Apply for Half Day",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    );
  }

 Widget _buildHalfDayOption() {
  return Container(
    decoration: _cardDecoration(),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Select Half",
        labelStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        border: InputBorder.none,
      ),
      dropdownColor: Colors.white,
      value: halfDayTime,
      hint: const Text("Select First or Second Half"),
      items: halfDayOptions
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option, style: TextStyle(fontSize: 16)),
              ))
          .toList(),
      onChanged: (String? value) {
        setState(() => halfDayTime = value);
      },
      validator: (value) =>
          isHalfDay && value == null ? "Select First or Second Half" : null,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
      isExpanded: true,
    ),
  );
}

  Widget _buildDateCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildDateSelector(
              label: "Start Date",
              date: startDate,
              onTap: () => selectNepaliDate(isStart: true)),
          Divider(height: 1, color: Colors.grey.shade300),
          _buildDateSelector(
              label: "End Date",
              date: endDate,
              onTap: () => selectNepaliDate(isStart: false)),
        ],
      ),
    );
  }

  Widget _buildReasonCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextFormField(
        maxLines: 4,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Reason for leave",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Reason is required" : null,
        onSaved: (value) => reason = value!,
      ),
    );
  }

  Widget _buildUploadChip() {
    return ActionChip(
      label: const Text("Upload",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      avatar: const Icon(Icons.upload_file, color: Colors.black87),
      backgroundColor: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onPressed: pickFile,
    );
  }

  Widget _buildUploadedFileList(double screenWidth) {
    return Container(
      constraints: BoxConstraints(maxHeight: 140, maxWidth: screenWidth),
      decoration: _cardDecoration(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: uploadedFiles.length,
        separatorBuilder: (_, __) => Divider(height: 1),
        itemBuilder: (_, index) {
          final file = uploadedFiles[index];
          return ListTile(
            leading: const Icon(Icons.insert_drive_file, color: Colors.black54),
            title: Text(file,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.redAccent),
              onPressed: () => setState(() => uploadedFiles.removeAt(index)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: _isSubmitting ? null : submitForm,
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: Colors.white),
              )
            : const Text("Apply",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
      ],
    );
  }
}
