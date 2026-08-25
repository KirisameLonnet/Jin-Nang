import 'package:flutter/material.dart';

import '../core/di.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_card.dart';
import 'pressable.dart';

Future<void> showAppLanguageDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final selectedLanguage = Di.localeController.value?.languageCode;
      final options = [
        (null, dialogContext.l10n.followSystem),
        ('en', dialogContext.l10n.english),
        ('zh', dialogContext.l10n.simplifiedChinese),
      ];
      return Dialog(
        backgroundColor: Colors.transparent,
        child: AppCard(
          color: AppColors.springWood14,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dialogContext.l10n.language,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Pressable(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      await Di.localeController.setLocale(
                        option.$1 == null ? null : Locale(option.$1!),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: selectedLanguage == option.$1
                            ? AppColors.baliHai30
                            : Colors.white,
                        border: Border.all(
                          color: AppColors.morandiText,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.$2,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.morandiText,
                              ),
                            ),
                          ),
                          if (selectedLanguage == option.$1)
                            const Icon(
                              Icons.check,
                              color: AppColors.morandiText,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class LanguagePickerButton extends StatelessWidget {
  const LanguagePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Semantics(
      button: true,
      label: context.l10n.language,
      child: Pressable(
        onPressed: () => showAppLanguageDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.morandiText, width: 2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: AppColors.morandiText,
                offset: Offset(2, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text(
                languageCode == 'zh'
                    ? context.l10n.languageBadgeChinese
                    : context.l10n.languageBadgeEnglish,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
