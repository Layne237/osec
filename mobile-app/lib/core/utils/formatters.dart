/// Locale-aware display formatters that avoid pulling in `intl` locale data
/// initialization (which would otherwise need `initializeDateFormatting`).
///
/// Formateurs d'affichage adaptés à la locale, sans initialisation des données
/// de locale d'`intl`.
class Formatters {
  Formatters._();

  /// Formats a monetary [amount] with its [currency] code, grouping thousands.
  ///
  /// French uses a non-breaking space as the group separator (`45 000 XAF`),
  /// English uses a comma (`45,000 XAF`). Amounts are rounded to whole units,
  /// which suits the XAF franc (no minor unit in everyday pricing).
  ///
  /// Formate un montant avec son code devise en groupant les milliers.
  static String price(double amount, String currency, {String locale = 'fr'}) {
    final separator = locale == 'fr' ? ' ' : ',';
    final grouped = _groupThousands(amount.round().abs().toString(), separator);
    final sign = amount < 0 ? '-' : '';
    return '$sign$grouped $currency';
  }

  /// Formats a timestamp as `dd/MM/yyyy HH:mm` in the device's local time.
  ///
  /// Formate un horodatage en `jj/MM/aaaa HH:mm` en heure locale.
  static String dateTime(DateTime value) {
    final local = value.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  static String _groupThousands(String digits, String separator) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
