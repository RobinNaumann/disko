extension ByteFormat on int {
  String get bytes {
    if (this < 1024) return '$this B';
    if (this < 1048576) return '${(this / 1024).toStringAsFixed(2)} KB';
    if (this < 1073741824) return '${(this / 1048576).toStringAsFixed(2)} MB';
    return '${(this / 1073741824).toStringAsFixed(2)} GB';
  }
}
