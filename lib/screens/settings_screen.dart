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
            _buildSection(
              context,
              icon: Icons.info_outline,
              title: 'О приложении AntiBet',
              content: '''
AntiBet - это безопасное, приватное приложение для самоконтроля, разработанное для людей, борющихся с зависимостью от азартных игр. Это приложение следует принципам когнитивно-поведенческой терапии (КПТ) для помощи в отслеживании триггеров, мыслей и реакций.

Постоянно записывая свои наблюдения, вы можете идентифицировать паттерны и развивать более здоровые стратегии выхода из ситуаций.''',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSection(
              context,
              icon: Icons.psychology,
              title: 'Как пользоваться дневником',
              content: '''
Нажмите кнопку «Новая запись» внизу экрана. Последовательно заполните 7 шагов самонаблюдения. Это поможет Вам лучше понять природу Вашего влечения и научиться справляться с ним. Будьте честны с собой — это Ваш личный инструмент.

Важно: Дневник следует заполнять не только когда появляются мысли про игру (тяга), но и когда появляется самокритика, связанная с долгами или проигрышами, — мысли в духе "никогда больше...". Это тоже часть цикла зависимости, которую важно отслеживать.

Вы можете вернуться к любой записи и дополнить её. Нажмите на карточку записи на главном экране, чтобы внести изменения. Рефлексия постфактум также очень полезна.

ЧТО ПИСАТЬ В ОПИСАНИИ

1. Место
Где вы находились, когда появились мысли об игре? Например: дома на диване, в офисе, в машине, в торговом центре.

2. Свидетели
Были ли вы одни или с кем-то? С знакомыми людьми, с посторонними или в толпе? Это помогает понять социальный контекст.

3. Обстоятельства
Опишите фон: ваше состояние, события перед этим. Например: устал после работы, голоден, поругался с близкими, получил деньги, было скучно.

4. Триггер
Что конкретно спровоцировало мысли об игре? Реклама казино, разговор о выигрыше, воспоминание, финансовые трудности?

5. Мысли
Какие мысли появились? Желание сыграть, воспоминания о выигрышах/проигрышах, самокритика, стыд из-за долгов? Запишите всё честно.

6. Телесные ощущения
Что происходило в теле? Учащенное сердцебиение, напряжение в груди, дрожь, потливость, ком в горле? Эмоции всегда отражаются физически.

7. Действия
Что вы делали в ответ на мысли об игре? Пытались отвлечься, запрещали себе думать, звонили другу, шли гулять? Это помогает увидеть ваши стратегии.

РАБОТА С AI-ПОМОЩНИКОМ

Используйте функцию "Скопировать для AI", чтобы получить профессиональный анализ Ваших записей. Вставьте скопированный текст в чат с ChatGPT, DeepSeek или другой ИИ-чат для выявления скрытых паттернов и получения рекомендаций.''',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSection(
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
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return GradientCard(
      radius: AppRadius.md,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
