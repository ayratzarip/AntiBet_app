import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DiaryEntry {
  final String id;
  final DateTime date;
  final String place;
  final String company;
  final String circumstances;
  final String trigger;
  final String thoughts;
  final String sensations;
  final String actions;

  DiaryEntry({
    String? id,
    DateTime? date,
    required this.place,
    required this.company,
    required this.circumstances,
    required this.trigger,
    required this.thoughts,
    required this.sensations,
    required this.actions,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  static final DateFormat _ruDateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat _legacyDashDateTimeFormat =
      DateFormat('yyyy-MM-dd HH:mm');

  Map<String, dynamic> toJson() => {
        'id': id,
        // В БД храним человекочитаемую дату в привычном RU-формате
        // и отдельное поле для корректной сортировки/фильтрации.
        'date': _ruDateTimeFormat.format(date),
        'dateMs': date.millisecondsSinceEpoch,
        'place': place,
        'company': company,
        'circumstances': circumstances,
        'trigger': trigger,
        'thoughts': thoughts,
        'sensations': sensations,
        'actions': actions,
      };

  static DateTime _parseDateFromDb(Map<String, dynamic> json) {
    final dateMs = json['dateMs'];
    if (dateMs is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateMs);
    }
    if (dateMs is num) {
      return DateTime.fromMillisecondsSinceEpoch(dateMs.toInt());
    }

    final raw = (json['date'] ?? '').toString();
    if (raw.isEmpty) return DateTime.now();

    try {
      // Старые версии могли хранить ISO8601.
      if (raw.contains('T')) return DateTime.parse(raw);
      // Старые экспорты/записи могли быть в формате yyyy-MM-dd HH:mm.
      if (raw.contains('-')) return _legacyDashDateTimeFormat.parseStrict(raw);
      // Текущий формат: dd.MM.yyyy HH:mm
      return _ruDateTimeFormat.parseStrict(raw);
    } catch (_) {
      return DateTime.now();
    }
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'] as String,
        date: _parseDateFromDb(json),
        place: json['place'] as String,
        company: json['company'] as String,
        circumstances: json['circumstances'] as String,
        trigger: json['trigger'] as String,
        thoughts: json['thoughts'] as String,
        sensations: json['sensations'] as String,
        actions: json['actions'] as String,
      );

  DiaryEntry copyWith({
    String? id,
    DateTime? date,
    String? place,
    String? company,
    String? circumstances,
    String? trigger,
    String? thoughts,
    String? sensations,
    String? actions,
  }) =>
      DiaryEntry(
        id: id ?? this.id,
        date: date ?? this.date,
        place: place ?? this.place,
        company: company ?? this.company,
        circumstances: circumstances ?? this.circumstances,
        trigger: trigger ?? this.trigger,
        thoughts: thoughts ?? this.thoughts,
        sensations: sensations ?? this.sensations,
        actions: actions ?? this.actions,
      );
}
