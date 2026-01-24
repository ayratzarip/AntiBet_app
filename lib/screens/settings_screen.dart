import 'package:flutter/material.dart';
import 'package:antibet/theme.dart';
import 'package:antibet/widgets/gradient_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              radius: AppRadius.md,
              child: Column(
                children: [
                  _buildExpandableSection(
                    context,
                    icon: Icons.info_outline,
                    title: 'О приложении AntiBet',
                    content: '''
AntiBet - это безопасное, приватное приложение для самоконтроля, разработанное для людей, борющихся с зависимостью от азартных игр. Это приложение следует принципам когнитивно-поведенческой терапии (КПТ) для помощи в отслеживании триггеров, мыслей и реакций.

Постоянно записывая свои наблюдения, вы можете идентифицировать паттерны и развивать более здоровые стратегии выхода из ситуаций.''',
                  ),
                  _buildDivider(context),
                  _buildExpandableSection(
                    context,
                    icon: Icons.psychology,
                    title: 'Как пользоваться дневником',
                    iconColor: const Color(0xFF08b0bb),
                    content: '''
Нажмите кнопку «Новая запись» внизу экрана. Последовательно заполните 9 шагов самонаблюдения. Это поможет Вам лучше понять природу Вашего влечения и научиться справляться с ним. Будьте честны с собой — это Ваш личный инструмент.

Важно: Дневник следует заполнять не только когда появляются мысли про игру (тяга), но и когда появляется самокритика, связанная с долгами или проигрышами, — мысли в духе "никогда больше...". Это тоже часть цикла зависимости, которую важно отслеживать.

Вы можете вернуться к любой записи и дополнить её. Нажмите на карточку записи на главном экране, чтобы внести изменения. Рефлексия постфактум также очень полезна.''',
                  ),
                  _buildDivider(context),
                  _buildExpandableSection(
                    context,
                    icon: Icons.edit_note,
                    title: 'Что писать в дневнике',
                    iconColor: const Color(0xFF08b0bb),
                    content: '''
1. Место
Где вы находились, когда появились мысли об игре? Например: дома на диване, в офисе, в машине, в торговом центре.

2. Окружение
Были ли вы одни или с кем-то? С знакомыми людьми, с посторонними или в толпе? Это помогает понять социальный контекст.

3. Обстоятельства
Опишите фон: ваше состояние, события перед этим. Например: устал после работы, голоден, поругался с близкими, получил деньги, было скучно.

4. Триггер
Что конкретно спровоцировало мысли об игре? Реклама казино, разговор о выигрыше, воспоминание, финансовые трудности?

5. Мысли
Какие мысли появились? Желание сыграть, воспоминания о выигрышах/проигрышах, самокритика, стыд из-за долгов? Запишите всё честно.

6. Телесные ощущения
Что происходило в теле? Учащенное сердцебиение, напряжение в груди, дрожь, потливость, ком в горле? Эмоции всегда отражаются физически.

7. Интенсивность тяги
Оцените силу желания играть по шкале от 1 до 10. Слайдер помогает зафиксировать силу влечения в момент записи.

8. Действия
Что вы делали в ответ на мысли об игре? Пытались отвлечься, звонили другу, шли гулять или, наоборот, зашли на сайт «просто посмотреть»? Опишите честно — это помогает увидеть ваши стратегии и зоны риска.

9. Последствия (необязательно)
Заполняйте только в случае срыва: финансовые потери, эмоции после игры. Если срыва не было — можно пропустить. Этот шаг при желании можно заполнить позже, в режиме редактирования записи.''',
                  ),
                  _buildDivider(context),
                  _buildExpandableSection(
                    context,
                    icon: Icons.auto_awesome,
                    title: 'Работа с AI помощником',
                    iconColor: const Color(0xFF9C27B0),
                    content: '''
Используйте функцию "Скопировать для AI", чтобы получить профессиональный анализ Ваших записей. Вставьте скопированный текст в чат с ChatGPT, DeepSeek или другим ИИ для выявления скрытых паттернов и получения рекомендаций.

Это поможет вам взглянуть на ситуацию со стороны и найти неочевидные связи в вашем поведении.''',
                  ),
                  _buildDivider(context),
                  _buildExpandableSection(
                    context,
                    icon: Icons.lock,
                    title: 'Политика конфиденциальности',
                    content: '''
Мы серьезно относимся к безопасности ваших данных и гарантируем полную приватность:

• Локальное хранение: Все записи хранятся исключительно на вашем устройстве в защищенной базе данных. Мы не имеем доступа к вашим данным и не отправляем их на сторонние серверы.

• Отсутствие облачной синхронизации: Ваши данные остаются приватными и никогда не покидают ваше устройство, пока вы сами не решите их экспортировать.

• Полная анонимность: Приложение не собирает аналитику, не отслеживает ваши действия и не использует сторонние сервисы наблюдения. Вы остаетесь полностью анонимным.

• Ваш контроль: Только вы решаете, делиться ли информацией (например, при экспорте CSV или копировании текста для AI-анализа).

• Безопасность: Ваши записи защищены так же надежно, как и любые другие файлы на вашем смартфоне.''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientCard(
              radius: AppRadius.md,
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Theme.of(context).colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Удаление приложения',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Внимание! Удаление приложения приведет к безвозвратной потере всех записей, так как они хранятся только на устройстве.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientCard(
              radius: AppRadius.md,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      // "Warning" акцент (лучше подходит, чем error-красный)
                      color: const Color(0xFFFFA000),
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Это приложение является инструментом самопомощи и не заменяет профессиональную терапию или медицинское лечение.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 2,
      thickness: 2,
      indent: AppSpacing.xl + 28, // Отступ под иконкой
      endIndent: 0,
      color: Theme.of(context).dividerColor.withValues(alpha: 1),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    Color? iconColor,
  }) {
    final effectiveIconColor = iconColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? DarkModeColors.iconColor
            : LightModeColors.iconColor);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        leading: Icon(
          icon,
          color: effectiveIconColor,
          size: 28,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
        ),
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
