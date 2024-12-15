import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/enums/depression_diagnostic_questions.dart';
import 'package:frontend/models/depression_diagnosis.dart';
import 'package:frontend/services/diagnostic_service.dart';
import 'package:frontend/services/session_services.dart';
import 'package:frontend/widgets/button_widget.dart';

import '../../../services/notification_service.dart';

class DepressionDiagnosis extends StatefulWidget {
  const DepressionDiagnosis({super.key});

  @override
  State<DepressionDiagnosis> createState() => _DepressionDiagnosisState();
}

class _DepressionDiagnosisState extends State<DepressionDiagnosis> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final List<String> _questions = DepressionDiagnosticQuestions.pq9Questions();
  final List<int> _answers =
      List<int>.filled(13, 0); // Store answers for 9 questions

  void _resetForm() {
    // Reset the answers
    setState(() {
      _answers.fillRange(0, _answers.length, 0);
    });

    // Reset the form state
    _formKey.currentState!.reset();
  }

  Future<bool> _submitDiagnosis() async {
    int? userId = SessionServices.getUserId();
    if (userId == null) {
      return false;
    }

    int totalScore = _answers.reduce((value, element) => value + element);
    PHQ9Diagnosis diagnosis = PHQ9Diagnosis(userID: userId, score: totalScore);

    try {
      var result = await DiagnosticService.submitPHQ9Diagnosis(diagnosis);
      log("$result");
      return true;
    } catch (error) {
      log("Diagnosis submission error: $error");
      return false;
    }
  }

  void _handleSubmitButtonPress() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      bool submissionSuccess = await _submitDiagnosis();
      if (!mounted) return;
      if (submissionSuccess == true) {
        NotificationService.showSnackBar(
            context, 'Your response has been recorded successfully.');
        _resetForm();
      } else {
        NotificationService.showSnackBar(
            context, 'Failed to submit diagnosis.');
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      NotificationService.showSnackBar(context, 'User Not logged In');
    }
  }

  Widget _buildQuestionCard(
      int index, String question, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Material(
        elevation: 0.3,
        color: colorScheme.onPrimary,
        shadowColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
              ),
              Divider(
                height: 33,
                color: colorScheme.primaryContainer,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (scoreIndex) {
                  return Row(
                    children: [
                      Radio<int>(
                        value: scoreIndex,
                        groupValue: _answers[index],
                        onChanged: (value) {
                          setState(() {
                            _answers[index] = value!;
                          });
                        },
                      ),
                      Text(scoreIndex.toString()),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool isDisabled = false,
  }) {
    return ButtonWidget(
      buttonLable: label,
      backgroundColor: colorScheme.primary,
      disabledColor: colorScheme.primaryContainer,
      textColor: colorScheme.onPrimary,
      onPressed: isDisabled ? null : onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const SizedBox(
            height: 21.0,
          ),
          const Text(
            '''
Over the last 2 weeks, 
how often have you been bothered by any of the following problems?''',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Divider(
            height: 80,
            thickness: 1,
            color: colorScheme.primaryContainer,
          ),
          ..._questions.asMap().entries.map((entry) {
            int index = entry.key;
            String question = entry.value;
            return _buildQuestionCard(
              index,
              question,
              colorScheme,
            );
          }),
          Divider(
            height: 80,
            thickness: 1,
            color: colorScheme.primaryContainer,
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : _buildAuthButton(
                  label: 'Submit',
                  onPressed: _handleSubmitButtonPress,
                  colorScheme: colorScheme)
        ],
      ),
    );
  }
}
