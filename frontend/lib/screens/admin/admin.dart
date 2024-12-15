import 'package:flutter/material.dart';
import 'package:frontend/screens/admin/screens/add_users.dart';
import 'package:frontend/screens/admin/screens/admin_dashboard.dart';
import 'package:frontend/screens/admin/screens/view_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/responsive_services.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late PageController _pageController;
  final int _activeScreen = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _activeScreen);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMenuItemSelected(int index) {
    _pageController.jumpToPage(index);
    if (ResponsiveService.isMobile(context)) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildListTile(String title, int index, ColorScheme colorScheme) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: colorScheme.primary),
      ),
      onTap: () => _onMenuItemSelected(index),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        maintainState: true,
        children: children,
      ),
    );
  }

  PreferredSizeWidget buildAppBar(ColorScheme colorScheme) {
    final isMobile = ResponsiveService.isMobile(context);
    return AppBar(
      automaticallyImplyLeading: isMobile ? true : false,
      backgroundColor: colorScheme.primaryContainer,
      title: const Text(
        'Diagnostic System',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: _logout,
          icon: const Icon(Icons.exit_to_app_rounded),
          color: colorScheme.primary,
          iconSize: 33,
          padding: const EdgeInsets.symmetric(horizontal: 21.0),
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Widget buildSideMenu(ColorScheme colorScheme) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.all(21.0),
        children: [
          _buildListTile('Dashboard', 0, colorScheme),
          _buildExpansionTile(title: 'Users', children: [
            _buildListTile('View Users', 1, colorScheme),
            _buildListTile('Add User', 2, colorScheme),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveService.isMobile(context);

    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(colorScheme),
        drawer: isMobile ? buildSideMenu(colorScheme) : null,
        body: Row(
          children: [
            if (!isMobile) ...[
              Expanded(flex: 3, child: buildSideMenu(colorScheme))
            ],
            Expanded(
                flex: 9,
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Image.asset('assets/images/background.png',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.multiply,
                          opacity: const AlwaysStoppedAnimation(0.03)),
                    ),

                    // Foreground Content
                    Padding(
                      padding: const EdgeInsets.all(21.0),
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: const [
                          AdminDashboard(),
                          ViewUsersScreen(),
                          AddUsersScreen(),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Help & Instructions'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to the Autism and Depression Diagnostic System!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '''
This system is designed to provide self-assessments for Autism and Depression. 
It includes separate modules for autism diagnosis (children and adults) 
and a depression diagnosis test. Results can be reviewed by a healthcare 
professional for follow-up.''',
                        ),
                        SizedBox(height: 20),
                        Text(
                          '1. Depression Test',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '''
- Navigate to the "Depression Test" section.
- Answer all the questions based on your experiences in the past two weeks.
- Submit your answers to receive a preliminary assessment of your mental health.
- If required, your results can be shared with a doctor for further analysis.''',
                        ),
                        SizedBox(height: 20),
                        Text(
                          '2. Autism Test for Children',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '''
- Navigate to the "Autism (Children)" section.
- This test is designed for parents or caregivers of children.
- Answer questions related to the child’s behaviors and interactions.
- Submit the test to understand if your child might exhibit signs of autism.''',
                        ),
                        SizedBox(height: 20),
                        Text(
                          '3. Autism Test for Adults',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '''
- Navigate to the "Autism (Adults)" section.
- This test is for self-assessment of autism traits in adults.
- Answer questions based on your own behaviors and preferences.
- Submit the test for an initial assessment.''',
                        ),
                        SizedBox(height: 20),
                        Text(
                          '4. Doctor Monitoring',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '''
- Once you submit a test, the results are securely stored in the system.
- A doctor may review your results and contact you if necessary for a follow-up.
- Ensure your profile information is complete for effective communication.''',
                        ),
                        SizedBox(height: 20),
                        Text(
                          '5. System Usage Tips',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '''
- Always answer questions honestly to get accurate results.
- Your responses are private and secure.
- For any technical issues, contact support through the app’s feedback section.''',
                        ),
                        SizedBox(height: 10),
                        Text(
                          'We hope this system helps you on your journey to better health.',
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          label: const Text(
            '❓  Help',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
