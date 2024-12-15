import 'package:flutter/material.dart';
import 'package:frontend/services/session_services.dart';
import '../../../services/diagnostic_results_service.dart';

class TestResults extends StatefulWidget {
  const TestResults({super.key});

  @override
  State<TestResults> createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults> {
  List<dynamic> _autismDiagnoses = [];
  List<dynamic> _depressionDiagnoses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    _autismDiagnoses = await DiagnosisService.fetchAutismDiagnosesByUserId(
        SessionServices.userId!);
    _depressionDiagnoses =
        await DiagnosisService.fetchDepressionDiagnosesByUserId(
            SessionServices.userId!);
    setState(() => _isLoading = false);
  }

  Widget _buildMaterialContainer(Widget child, BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }

  Widget _headerSection() {
    return const Column(
      children: [
        Text(
          'Test Results 📜',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '''
Here you can view your recent test scores. 
Remember, you're not alone on this journey. 💖
''',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _scoreCard(String label, String score, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
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

  Widget _diagnosisTable(
      List<dynamic> diagnoses, bool isLoading, ColorScheme colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return DataTable(
      showBottomBorder: true,
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
      columns: const [
        DataColumn(label: Text('Index')),
        DataColumn(label: Text('Score')),
        DataColumn(label: Text('Result')),
      ],
      rows: diagnoses.asMap().entries.map<DataRow>((entry) {
        int index = entry.key + 1;
        var diagnosis = entry.value;
        return DataRow(cells: [
          DataCell(Text(index.toString())),
          DataCell(Text(diagnosis['score'].toString())),
          DataCell(Text(diagnosis['result'].toString())),
        ]);
      }).toList(),
    );
  }

  Widget _resultsTable(String title, List<dynamic> diagnoses) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(height: 21, thickness: 1, color: colorScheme.primaryContainer),
        _buildMaterialContainer(
          _diagnosisTable(diagnoses, _isLoading, colorScheme),
          context,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMaterialContainer(_headerSection(), context),
        const SizedBox(height: 13),
        _buildMaterialContainer(
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
              _scoreCard(
                "Latest Depression Score",
                _depressionDiagnoses.isNotEmpty
                    ? _depressionDiagnoses.last['score'].toString()
                    : 'N/A',
                colorScheme.primary,
              ),
              _scoreCard(
                "Latest Autism Score",
                _autismDiagnoses.isNotEmpty
                    ? _autismDiagnoses.last['score'].toString()
                    : 'N/A',
                colorScheme.secondary,
              ),
            ],
          ),
          context,
        ),
        const SizedBox(height: 13),
        _buildMaterialContainer(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _resultsTable(
                      'Depression Results Table', _depressionDiagnoses),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      _resultsTable('Autism Results Table', _autismDiagnoses),
                ),
              ],
            ),
            context)
      ],
    );
  }
}
