import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/themes/app_colors.dart';

/// A supported country for phone entry. / Un pays pris en charge.
///
/// [minLength]/[maxLength] bound the national number length (digits only) and
/// feed light client-side validation.
class Country {
  const Country({
    required this.name,
    required this.isoCode,
    required this.dialCode,
    required this.flag,
    this.minLength = 6,
    this.maxLength = 14,
  });

  final String name;
  final String isoCode;
  final String dialCode;
  final String flag;
  final int minLength;
  final int maxLength;

  /// Full E.164 number for a given national [nationalNumber].
  String e164(String nationalNumber) =>
      '$dialCode${nationalNumber.replaceAll(RegExp(r'\D'), '')}';

  /// Cameroon — the OSEC default. / Cameroun, valeur par défaut d'OSEC.
  static const Country cameroon = Country(
    name: 'Cameroon',
    isoCode: 'CM',
    dialCode: '+237',
    flag: '🇨🇲',
    minLength: 9,
    maxLength: 9,
  );

  /// A pragmatic list covering OSEC's core markets plus common diaspora hubs.
  ///
  /// Liste pragmatique couvrant les marchés clés d'OSEC et la diaspora.
  static const List<Country> supported = [
    cameroon,
    Country(name: 'Nigeria', isoCode: 'NG', dialCode: '+234', flag: '🇳🇬', minLength: 10, maxLength: 10),
    Country(name: "Côte d'Ivoire", isoCode: 'CI', dialCode: '+225', flag: '🇨🇮', minLength: 10, maxLength: 10),
    Country(name: 'Senegal', isoCode: 'SN', dialCode: '+221', flag: '🇸🇳', minLength: 9, maxLength: 9),
    Country(name: 'Ghana', isoCode: 'GH', dialCode: '+233', flag: '🇬🇭', minLength: 9, maxLength: 9),
    Country(name: 'Gabon', isoCode: 'GA', dialCode: '+241', flag: '🇬🇦', minLength: 7, maxLength: 8),
    Country(name: 'Congo', isoCode: 'CG', dialCode: '+242', flag: '🇨🇬', minLength: 9, maxLength: 9),
    Country(name: 'DR Congo', isoCode: 'CD', dialCode: '+243', flag: '🇨🇩', minLength: 9, maxLength: 9),
    Country(name: 'Togo', isoCode: 'TG', dialCode: '+228', flag: '🇹🇬', minLength: 8, maxLength: 8),
    Country(name: 'Benin', isoCode: 'BJ', dialCode: '+229', flag: '🇧🇯', minLength: 8, maxLength: 10),
    Country(name: 'Mali', isoCode: 'ML', dialCode: '+223', flag: '🇲🇱', minLength: 8, maxLength: 8),
    Country(name: 'Burkina Faso', isoCode: 'BF', dialCode: '+226', flag: '🇧🇫', minLength: 8, maxLength: 8),
    Country(name: 'France', isoCode: 'FR', dialCode: '+33', flag: '🇫🇷', minLength: 9, maxLength: 9),
    Country(name: 'Belgium', isoCode: 'BE', dialCode: '+32', flag: '🇧🇪', minLength: 8, maxLength: 9),
    Country(name: 'United States', isoCode: 'US', dialCode: '+1', flag: '🇺🇸', minLength: 10, maxLength: 10),
    Country(name: 'United Kingdom', isoCode: 'GB', dialCode: '+44', flag: '🇬🇧', minLength: 10, maxLength: 10),
    Country(name: 'Canada', isoCode: 'CA', dialCode: '+1', flag: '🇨🇦', minLength: 10, maxLength: 10),
  ];
}

/// Phone number field with a country-code selector.
///
/// Champ de numéro de téléphone avec sélecteur d'indicatif pays.
///
/// Controlled component: the parent owns [controller] (the national number) and
/// [country], reacting to [onCountryChanged]. Compose the full number with
/// `country.e164(controller.text)`.
class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    required this.label,
    required this.hint,
    required this.pickerTitle,
    this.validator,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final Country country;
  final ValueChanged<Country> onCountryChanged;
  final String label;
  final String hint;
  final String pickerTitle;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  Future<void> _openCountryPicker(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final selected = await showModalBottomSheet<Country>(
      context: context,
      backgroundColor: AppColors.obsidianLight,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CountryPickerSheet(
        title: pickerTitle,
        selected: country,
      ),
    );
    if (selected != null) {
      onCountryChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country selector.
            _CountrySelectorButton(
              country: country,
              enabled: enabled,
              onTap: () => _openCountryPicker(context),
            ),
            const SizedBox(width: 8),
            // National number field.
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.phone,
                textInputAction: textInputAction,
                onFieldSubmitted: onFieldSubmitted,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(country.maxLength + 4),
                ],
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: AppColors.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CountrySelectorButton extends StatelessWidget {
  const _CountrySelectorButton({
    required this.country,
    required this.enabled,
    required this.onTap,
  });

  final Country country;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.containerSurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mutedText, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(country.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                country.dialCode,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scrollable, searchable country list shown in a modal bottom sheet.
///
/// Liste de pays défilante et filtrable affichée dans une feuille modale.
class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.title, required this.selected});

  final String title;
  final Country selected;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<Country> _filtered = Country.supported;
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? Country.supported
          : Country.supported
              .where((c) =>
                  c.name.toLowerCase().contains(q) || c.dialCode.contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mutedText,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _search,
                  onChanged: _onSearch,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryText,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search…',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final c = _filtered[index];
                    final isSelected = c.isoCode == widget.selected.isoCode;
                    return ListTile(
                      onTap: () => Navigator.of(context).pop(c),
                      leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                      title: Text(
                        c.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: AppColors.primaryText,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: Text(
                        c.dialCode,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppColors.royalBlue.withValues(alpha: 0.08),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
