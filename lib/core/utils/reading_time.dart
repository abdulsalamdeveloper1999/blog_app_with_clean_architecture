int readingTime(String content) {
  final words = content.split(RegExp(r'\s+')).length;

  final readingTime = words / 225;

  return readingTime.ceil();
}
