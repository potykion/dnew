import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'dt.freezed.dart';

/// @nodoc
extension DurationUtils on Duration {
  /// Форматирует дюрейшн без нулей впереди и без миллисекунд, типа 1:02:03
  String format() => [
        inHours > 0 ? inHours : null,
        // Если минуток 0, то все равно показываем 0,
        // чтобы было не +10, а +00:10
        inMinutes > 0 ? inMinutes % 60 : 0,
        inSeconds % 60
      ]
          .where((d) => d != null)
          .toList()
          .asMap()
          .entries
          .map((e) => e.value.toString().padLeft(2, "0"))
          .join(":");
}

/// Форматирует время (20:43)
String formatTime(DateTime time) => DateFormat.Hm().format(time);

/// Собирает дейттайм из даты и времени
DateTime buildDateTime(DateTime date, DateTime time) => DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

/// Определяет день, когда месяц заканчивается
int endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;

/// Определяет номер дня в рамках года
int yearDayNum(DateTime date) =>
    date.difference(DateTime(date.year, 1, 1)).inDays + 1;

/// Определяет номер недели в рамках года
int yearWeekNum(DateTime date) {
  var yearStartWeek = DateTime(date.year, 1, 1)
      .subtract(Duration(days: DateTime(date.year, 1, 1).day));

  return date.difference(yearStartWeek).inDays ~/ 7 + 1;
}

/// @nodoc
extension DateTimeUtils on DateTime {
  /// Создает дейт тайм без времени, то есть просто дейт
  DateTime date() => DateTime(year, month, day);

  /// Создает дейт тайм с фиксированной датой, то есть просто тайм
  DateTime time({bool withSeconds = false, DateTime? date}) => buildDateTime(
        date ?? DateTime(2020, 1, 1),
        DateTime(
          2020,
          1,
          1,
          hour,
          minute,
          withSeconds ? second : 0,
        ),
      );

  /// Определяет, является ли дата сегодняшней
  bool isToday() => date() == DateTime.now().date();

  /// Форматирует дату в формате 2/3/2021
  String format() => DateFormat.yMd().format(this);

  /// Создает новый дейт-тайм с измененной компонентой
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
      );

  /// Находится ли дейттайм между двух дейттаймов
  bool isBetween(DateTime from, DateTime to) =>
      (isAfter(from) || isAtSameMomentAs(from)) &&
      (isBefore(to) || isAtSameMomentAs(to));
}

/// Дейт-ренж - класс с двумя дейт-таймами: дейт-тайм с, дейт-тайм по
@freezed
abstract class DateRange with _$DateRange {
  const DateRange._();

  /// Дейт-ренж - класс с двумя дейт-таймами: дейт-тайм с, дейт-тайм по
  factory DateRange(
    /// Дейт-тайм с
    DateTime from,

    /// Дейт-тайм по
    DateTime to,
  ) = _DateRange;

  /// Создает дейт-ренж из даты, времени с и времени по
  /// Если время с > времени по => дейт-ренж сквозной
  /// Например, дата - 2020-01-01, время с - 10:00, а время по - 02:00 =>
  /// дейт-ренж с 2020-01-01 10:00 по 2020-01-02 02:00
  factory DateRange.fromDateAndTimes(
          DateTime date, DateTime fromTime, DateTime toTime) =>
      DateRange(
        buildDateTime(date, fromTime),
        buildDateTime(
          date.add(Duration(days: fromTime.isAfter(toTime) ? 1 : 0)),
          toTime,
        ),
      );

  /// Находится ли {dateTime} в ренже
  bool containsDateTime(DateTime dateTime) =>
      (dateTime.isAfter(from) || dateTime.isAtSameMomentAs(from)) &&
      (dateTime.isBefore(to) || dateTime.isAtSameMomentAs(to));

  /// Дата дейт-ренжа
  DateTime get date => from.date();

  /// Создает дейт-ренж из дейт-тайма, времени с, времени по
  /// Например, дейт-тайм - 2020-01-02 01:00,
  ///   время с - 10:00, а время по - 02:00 =>
  /// дейт-ренж с 2020-01-01 10:00 по 2020-01-02 02:00 =>
  /// дейт-тайм относится к 2020-01-01, а не к 2020-01-02
  factory DateRange.fromDateTimeAndTimes(
    DateTime dateTime,
    DateTime fromTime,
    DateTime toTime,
  ) {
    var dateDateRange = DateRange.fromDateAndTimes(
      dateTime,
      fromTime,
      toTime,
    );
    var previousDateDateRange = DateRange.fromDateAndTimes(
      dateTime.add(Duration(days: -1)),
      fromTime,
      toTime,
    );

    return [dateDateRange, previousDateDateRange].firstWhere(
      (dr) => dr.containsDateTime(dateTime),
      orElse: () => dateDateRange,
    );
  }

  /// Создает дейтренж в ределах минуты
  factory DateRange.withinMinute(DateTime dateTimeWithoutSeconds) {
    return DateRange(
      DateTime(
        dateTimeWithoutSeconds.year,
        dateTimeWithoutSeconds.month,
        dateTimeWithoutSeconds.day,
        dateTimeWithoutSeconds.hour,
        dateTimeWithoutSeconds.minute,
      ),
      DateTime(
        dateTimeWithoutSeconds.year,
        dateTimeWithoutSeconds.month,
        dateTimeWithoutSeconds.day,
        dateTimeWithoutSeconds.hour,
        dateTimeWithoutSeconds.minute,
        59,
      ),
    );
  }

  /// Создает дейтренж за месяц
  /// DateRange.withinWeek(DateTime(2021, 3, 1)) ==
  /// DateRange(DateTime(2021, 3, 1), DateTime(2021, 3, 31))
  factory DateRange.withinMonth(DateTime initial) => DateRange(
        DateTime(initial.year, initial.month, 1),
        DateTime(initial.year, initial.month, endOfMonth(initial)),
      );

  /// Пересекаюьтся ли дейтренжи
  bool intersects(DateRange dr) {
    var fromIntersects = dr.from.isBetween(from, to);
    var toIntersects = dr.to.isBetween(from, to);
    return fromIntersects || toIntersects;
  }

  /// Создает дейтренж за неделю
  /// DateRange.withinWeek(DateTime(2021, 3, 31)) ==
  /// DateRange(DateTime(2021, 3, 29), DateTime(2021, 4, 4))
  factory DateRange.withinWeek(DateTime initial) {
    var weekStart = initial.add(Duration(days: -initial.weekday + 1));
    return DateRange(weekStart, weekStart.add(Duration(days: 6)));
  }

  /// Считает скок недель в дейтренже
  /// Напр. в [2021-03-01, 2021-03-31] - 5 недель
  int get weeksFrom {
    var weeks = 0;
    var fromWeek = DateRange.withinWeek(from);

    while (true) {
      if (intersects(fromWeek)) {
        weeks += 1;
      } else {
        break;
      }

      fromWeek = DateRange(
        fromWeek.from.add(Duration(days: 7)),
        fromWeek.to.add(Duration(days: 7)),
      );
    }

    return weeks;
  }
}
