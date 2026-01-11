import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:antibet/models/diary_entry.dart';
import 'package:antibet/services/database_service.dart';
import 'package:antibet/theme.dart';
import 'package:antibet/widgets/gradient_card.dart';

class EntryFormScreen extends StatefulWidget {
  final String? entryId;

  const EntryFormScreen({super.key, this.entryId});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _dbService = DatabaseService();

  Color _accentBlue(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeColors.iconColor
          : LightModeColors.iconColor;

  // Вспомогательный цвет для нейтральных иконок (как текст)
  Color _neutralIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static const Color _accentTeal = Color(0xFF08B0BB);
  static const Color _accentOrange = Color(0xFFFFA000);

  Color _iconAccent(BuildContext context, IconData icon) {
    if (icon == Icons.people || icon == Icons.psychology) return _accentTeal;
    if (icon == Icons.warning_amber_rounded) return _accentOrange;
    if (icon == Icons.favorite_border) {
      return Theme.of(context).colorScheme.error;
    }
    if (icon == Icons.check_circle_outline) return _accentTeal;
    // place, lightbulb
    if (icon == Icons.place || icon == Icons.lightbulb_outline) {
      return _accentBlue(context);
    }

    // calendar, help и другие нейтральные
    return _neutralIconColor(context);
  }

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _circumstancesController =
      TextEditingController();
  final TextEditingController _triggerController = TextEditingController();
  final TextEditingController _thoughtsController = TextEditingController();
  final TextEditingController _sensationsController = TextEditingController();
  final TextEditingController _actionsController = TextEditingController();

  DateTime _entryDate = DateTime.now();
  bool _isLoading = false;
  DiaryEntry? _existingEntry;

  final Map<String, String> _fieldLabels = {
    'place': 'Местоположение',
    'company': 'Окружение',
    'circumstances': 'Обстоятельства',
    'trigger': 'Триггеры',
    'thoughts': 'Мысли',
    'sensations': 'Телесные ощущения',
    'actions': 'Действия',
  };

  final Map<String, String> _helpText = {
    'place':
        'Где Вы находились в момент возникновения тяги? Окружающая обстановка может быть важным фактором. \nПримеры мест: \n - Дома (на диване, на кухне, в ванной). \n - На рабочем месте / В офисе. \n - В пути (в пробке, в метро, в такси). \n - На прогулке / В парке. \n - В магазине / ТЦ. \n - В гостях или заведении.',
    'company':
        'Были ли Вы одни или в компании? Социальный контекст часто влияет на наше состояние. Разные ситуации могут по-разному провоцировать желание играть: \n - В одиночестве: часто триггером становится скука, грусть или чувство свободы ("никто не увидит"). \n - С друзьями/знакомыми: социальное давление, разговоры о ставках, желание "быть как все". \n - В толпе: стресс или дискомфорт, от которых хочется "убежать" в игру.',
    'circumstances':
        'Что предшествовало возникновению тяги? Опишите Ваш общий эмоциональный фон или события, которые могли повлиять. \nКакие могут быть обстоятельства: \n - Физическое состояние: усталость, голод, опьянение, недосып. \n - Эмоции: стресс, тревога, скука, одиночество, злость, радость (эйфория). \n - События: конфликт, проблемы на работе, получение денег, свободное время.',
    'trigger':
        'Постарайтесь определить конкретный момент, событие или мысль, которые запустили желание играть. \nЧто может быть триггером: \n - Внешние: реклама, вывески, SMS-уведомления, просмотр спорта, разговоры других людей. \n - Финансовые: необходимость отдать долг, получение денег, нехватка средств. \n - Внутренние: внезапное воспоминание о выигрыше, фантазия об успехе, скука, желание "быстрых денег".',
    'thoughts':
        'О чем Вы подумали в этот момент? Постарайтесь просто зафиксировать поток мыслей, не осуждая себя. \nЧастые мысли: \n - "Только один раз, и всё". \n - "Мне нужно отыграться". \n - "Сегодня точно повезет". \n - "Я неудачник, всё равно уже всё потерял". \n - "Как отдать долги? Только игрой"',
    'sensations':
        'Тяга к игре часто отражается в теле. Попробуйте заметить напряжение, учащенное сердцебиение или другие сигналы организма. \nПри желании играть часто возникают: \n - Учащенное сердцебиение, волнение. \n - Напряжение в груди или животе. \n - Дрожь в руках, потливость. \n - Ощущение жара или холода. \n - Сжатие в горле, трудно дышать.',
    'actions':
        'Как Вы справляетесь с возникшим желанием? Опишите, что Вы сделали, чтобы не поддаться импульсу, или как планируете поступить. \nПримеры действий: \n - Пытаюсь отвлечься на работу или хобби. \n - Запрещаю себе думать об этом. \n - Звоню другу или близкому человеку. \n - Иду на прогулку или в спортзал. \n - Делаю дыхательные упражнения. \n - Записываю мысли в дневник. \n - Читаю мотивирующие материалы.',
  };

  @override
  void initState() {
    super.initState();
    if (widget.entryId != null && widget.entryId != 'new') {
      _loadEntry();
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    _companyController.dispose();
    _circumstancesController.dispose();
    _triggerController.dispose();
    _thoughtsController.dispose();
    _sensationsController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  Future<void> _loadEntry() async {
    setState(() => _isLoading = true);
    try {
      final entries = await _dbService.getAllEntries();
      final entry = entries.firstWhere((e) => e.id == widget.entryId);
      setState(() {
        _existingEntry = entry;
        _entryDate = entry.date;
        _placeController.text = entry.place;
        _companyController.text = entry.company;
        _circumstancesController.text = entry.circumstances;
        _triggerController.text = entry.trigger;
        _thoughtsController.text = entry.thoughts;
        _sensationsController.text = entry.sensations;
        _actionsController.text = entry.actions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading entry: $e')),
        );
        context.pop();
      }
    }
  }

  void _showHelp(String field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подсказка: ${_fieldLabels[field] ?? field}'),
        content: Text(_helpText[field] ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final entry = DiaryEntry(
        id: _existingEntry?.id,
        date: _entryDate,
        place: _placeController.text.trim(),
        company: _companyController.text.trim(),
        circumstances: _circumstancesController.text.trim(),
        trigger: _triggerController.text.trim(),
        thoughts: _thoughtsController.text.trim(),
        sensations: _sensationsController.text.trim(),
        actions: _actionsController.text.trim(),
      );

      if (_existingEntry != null) {
        await _dbService.updateEntry(entry);
      } else {
        await _dbService.insertEntry(entry);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_existingEntry != null
                  ? 'Запись обновлена'
                  : 'Запись сохранена')),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving entry: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _existingEntry != null ? 'Редактировать запись' : 'Новая запись'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppSpacing.paddingMd,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GradientCard(
                      radius: AppRadius.md,
                      child: Padding(
                        padding: AppSpacing.paddingMd,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color:
                                    _iconAccent(context, Icons.calendar_today)),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              DateFormat('dd.MM.yyyy HH:mm').format(_entryDate),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTextField(
                      controller: _placeController,
                      label: 'Местоположение',
                      icon: Icons.place,
                      helpKey: 'place',
                      maxLines: 1,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _companyController,
                      label: 'Окружение',
                      icon: Icons.people,
                      helpKey: 'company',
                      maxLines: 1,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _circumstancesController,
                      label: 'Обстоятельства',
                      icon: Icons.psychology,
                      helpKey: 'circumstances',
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _triggerController,
                      label: 'Триггеры',
                      icon: Icons.warning_amber_rounded,
                      helpKey: 'trigger',
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _thoughtsController,
                      label: 'Мысли',
                      icon: Icons.lightbulb_outline,
                      helpKey: 'thoughts',
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _sensationsController,
                      label: 'Телесные ощущения',
                      icon: Icons.favorite_border,
                      helpKey: 'sensations',
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTextField(
                      controller: _actionsController,
                      label: 'Действия',
                      icon: Icons.check_circle_outline,
                      helpKey: 'actions',
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton.icon(
                      onPressed: _saveEntry,
                      icon: const Icon(Icons.save),
                      label: Text(_existingEntry != null
                          ? 'Обновить запись'
                          : 'Сохранить запись'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String helpKey,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: _iconAccent(context, icon)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            InkWell(
              onTap: () => _showHelp(helpKey),
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.help_outline,
                size: 18,
                color: _iconAccent(context, Icons.help_outline),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Введите $label...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Пожалуйста, введите $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
