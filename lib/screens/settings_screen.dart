import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../config/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageOption(
                    context,
                    l10n.english,
                    'en',
                    isActive: true,
                  ),
                  const SizedBox(height: 8),
                  _buildLanguageOption(
                    context,
                    l10n.arabic,
                    'ar',
                    isActive: false,
                    isComingSoon: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.settingsComingSoon,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String languageCode, {
    required bool isActive,
    bool isComingSoon = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor.withValues(alpha: 0.2) : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppTheme.primaryColor : Colors.grey[700]!,
          width: 2,
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(label),
            if (isComingSoon) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: isActive
            ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
            : null,
        enabled: !isComingSoon,
      ),
    );
  }
}
