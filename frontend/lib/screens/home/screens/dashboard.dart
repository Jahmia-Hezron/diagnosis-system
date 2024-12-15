import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../services/diagnostic_results_service.dart';
import '../../../services/session_services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    await Future.wait([_fetchResults(), _fetchUsername()]);
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

  Widget _buildLineChart(
      List<dynamic> data, Color lineColor, ColorScheme colorScheme) {
    if (data.isEmpty) {
      return _buildEmptyMessage(lineColor);
    }
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: _buildChartTitlesData(colorScheme),
        borderData: _buildChartBorder(),
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

  Widget _buildEmptyMessage(Color lineColor) {
    return Center(
      child: Text(
        'Nothing to show, Take a test first',
        style: TextStyle(color: lineColor),
      ),
    );
  }

  FlTitlesData _buildChartTitlesData(ColorScheme colorScheme) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            return Text(
              'Test ${value.toInt() + 1}',
              style: TextStyle(color: colorScheme.primary, fontSize: 10),
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
              style: TextStyle(color: colorScheme.primary, fontSize: 10),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlBorderData _buildChartBorder() {
    return FlBorderData(
      show: true,
      border: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        bottom: BorderSide(width: 2),
        left: BorderSide(width: 2),
      ),
    );
  }

  Widget _buildSection(
    Widget child,
    ColorScheme colorScheme, {
    double padding = 13.0,
  }) {
    return Material(
      color: colorScheme.surfaceContainer.withOpacity(0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
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
          _buildChartCard('Depression Levels', _depressionDiagnoses,
              Colors.blue, colorScheme),
          _buildChartCard(
              'Autism Levels', _autismDiagnoses, Colors.orange, colorScheme),
        ],
      ),
      colorScheme,
    );
  }

  Widget _buildChartCard(String title, List<dynamic> data, Color lineColor,
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
              child: _buildLineChart(data, lineColor, colorScheme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreSection(ColorScheme colorScheme) {
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
          _scoreCard('Latest Depression Score', _depressionDiagnoses,
              colorScheme.primary),
          _scoreCard(
              'Latest Autism Score', _autismDiagnoses, colorScheme.secondary),
        ],
      ),
      colorScheme,
    );
  }

  Widget _scoreCard(String label, List<dynamic> diagnoses, Color color) {
    String result =
        diagnoses.isNotEmpty ? diagnoses.last['result'].toString() : '';
    String score =
        diagnoses.isNotEmpty ? diagnoses.last['score'].toString() : 'N/A';

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          Text(
            result,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            score,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
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
                Text(_username ?? 'User',
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
                Text('Welcome back, $_username!',
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
                    'It’s so good to see you again. We’re here for you, every step of the way.',
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

  Widget _encouragementSection(ColorScheme colorScheme) {
    return _buildSection(
      Text(
        '🧠 Ready for a mental health check? Take a quick test to learn more about yourself! 💪\n\nWhether it’s for autism or depression, understanding yourself is a step towards well-being. 🌱',
        style: TextStyle(
            fontWeight: FontWeight.w500, color: colorScheme.onSurface),
        textAlign: TextAlign.center,
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
          _scoreSection(colorScheme),
          const SizedBox(height: 13),
          _encouragementSection(colorScheme),
          const SizedBox(height: 13),
          _chartSection(colorScheme),
        ],
      ],
    );
  }
}
