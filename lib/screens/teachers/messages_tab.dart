import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({Key? key}) : super(key: key);

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> inboxMessages = [
    {
      'from': 'Principal Sharma',
      'subject': 'Staff Meeting Tomorrow',
      'date': 'May 28',
      'body':
          'Dear all, the staff meeting is scheduled for tomorrow at 10 AM in the conference room.',
      'profilePhoto': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'from': 'Parent of Ram',
      'subject': 'Homework question',
      'date': 'May 27',
      'body': 'Could you please clarify the homework assigned for math?',
      'profilePhoto': 'https://i.pravatar.cc/150?img=12',
    },
  ];

  final List<String> recipientTypes = ['Parent', 'Staff'];
  String selectedRecipientType = 'Parent';

  final Map<String, List<String>> receivers = {
    'Parent': ['Parent of Ram', 'Parent of Sita', 'Parent of John'],
    'Staff': ['Teacher A', 'Teacher B', 'Principal Sharma'],
  };

  String? selectedReceiver;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedReceiver = receivers[selectedRecipientType]!.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();

    if (selectedReceiver == null || subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields', style: GoogleFonts.poppins()),
        ),
      );
      return;
    }

    setState(() {
      subjectController.clear();
      messageController.clear();
      selectedReceiver = receivers[selectedRecipientType]!.first;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message sent to $selectedReceiver',
            style: GoogleFonts.poppins()),
      ),
    );
  }

  void _openChatPage(Map<String, String> message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          sender: message['from'] ?? '',
          profilePhoto: message['profilePhoto'] ?? '',
          initialMessage: message['body'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.black,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Inbox'),
            Tab(text: 'Send Message'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Inbox Tab
              inboxMessages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: inboxMessages.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        final msg = inboxMessages[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(msg['profilePhoto'] ?? ''),
                            radius: 24,
                          ),
                          title: Text(msg['from'] ?? '',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            msg['body'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(color: Colors.grey[700]),
                          ),
                          trailing: Text(msg['date'] ?? '',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey[600], fontSize: 12)),
                          onTap: () => _openChatPage(msg),
                        );
                      },
                    ),

              // Send Message Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recipient Type',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedRecipientType,
                      isExpanded: true,
                      items: recipientTypes
                          .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type, style: GoogleFonts.poppins())))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedRecipientType = val;
                            selectedReceiver = receivers[val]!.first;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Select Receiver',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedReceiver,
                      isExpanded: true,
                      items: receivers[selectedRecipientType]!
                          .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r, style: GoogleFonts.poppins())))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedReceiver = val),
                    ),
                    const SizedBox(height: 16),
                    Text('Subject',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'Enter subject',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Message',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'Write your message here',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Send',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatPage extends StatefulWidget {
  final String sender;
  final String profilePhoto;
  final String initialMessage;

  const ChatPage({
    Key? key,
    required this.sender,
    required this.profilePhoto,
    required this.initialMessage,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> messages = [];
  final TextEditingController replyController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages.add(widget.initialMessage);
  }

  void _sendReply() {
    final reply = replyController.text.trim();
    if (reply.isEmpty) return;
    setState(() {
      messages.add(reply);
      replyController.clear();
    });
    // Scroll to bottom after sending a new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    replyController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sender,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            backgroundImage: NetworkImage(widget.profilePhoto),
            radius: 36,
          ),
          const SizedBox(height: 8),
          Text(widget.sender,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final isReply = index > 0;
                return Align(
                  alignment:
                      isReply ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: isReply ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index],
                      style: GoogleFonts.poppins(
                          color: isReply ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    decoration: InputDecoration(
                      hintText: 'Type your reply...',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendReply,
                  icon: const Icon(Icons.send),
                  color: Colors.black,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
