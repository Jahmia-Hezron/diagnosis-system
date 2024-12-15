import 'package:flutter/material.dart';

import '../../../services/user_service.dart';

class ViewUsersScreen extends StatefulWidget {
  const ViewUsersScreen({super.key});

  @override
  State<ViewUsersScreen> createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<ViewUsersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<dynamic>> _patientsFuture;
  late Future<List<dynamic>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _patientsFuture = UserService.fetchPatients();
    _doctorsFuture = UserService.fetchDoctors();
  }

  Widget _buildUserTable(
      Future<List<dynamic>> usersFuture, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: FutureBuilder<List<dynamic>>(
          future: usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              final users = snapshot.data!;
              return ListView(
                children: [
                  DataTable(
                    showBottomBorder: true,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                    ],
                    rows: users.map<DataRow>((user) {
                      return DataRow(cells: [
                        DataCell(Text(user['name'] ?? 'N/A')),
                        DataCell(Text(user['email'] ?? 'N/A')),
                        DataCell(Text(user['role'] ?? 'N/A')),
                      ]);
                    }).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Material(
            color: colorScheme.surfaceContainer.withOpacity(0.75),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: const Padding(
              padding: EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('System Users',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            )),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Patients'),
            Tab(text: 'Doctors'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Material(
          color: colorScheme.surfaceContainer.withOpacity(0.75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserTable(_patientsFuture, colorScheme),
                _buildUserTable(_doctorsFuture, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
