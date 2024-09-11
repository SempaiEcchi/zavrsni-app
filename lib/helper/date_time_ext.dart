extension DateFormatExt on DateTime {
  String formatCroatianDate() {
    return "${day.toString().padLeft(2, "0")}.${month.toString().padLeft(2, "0")}.${year.toString().padLeft(4, "0")}";
  }

  String formatCroatianDateTime() {
    return "${day.toString().padLeft(2, "0")}.${month.toString().padLeft(2, "0")}.${year.toString().padLeft(4, "0")} ${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }
}
