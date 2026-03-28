import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
}

extension TextExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String toTitleCase() {
    return split(' ')
        .map((word) => word.capitalize())
        .join(' ');
  }

  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isValidPhoneNumber() {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[^\d]'), ''));
  }

  bool isStrongPassword() {
    if (length < 8) return false;
    final hasUppercase = contains(RegExp(r'[A-Z]'));
    final hasLowercase = contains(RegExp(r'[a-z]'));
    final hasDigit = contains(RegExp(r'\d'));
    final hasSpecialChar = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  String formatPhoneNumber() {
    final digits = replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return this;
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return '$day/$month/$year';
  }

  String toFormattedDateTimeString() {
    return '$day/$month/$year $hour:${minute.toString().padLeft(2, '0')}';
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }
}

extension NumExtension on num {
  String toStreetAddress() => toString();

  String formatCurrency() {
    return '\$${toStringAsFixed(2)}';
  }

  String formatWithCommas() {
    return toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

extension IntExtension on int {
  Duration toDuration() => Duration(seconds: this);
  
  String formatBytes() {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    double bytes = toDouble();
    int suffixIndex = 0;
    
    while (bytes >= 1024 && suffixIndex < suffixes.length - 1) {
      bytes /= 1024;
      suffixIndex++;
    }
    
    return '${bytes.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }
}

extension DoubleExtension on double {
  String toFormattedString({int decimals = 2}) {
    return toStringAsFixed(decimals);
  }

  String formatBmi() {
    return toStringAsFixed(1);
  }

  bool isBetween(double min, double max) {
    return this >= min && this <= max;
  }
}

extension ListExtension<T> on List<T> {
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  List<T> shuffled() {
    final list = [...this];
    list.shuffle();
    return list;
  }

  List<List<T>> chunked(int chunkSize) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += chunkSize) {
      chunks.add(sublist(i, i + chunkSize > length ? length : i + chunkSize));
    }
    return chunks;
  }
}

extension MapExtension<K, V> on Map<K, V> {
  V? getOrDefault(K key, V defaultValue) {
    return this[key] ?? defaultValue;
  }

  Map<K, V> merge(Map<K, V> other) {
    return {...this, ...other};
  }
}

extension WidgetExtension on Widget {
  Widget padded(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  Widget center() {
    return Center(child: this);
  }

  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  Widget withOpacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }
}
