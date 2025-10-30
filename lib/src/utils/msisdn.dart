class MsisdnUtils {
  /// Normalize a local Zambian number to E.164 and MSISDN
  /// Examples:
  ///  - 097XXXXXXXX -> +26097XXXXXXXX (E.164), 26097XXXXXXXX (MSISDN)
  ///  - 2609XXXXXXXX -> +2609XXXXXXXX (E.164), 2609XXXXXXXX (MSISDN)
  static String toMsisdn(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('260')) return digits;
    if (digits.startsWith('0')) return '260${digits.substring(1)}';
    return digits;
  }

  static String toE164(String input) {
    final msisdn = toMsisdn(input);
    return '+$msisdn';
  }

  /// Attempt to detect operator from MSISDN prefix (Zambia)
  /// Airtel: 097/077, MTN: 096/076, Zamtel: 095/075 (common prefixes)
  static String? detectOperator(String input) {
    final msisdn = toMsisdn(input);
    if (msisdn.length < 5) return null;
    final prefix2 = msisdn.substring(3, 5); // after 260 -> next two digits
    switch (prefix2) {
      case '97':
      case '77':
        return 'airtel';
      case '96':
      case '76':
        return 'mtn';
      case '95':
      case '75':
        return 'zamtel';
      default:
        return null;
    }
  }
}
