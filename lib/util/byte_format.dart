extension ByteFormat on int {
  String get bytes {
    if (this < 1000) return '$this B';
    if (this < 1000000) return '${(this / 1000).toStringAsFixed(2)} KB';
    if (this < 1000000000) return '${(this / 1000000).toStringAsFixed(2)} MB';
    return '${(this / 1000000000).toStringAsFixed(2)} GB';
  }
}
