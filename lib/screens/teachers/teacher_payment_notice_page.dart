import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TeacherPaymentNoticePage extends StatelessWidget {
  final List<PaymentData> payments = [
    PaymentData(
        period: 'April 2025 Salary',
        paymentDate: '10 May 2025',
        amount: 50000,
        isPaid: true),
    PaymentData(
        period: 'May 2025 Salary',
        paymentDate: null,
        amount: 52000,
        isPaid: false),
    PaymentData(
        period: 'June 2025 Salary',
        paymentDate: null,
        amount: 52000,
        isPaid: false),
  ];

  TeacherPaymentNoticePage({Key? key}) : super(key: key);

  double get totalSalaryReceived =>
      payments.where((p) => p.isPaid).fold(0.0, (sum, p) => sum + p.amount);

  int get pendingPaymentsCount => payments.where((p) => !p.isPaid).length;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxWidth = mediaQuery.size.width;
    final isLargeScreen = maxWidth >= 600;
    final scale = (maxWidth / 400).clamp(0.85, 1.3);

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final Color iosBlue = const Color(0xFF007AFF);
    final Color blackColor = Colors.black87;
    final Color grayColor = Colors.grey.shade600;
    final Color lightGray = Colors.grey.shade200;
    final Color whiteColor = Colors.white;
    final horizontalPadding = isLargeScreen ? maxWidth * 0.1 : maxWidth * 0.05;

    final paidDates = payments
        .where((p) => p.isPaid && p.paymentDate != null)
        .map((p) => _parseDate(p.paymentDate!))
        .where((d) => d != null)
        .cast<DateTime>()
        .toList();

    String lastPaymentDate = '';
    if (paidDates.isNotEmpty) {
      paidDates.sort((a, b) => b.compareTo(a));
      lastPaymentDate = DateFormat('d MMM yyyy').format(paidDates.first);
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: blackColor),
        title: Text(
          'Payment Notices',
          style: GoogleFonts.inter(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 16 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(scale, grayColor, blackColor, lastPaymentDate),
              SizedBox(height: 24 * scale),
              Text(
                'Payments History',
                style: GoogleFonts.inter(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
              SizedBox(height: 12 * scale),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: payments.length,
                separatorBuilder: (_, __) => SizedBox(height: 12 * scale),
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return TeacherPaymentCard(
                    payment: payment,
                    blackColor: blackColor,
                    grayColor: grayColor,
                    iosBlue: iosBlue,
                    lightGray: lightGray,
                    fontScale: scale,
                    currencyFormat: currencyFormat,
                    onDownloadPayslip: payment.isPaid
                        ? () => _downloadPayslip(context, payment)
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      double scale, Color grayColor, Color blackColor, String lastPaymentDate) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20 * scale),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 24 * scale, vertical: 24 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Salary Received (YTD)',
                  style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w500,
                      color: grayColor)),
              SizedBox(height: 12 * scale),
              Text(
                '₹${totalSalaryReceived.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                    fontSize: 28 * scale,
                    fontWeight: FontWeight.w700,
                    color: blackColor),
              ),
              SizedBox(height: 18 * scale),
              isWide
                  ? Row(
                      children: [
                        Expanded(
                            child: _buildSummaryInfo(
                                'Last Payment Date',
                                lastPaymentDate.isNotEmpty
                                    ? lastPaymentDate
                                    : 'N/A',
                                scale,
                                grayColor,
                                blackColor)),
                        SizedBox(width: 20 * scale),
                        Expanded(
                            child: _buildSummaryInfo(
                                'Pending Payments',
                                pendingPaymentsCount.toString(),
                                scale,
                                grayColor,
                                blackColor)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryInfo(
                            'Last Payment Date',
                            lastPaymentDate.isNotEmpty
                                ? lastPaymentDate
                                : 'N/A',
                            scale,
                            grayColor,
                            blackColor),
                        SizedBox(height: 16 * scale),
                        _buildSummaryInfo(
                            'Pending Payments',
                            pendingPaymentsCount.toString(),
                            scale,
                            grayColor,
                            blackColor),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryInfo(String title, String value, double scale,
      Color grayColor, Color blackColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.inter(
                fontSize: 14 * scale,
                fontWeight: FontWeight.w500,
                color: grayColor)),
        SizedBox(height: 6 * scale),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w600,
                color: blackColor)),
      ],
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('d MMMM yyyy').parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  Future<void> _downloadPayslip(
      BuildContext context, PaymentData payment) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Teacher Payslip",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Salary Period: ${payment.period}"),
              pw.Text("Amount: ₹${payment.amount.toStringAsFixed(2)}"),
              pw.Text("Paid on: ${payment.paymentDate}"),
              pw.SizedBox(height: 30),
              pw.Text("Thank you!", style: pw.TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${payment.period}_Payslip.pdf',
    );
  }
}

class TeacherPaymentCard extends StatelessWidget {
  final PaymentData payment;
  final Color blackColor;
  final Color grayColor;
  final Color iosBlue;
  final Color lightGray;
  final VoidCallback? onDownloadPayslip;
  final double fontScale;
  final NumberFormat currencyFormat;

  const TeacherPaymentCard({
    super.key,
    required this.payment,
    required this.blackColor,
    required this.grayColor,
    required this.iosBlue,
    required this.lightGray,
    required this.onDownloadPayslip,
    required this.fontScale,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = payment.isPaid;

    return Container(
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(20 * fontScale),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 16 * fontScale, vertical: 18 * fontScale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isPaid
                      ? iosBlue.withOpacity(0.15)
                      : Colors.orange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(12 * fontScale),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 28 * fontScale,
                  color: isPaid ? iosBlue : Colors.orange.shade700,
                ),
              ),
              SizedBox(width: 14 * fontScale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.period,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15 * fontScale,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(height: 6 * fontScale),
                    Text(
                      isPaid
                          ? 'Paid on: ${payment.paymentDate}'
                          : 'Payment Pending',
                      style: GoogleFonts.inter(
                        fontSize: 13 * fontScale,
                        color: isPaid ? grayColor : Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * fontScale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormat.format(payment.amount),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16 * fontScale,
                  color: blackColor,
                ),
              ),
              isPaid
                  ? TextButton.icon(
                      onPressed: onDownloadPayslip,
                      icon: Icon(Icons.download, size: 18 * fontScale),
                      label: Text('Payslip',
                          style: TextStyle(fontSize: 13 * fontScale)),
                      style: TextButton.styleFrom(foregroundColor: iosBlue),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10 * fontScale, vertical: 6 * fontScale),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(16 * fontScale),
                      ),
                      child: Text(
                        'Pending',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12 * fontScale,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentData {
  final String period;
  final String? paymentDate;
  final double amount;
  final bool isPaid;

  PaymentData({
    required this.period,
    this.paymentDate,
    required this.amount,
    required this.isPaid,
  });
}
