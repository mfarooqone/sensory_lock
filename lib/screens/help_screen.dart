import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const appColor = Color(0xFF064663);

    final faqs = [
      {
        'question': 'How does Smart Entry work?',
        'answer':
        'It uses IoT sensors to detect and authorize entry quickly and securely.'
      },
      {
        'question': 'Can I monitor entry logs?',
        'answer':
        'Yes, all entry logs are visible in the user dashboard for easy monitoring.'
      },
      {
        'question': 'How do I reset my password?',
        'answer': 'Go to the Login screen and click on "Forgot Password" to reset it.'
      },
      {
        'question': 'Is the app secure?',
        'answer':
        'The app uses advanced security protocols to protect user data and access.'
      },
      {
        'question': 'Can I add multiple users?',
        'answer': 'Yes, admins can add and manage multiple users from the dashboard.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: const Text(
            "Help & FAQs",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: appColor,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: appColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30), // Space between app bar and content
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final item = faqs[index];
                  return ExpansionTile(
                    title: Text(
                      item['question']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appColor,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          item['answer']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: appColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
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
