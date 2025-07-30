import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class RealtimeProgressIndicator extends StatelessWidget {
  final String? currentOperation;
  final String? currentParameter;
  final int currentChunk;
  final int totalChunks;
  final int processedParameters;
  final int totalParameters;

  const RealtimeProgressIndicator({
    super.key,
    this.currentOperation,
    this.currentParameter,
    required this.currentChunk,
    required this.totalChunks,
    required this.processedParameters,
    required this.totalParameters,
  });

  @override
  Widget build(BuildContext context) {
    final double overallProgress =
        totalParameters > 0 ? processedParameters / totalParameters : 0.0;

    return Center(
      child: Card(
        elevation: 8,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                value: overallProgress,
                backgroundColor: AppTheme.dividerColor,
              ),
              const SizedBox(height: 24),

              if (currentOperation != null) ...[
                Text(
                  currentOperation!,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],

              if (currentParameter != null) ...[
                Text(
                  'Reading: $currentParameter',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],

              if (totalChunks > 0)
                Text(
                  'Chunk $currentChunk of $totalChunks',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),

              const SizedBox(height: 16),

              // Progress bar
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${(overallProgress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: overallProgress,
                    backgroundColor: AppTheme.dividerColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$processedParameters of $totalParameters parameters',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
