import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:antibet/models/diary_entry.dart';
import 'package:antibet/services/database_service.dart';
import 'package:antibet/theme.dart';
import 'package:antibet/widgets/gradient_card.dart';

class EntryWizardScreen extends StatefulWidget {
  const EntryWizardScreen({super.key});

  @override
  State<EntryWizardScreen> createState() => _EntryWizardScreenState();
}

class _EntryWizardScreenState extends State<EntryWizardScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  final _dbService = DatabaseService();
  int _currentStep = 0;
  bool _isSaving = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _circumstancesController =
      TextEditingController();
  final TextEditingController _triggerController = TextEditingController();
  final TextEditingController _thoughtsController = TextEditingController();
  final TextEditingController _sensationsController = TextEditingController();
  final TextEditingController _actionsController = TextEditingController();
  final TextEditingController _consequencesController = TextEditingController();

  // Для слайдера интенсивности (0-10)
  double _intensityValue = 0.0;

  final List<String> _stepKeys = [
    'place',
    'company',
    'circumstances',
    'trigger',
    'thoughts',
    'sensations',
    'intensity',
    'actions',
    'consequences',
  ];

  final Map<String, String> _titles = {
    'place': 'Местоположение',
    'company': 'Окружение',
    'circumstances': 'Обстоятельства',
    'trigger': 'Триггеры',
    'thoughts': 'Мысли',
    'sensations': 'Телесные ощущения',
    'intensity': 'Интенсивность тяги',
    'actions': 'Действия',
    'consequences': 'Последствия',
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
    'intensity':
        'Оцените силу вашего желания играть по шкале от 1 до 10, где 1 — легкое желание, которое можно игнорировать, а 10 — неконтролируемая тяга, которая полностью захватывает внимание. \nПримеры: \n - 1-3: Легкое желание, можно отвлечься. \n - 4-6: Умеренная тяга, требует усилий для сопротивления. \n - 7-8: Сильное желание, трудно думать о чем-то другом. \n - 9-10: Очень сильная тяга, почти неконтролируемая.',
    'actions':
        'Как вы отреагировали на желание? Опишите ваши действия честно. Это поможет понять, что помогает вам держаться, а что предшествует срыву. \nПримеры действий: \n - Позвонил наставнику. \n - Включил блокировку сайта. \n - Ушел с головой в работу. \n - Отвлекся на социальную сеть, чтобы убить время. \n - Зашёл на сайт или в приложение «просто посмотреть».\n - Не сдержался и сделал ставку.',
    'consequences':
        'Заполняйте только в случае срыва. Опишите финансовые потери и ваше эмоциональное состояние после игры, чтобы зафиксировать реальную цену срыва. \nПримеры: \n - Проиграл 10 000 рублей, отложенных на аренду. Чувствую опустошение и страх перед завтрашним днем. \n - Сначала выиграл, но не смог остановиться и слил всё под ноль и залез в кредитку. Минус 25 000 рублей. \n - Поднял с фрибета, вывел. Через два дня снова зашёл, всё слил и набрал три МФО.',
  };

  String get _currentKey => _stepKeys[_currentStep];

  bool get _hasAnyInput {
    return _placeController.text.isNotEmpty ||
        _companyController.text.isNotEmpty ||
        _circumstancesController.text.isNotEmpty ||
        _triggerController.text.isNotEmpty ||
        _thoughtsController.text.isNotEmpty ||
        _sensationsController.text.isNotEmpty ||
        _intensityValue > 0 ||
        _actionsController.text.isNotEmpty ||
        _consequencesController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    _placeController.dispose();
    _companyController.dispose();
    _circumstancesController.dispose();
    _triggerController.dispose();
    _thoughtsController.dispose();
    _sensationsController.dispose();
    _actionsController.dispose();
    _consequencesController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasAnyInput) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти без сохранения?'),
        content: const Text(
          'Вы начали заполнять запись. Если выйдете сейчас, данные не сохранятся.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Остаться',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkModeColors.iconColor
                    : LightModeColors.iconColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Выйти',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  void _handleClose() async {
    if (await _onWillPop()) {
      if (mounted) context.pop();
    }
  }

  void _nextStep() {
    final currentKey = _stepKeys[_currentStep];

    // Интенсивность (6) и Последствия (8) — опциональные шаги, пропускаем валидацию
    final isOptionalStep = _currentStep == 6 || _currentStep == 8;
    if (!isOptionalStep) {
      final controller = _getControllerForStep(_currentStep);
      if (controller == null || controller.text.trim().isEmpty) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Пожалуйста, заполните поле "${_titles[currentKey]}"'),
          ),
        );
        return;
      }
    }

    HapticFeedback.lightImpact();

    if (_currentStep < 8) {
      _fadeController.reverse().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() => _currentStep++);
        _fadeController.forward();
      });
    }
  }

  void _prevStep() {
    HapticFeedback.lightImpact();

    if (_currentStep > 0) {
      _fadeController.reverse().then((_) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() => _currentStep--);
        _fadeController.forward();
      });
    } else {
      _handleClose();
    }
  }

  Future<void> _saveEntry() async {
    final currentKey = _stepKeys[_currentStep];

    // Интенсивность (6) и Последствия (8) — опциональные, не требуем заполнения
    final isOptionalStep = _currentStep == 6 || _currentStep == 8;
    if (!isOptionalStep) {
      final controller = _getControllerForStep(_currentStep);
      if (controller == null || controller.text.trim().isEmpty) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Пожалуйста, заполните поле "${_titles[currentKey]}"'),
          ),
        );
        return;
      }
    }

    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);

    try {
      final entry = DiaryEntry(
        id: const Uuid().v4(),
        date: DateTime.now(),
        place: _placeController.text.trim(),
        company: _companyController.text.trim(),
        circumstances: _circumstancesController.text.trim(),
        trigger: _triggerController.text.trim(),
        thoughts: _thoughtsController.text.trim(),
        sensations: _sensationsController.text.trim(),
        intensity: 'Интенсивность тяги ${_intensityValue.round()} из 10',
        actions: _actionsController.text.trim(),
        consequences: _consequencesController.text.trim(),
      );

      await _dbService.insertEntry(entry);
      HapticFeedback.heavyImpact();
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showHelpBottomSheet(String key) {
    // final title = _titles[key] ?? '';
    final fullHelp = _helpText[key] ?? '';
    final parts = fullHelp.split('\n');
    final examples =
        parts.length > 1 ? parts.skip(1).join('\n').trim() : fullHelp;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: AppSpacing.paddingLg,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? DarkModeColors.iconColor
                            : LightModeColors.iconColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Примеры и пояснения',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: SelectableText(
                    examples,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Понятно'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        );
      },
    );
  }

  TextEditingController? _getControllerForStep(int index) {
    switch (index) {
      case 0:
        return _placeController;
      case 1:
        return _companyController;
      case 2:
        return _circumstancesController;
      case 3:
        return _triggerController;
      case 4:
        return _thoughtsController;
      case 5:
        return _sensationsController;
      case 6:
        return null; // Интенсивность — слайдер, не контроллер
      case 7:
        return _actionsController;
      case 8:
        return _consequencesController;
      default:
        return null;
    }
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(9, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isCurrent ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? DarkModeColors.iconColor
                      : LightModeColors.iconColor)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(int index) {
    final key = _stepKeys[index];
    final controller = _getControllerForStep(index);
    final title = _titles[key]!;
    final help = _helpText[key]!;
    final isIntensityStep = index == 6;
    final isConsequencesStep = index == 8;
    final prompt = isIntensityStep
        ? 'Оцените силу желания играть'
        : isConsequencesStep
            ? 'Заполняйте только в случае срыва. Иначе нажмите «Сохранить».'
            : help.split('\n').first.trim();
    final isLastStep = index == 8;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Первая карточка: заголовок, описание и кнопка "Посмотреть примеры"
            GradientCard(
              radius: AppRadius.md,
              margin: EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      prompt,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            height: 1.5,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.icon(
                        onPressed: () => _showHelpBottomSheet(key),
                        icon: Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? DarkModeColors.iconColor
                              : LightModeColors.iconColor,
                        ),
                        label: const Text('Посмотреть примеры'),
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Вторая карточка: поле для ввода или слайдер — белое/чёрное, без окаймления
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkModeColors.inputField
                    : LightModeColors.inputField,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              clipBehavior: Clip.antiAlias,
              child: isIntensityStep
                  ? _buildIntensitySlider()
                  : TextField(
                      controller: controller,
                      autofocus: true,
                      scrollPadding: const EdgeInsets.only(bottom: 120),
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: isLastStep
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onSubmitted: (_) {
                        if (isLastStep) {
                          _saveEntry();
                        } else {
                          _nextStep();
                        }
                      },
                      maxLines: null,
                      minLines: 6,
                      decoration: InputDecoration(
                        hintText: isConsequencesStep
                            ? 'Опишите последствия срыва или оставьте пустым...'
                            : 'Ваш ответ...',
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: AppSpacing.paddingMd,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            fontSize: 16,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensitySlider() {
    // Вычисляем цвет на основе значения (от зеленого к красному)
    final progress = _intensityValue / 10.0;
    final color = Color.lerp(Colors.green, Colors.red, progress)!;

    return Padding(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Stack(
            alignment: Alignment.center,
            children: [
              // Фоновый градиент — по центру, на одной линии с треком слайдера
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) => Center(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [Colors.green, Colors.red],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Слайдер поверх градиента
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: color,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 24),
                  overlayColor: color.withValues(alpha: 0.12),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value: _intensityValue,
                  min: 0,
                  max: 10,
                  label: _intensityValue.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _intensityValue = value;
                    });
                    HapticFeedback.selectionClick();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '10',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _currentStep == 8;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _handleClose();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Шаг ${_currentStep + 1} из 9',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleClose,
          ),
          actions: [
            IconButton(
              tooltip: 'Подсказка',
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showHelpBottomSheet(_currentKey),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                itemBuilder: (context, index) => _buildStepContent(index),
              ),
            ),
            if (!isKeyboardVisible)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _prevStep,
                          icon: const Icon(Icons.arrow_back),
                          label: Text(_currentStep == 0 ? 'Отмена' : 'Назад'),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? DarkModeColors.secondaryButtonBackground
                                    : LightModeColors.secondaryButtonBackground,
                            foregroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? DarkModeColors.secondaryButtonText
                                    : LightModeColors.secondaryButtonText,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isSaving
                              ? null
                              : (isLastStep ? _saveEntry : _nextStep),
                          icon: Icon(
                            isLastStep ? Icons.check : Icons.arrow_forward,
                          ),
                          label: Text(isLastStep ? 'Сохранить' : 'Далее'),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
