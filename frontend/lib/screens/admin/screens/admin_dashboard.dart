import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../services/diagnostic_results_service.dart';
import '../../../services/session_services.dart';
import '../../../services/user_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _patientCount = 0;
  int _doctorCount = 0;
  List<dynamic> _autismDiagnoses = [];
  List<dynamic> _depressionDiagnoses = [];
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([_fetchResults(), _fetchUsername(), _fetchCounts()]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchResults() async {
    var userId = SessionServices.userId!;
    _autismDiagnoses =
        await DiagnosisService.fetchAutismDiagnosesByUserId(userId);
    _depressionDiagnoses =
        await DiagnosisService.fetchDepressionDiagnosesByUserId(userId);
  }

  Future<void> _fetchUsername() async {
    _username = SessionServices.getUserName();
  }

  Future<void> _fetchCounts() async {
    try {
      List<dynamic> patients = await UserService.fetchPatients();
      List<dynamic> doctors = await UserService.fetchDoctors();
      setState(() {
        _patientCount = patients.length;
        _doctorCount = doctors.length;
      });
    } catch (error) {
      log("Failed to fetch counts: $error");
    }
  }

  Widget _buildLineChart(List<dynamic> data, Color lineColor) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'Nothing to show, Take a test first',
          style: TextStyle(color: lineColor),
        ),
      );
    }
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Test ${value.toInt() + 1}',
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                );
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            top: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(width: 2),
            left: BorderSide(width: 2),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              int index = entry.key;
              int score = entry.value['score'];
              return FlSpot(index.toDouble(), score.toDouble());
            }).toList(),
            isCurved: true,
            barWidth: 4,
            color: lineColor,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(Widget child, ColorScheme colorScheme,
      {double padding = 13.0}) {
    return Material(
      color: colorScheme.surfaceContainer.withOpacity(0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }

  Widget _buildChartSection(String title, List<dynamic> data, Color lineColor,
      ColorScheme colorScheme) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 13),
          Text(
            title,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary),
          ),
          Divider(
              height: 21, thickness: 1, color: colorScheme.primaryContainer),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 21.0),
              child: _buildLineChart(data, lineColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartSection(ColorScheme colorScheme) {
    return _buildSection(
      GridView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 13.0,
          childAspectRatio: 1.2,
        ),
        children: [
          _buildChartSection('Depression Levels', _depressionDiagnoses,
              Colors.blue, colorScheme),
          _buildChartSection(
              'Autism Levels', _autismDiagnoses, Colors.orange, colorScheme),
        ],
      ),
      colorScheme,
    );
  }

  Widget _buildScoreCard(String label, int count, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _userCounterSection(ColorScheme colorScheme) {
    return _buildSection(
      GridView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 13.0,
          childAspectRatio: 2.5,
        ),
        children: [
          _buildScoreCard('Total Patients', _patientCount, colorScheme.primary),
          _buildScoreCard('Total Doctors', _doctorCount, colorScheme.secondary),
        ],
      ),
      colorScheme,
    );
  }

  Widget _userWelcomeSection(ColorScheme colorScheme) {
    return _buildSection(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                const CircleAvatar(
                    radius: 30, child: Icon(Icons.person, size: 30)),
                const SizedBox(width: 10),
                Text(_username ?? 'Administrator',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Text('Welcome back, Dr. $_username!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary),
                    textAlign: TextAlign.center),
                Divider(
                    height: 21,
                    thickness: 1,
                    color: colorScheme.primaryContainer),
                const Text(
                    'Your leadership and care make a difference every day. Let’s make today impactful!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
      colorScheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(13.0),
      children: [
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else ...[
          _userWelcomeSection(colorScheme),
          const SizedBox(height: 13),
          _userCounterSection(colorScheme),
          const SizedBox(height: 13),
          _chartSection(colorScheme),
        ],
      ],
    );
  }
}
