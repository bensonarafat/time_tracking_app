extension DurationFormatting on Duration {
  String format() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

extension DateTimeFormatting on DateTime {
  String format() {
    final day = this.day;
    final month = this.month;
    final year = this.year;

    int hour = this.hour;
    final minute = this.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;

    return '$day/$month/$year $hour:$minute $period';
  }
}
