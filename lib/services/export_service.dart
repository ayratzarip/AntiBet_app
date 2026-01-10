import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:antibet/models/diary_entry.dart';

class ExportService {
  Future<void> exportToCSV(List<DiaryEntry> entries) async {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    List<List<dynamic>> rows = [
      [
        'Дата',
        'Местоположение',
        'Компания',
        'Обстановка',
        'Триггер',
        'Мысли',
        'Ощущения',
        'Действия'
      ],
    ];

    for (var entry in entries) {
      rows.add([
        dateFormat.format(entry.date),
        entry.place,
        entry.company,
        entry.circumstances,
        entry.trigger,
        entry.thoughts,
        entry.sensations,
        entry.actions,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    await SharePlus.instance.share(
      ShareParams(
        text: csv,
        subject: 'AntiBet Diary Export',
      ),
    );
  }

  String formatForAI(List<DiaryEntry> entries) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final buffer = StringBuffer();

    buffer.writeln(
        '''Ты - опытный психотерапевт, специализирующийся на работе с зависимым поведением, помогающий пациенту с патологическим влечением к азартным играм. Пациент ведет дневник самонаблюдения в приложении "AntiBet" для отслеживания мыслей о игре и самокритики. Результаты анализа будут использованы на сеансах психотерапии.

Твои задачи:
1. Выяви триггеры и паттерны, которые провоцируют мысли об азартных играх.
2. Определи связь между обстоятельствами, эмоциональным состоянием и желанием играть.
3. Проанализируй, какие защитные механизмы использует пациент (отвлечение, запрет себе думать и т.д.).
4. Оцени динамику: становится ли пациенту легче справляться с влечением со временем.
5. Предложи рекомендации для терапевта и пациента.

Анализируй следующие записи из дневника:''');
    buffer.writeln();

    for (var entry in entries) {
      buffer.writeln('--- Entry ${dateFormat.format(entry.date)} ---');
      buffer.writeln('Place: ${entry.place}');
      buffer.writeln('Company: ${entry.company}');
      buffer.writeln('Circumstances: ${entry.circumstances}');
      buffer.writeln('Trigger: ${entry.trigger}');
      buffer.writeln('Thoughts: ${entry.thoughts}');
      buffer.writeln('Sensations: ${entry.sensations}');
      buffer.writeln('Actions: ${entry.actions}');
      buffer.writeln();
    }

    buffer.writeln(
        'Пожалуйста, предоставь структурированный анализ согласно пунктам выше. Будь тактичен и профессионален.');

    return buffer.toString();
  }
}
