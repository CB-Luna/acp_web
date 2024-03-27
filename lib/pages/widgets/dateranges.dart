import 'dart:developer';

void main() {
  // Find first date and last date of THIS WEEK
  DateTime today = DateTime.now();
  log(findFirstDateOfTheWeek(today).toString());
  log(findLastDateOfTheWeek(today).toString());

  // Find first date and last date of any provided date
  DateTime date = DateTime.parse('2020-11-24');
  log(findFirstDateOfTheWeek(date).toString());
  log(findLastDateOfTheWeek(date).toString());

  // Find first date and last date of LAST WEEK
  log('last week');
  log(findFirstDateOfPreviousWeek(today).toString());
  log(findLastDateOfPreviousWeek(today).toString());
}

/// Find the first date of the week which contains the provided date.
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

/// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

/// Find first date of previous week using a date in current week.
/// [dateTime] A date in current week.
DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
  return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
}

/// Find last date of previous week using a date in current week.
/// [dateTime] A date in current week.
DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
  return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
}

/// Find first date of next week using a date in current week.
/// [dateTime] A date in current week.
DateTime findFirstDateOfNextWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
  return findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
}

/// Find last date of next week using a date in current week.
/// [dateTime] A date in current week.
DateTime findLastDateOfNextWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
  return findLastDateOfTheWeek(sameWeekDayOfNextWeek);
}

DateTime findFirstDateOfTheMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month);
}

DateTime findLastDateOfTheMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month + 1, 0);
}

DateTime findFirstDateOfTheYear(DateTime dateTime) {
  return DateTime(dateTime.year);
}

DateTime findLastDateOfTheYear(DateTime dateTime) {
  return DateTime(dateTime.year + 1, 0, 31);
}

DateTime findFirstDateOfTheQuarter(DateTime dateTime) {
  if (dateTime.month == 1 || dateTime.month == 2 || dateTime.month == 3) {
    return DateTime(dateTime.year, 1, 1);
  } else if (dateTime.month == 4 || dateTime.month == 5 || dateTime.month == 6) {
    return DateTime(dateTime.year, 4, 1);
  } else if (dateTime.month == 7 || dateTime.month == 8 || dateTime.month == 9) {
    return DateTime(dateTime.year, 7, 1);
  } else if (dateTime.month == 10 || dateTime.month == 11 || dateTime.month == 12) {
    return DateTime(dateTime.year, 10, 1);
  }
  return dateTime;
}

DateTime findLastDateOfTheQuarter(DateTime dateTime) {
  if (dateTime.month == 1 || dateTime.month == 2 || dateTime.month == 3) {
    return DateTime(dateTime.year, 4, 0);
  } else if (dateTime.month == 4 || dateTime.month == 5 || dateTime.month == 6) {
    return DateTime(dateTime.year, 7, 0);
  } else if (dateTime.month == 7 || dateTime.month == 8 || dateTime.month == 9) {
    return DateTime(dateTime.year, 10, 0);
  } else if (dateTime.month == 10 || dateTime.month == 11 || dateTime.month == 12) {
    return DateTime(dateTime.year + 1, 1, 0);
  }
  return dateTime;
}

DateTime findFirstDateOfThePreviusQuarter(DateTime dateTime) {
  if (dateTime.month == 1 || dateTime.month == 2 || dateTime.month == 3) {
    return DateTime(dateTime.year - 1, 10, 1);
  } else if (dateTime.month == 4 || dateTime.month == 5 || dateTime.month == 6) {
    return DateTime(dateTime.year, 1, 1);
  } else if (dateTime.month == 7 || dateTime.month == 8 || dateTime.month == 9) {
    return DateTime(dateTime.year, 4, 1);
  } else if (dateTime.month == 10 || dateTime.month == 11 || dateTime.month == 12) {
    return DateTime(dateTime.year, 7, 1);
  }
  return dateTime;
}

DateTime findLastDateOfThePreviusQuarter(DateTime dateTime) {
  if (dateTime.month == 1 || dateTime.month == 2 || dateTime.month == 3) {
    return DateTime(dateTime.year, 1, 0);
  } else if (dateTime.month == 4 || dateTime.month == 5 || dateTime.month == 6) {
    return DateTime(dateTime.year, 4, 0);
  } else if (dateTime.month == 7 || dateTime.month == 8 || dateTime.month == 9) {
    return DateTime(dateTime.year, 7, 0);
  } else if (dateTime.month == 10 || dateTime.month == 11 || dateTime.month == 12) {
    return DateTime(dateTime.year, 10, 0);
  }
  return dateTime;
}
