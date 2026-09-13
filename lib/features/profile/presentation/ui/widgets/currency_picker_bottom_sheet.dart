import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';

import 'package:splittr/di/injection.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';

class CurrencyInfo {
  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.symbol,
  });

  final String code;
  final String name;
  final String symbol;
}

const List<CurrencyInfo> appSupportedCurrencies = [
  CurrencyInfo(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
  CurrencyInfo(code: 'USD', name: 'US Dollar', symbol: r'$'),
  CurrencyInfo(code: 'EUR', name: 'Euro', symbol: '€'),
  CurrencyInfo(code: 'GBP', name: 'British Pound', symbol: '£'),
  CurrencyInfo(code: 'CAD', name: 'Canadian Dollar', symbol: r'CA$'),
  CurrencyInfo(code: 'AUD', name: 'Australian Dollar', symbol: r'AU$'),
  CurrencyInfo(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
  CurrencyInfo(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF'),
  CurrencyInfo(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
  CurrencyInfo(code: 'SGD', name: 'Singapore Dollar', symbol: r'S$'),
  CurrencyInfo(code: 'NZD', name: 'New Zealand Dollar', symbol: r'NZ$'),
  CurrencyInfo(code: 'AED', name: 'UAE Dirham', symbol: 'AED'),
];

class CurrencyPickerBottomSheet extends StatefulWidget {
  const CurrencyPickerBottomSheet({
    required this.selectedCurrency,
    required this.onCurrencySelected,
    super.key,
  });

  final String selectedCurrency;
  final ValueChanged<String> onCurrencySelected;

  @override
  State<CurrencyPickerBottomSheet> createState() =>
      _CurrencyPickerBottomSheetState();
}

class _CurrencyPickerBottomSheetState extends State<CurrencyPickerBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final configCurrencies = getIt<AppConfigStore>().currencies;
    final sourceCurrencies = configCurrencies.isNotEmpty
        ? configCurrencies
              .map(
                (c) => CurrencyInfo(
                  code: c.code,
                  name: c.name,
                  symbol: c.symbol,
                ),
              )
              .toList()
        : appSupportedCurrencies;

    final filtered = sourceCurrencies.where((c) {
      final q = _searchQuery.toLowerCase();
      return c.code.toLowerCase().contains(q) ||
          c.name.toLowerCase().contains(q);
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          labelText: 'Search currency',
          prefixIcon: const Icon(Icons.search_rounded),
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.45,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: filtered.length,
            separatorBuilder: (context, index) => const AppDivider.horizontal(),
            itemBuilder: (context, index) {
              final currency = filtered[index];
              final isSelected =
                  currency.code.toUpperCase() ==
                  widget.selectedCurrency.toUpperCase();

              return ListTile(
                title: AppText.bodyLarge('${currency.code} - ${currency.name}'),
                subtitle: AppText.bodyMedium(currency.symbol),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: isSelected
                      ? context.colorScheme.primaryContainer
                      : context.colorScheme.surfaceContainerHighest,
                  foregroundColor: isSelected
                      ? context.colorScheme.onPrimaryContainer
                      : context.colorScheme.onSurfaceVariant,
                  child: Text(
                    currency.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: context.colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  widget.onCurrencySelected(currency.code);
                  RouteHandler.pop<void>(context);
                },
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
