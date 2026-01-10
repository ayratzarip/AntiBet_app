import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:antibet/models/diary_entry.dart';
import 'package:antibet/services/database_service.dart';
import 'package:antibet/services/export_service.dart';
import 'package:antibet/theme.dart';
import 'package:antibet/widgets/gradient_card.dart';
import 'package:antibet/core/theme/app_shadows.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseService _dbService = DatabaseService();
  final ExportService _exportService = ExportService();
  final TextEditingController _searchController = TextEditingController();
  List<DiaryEntry> _entries = [];
  List<DiaryEntry> _filteredEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    try {
      final entries = await _dbService.getAllEntries();
      setState(() {
        _entries = entries;
        _filteredEntries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки записей: $e')),
        );
      }
    }
  }

  void _filterEntries(String query) {
    if (query.isEmpty) {
      setState(() => _filteredEntries = _entries);
    } else {
      setState(() {
        _filteredEntries = _entries
            .where((entry) =>
                entry.place.toLowerCase().contains(query.toLowerCase()) ||
                entry.company.toLowerCase().contains(query.toLowerCase()) ||
                entry.circumstances
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                entry.trigger.toLowerCase().contains(query.toLowerCase()) ||
                entry.thoughts.toLowerCase().contains(query.toLowerCase()) ||
                entry.sensations.toLowerCase().contains(query.toLowerCase()) ||
                entry.actions.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _exportData() async {
    try {
      await _exportService.exportToCSV(_entries);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные успешно экспортированы')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка экспорта: $e')),
        );
      }
    }
  }

  Future<void> _copyForAIAnalysis() async {
    final text = _exportService.formatForAI(_entries);
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Скопировано в буфер обмена для анализа AI')),
      );
    }
  }

  Future<void> _deleteEntry(DiaryEntry entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить запись'),
        content: const Text('Вы уверены, что хотите удалить эту запись?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _dbService.deleteEntry(entry.id);
        _loadEntries();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Запись удалена')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка удаления: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AntiBet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.push('/settings'),
            tooltip: 'Информация',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.25),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: Theme.of(context).brightness == Brightness.dark
                              ? 0.25
                              : 0.04,
                        ),
                        Colors.transparent,
                        Colors.white.withValues(
                          alpha: Theme.of(context).brightness == Brightness.dark
                              ? 0.03
                              : 0.5,
                        ),
                      ],
                      stops: const [0.0, 0.35, 1.0],
                    ),
                    boxShadow: AppShadows.inset(context),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск записей...',
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onChanged: _filterEntries,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _exportData,
                        icon: const Icon(Icons.share),
                        label: const Text('Экспорт CSV'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _copyForAIAnalysis,
                        icon: const Icon(Icons.psychology),
                        label: const Text('Копировать для AI'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEntries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Нет записей.\nНажмите + для создания первой записи.'
                                  : 'Нет совпадающих записей.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: AppSpacing.paddingMd,
                        itemCount: _filteredEntries.length,
                        itemBuilder: (context, index) {
                          final entry = _filteredEntries[index];
                          return EntryCard(
                            entry: entry,
                            onTap: () async {
                              await context.push('/entry/${entry.id}');
                              _loadEntries();
                            },
                            onDelete: () => _deleteEntry(entry),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/entry/new');
          _loadEntries();
        },
        icon: const Icon(Icons.add),
        label: const Text('Новая запись'),
      ),
    );
  }
}

class EntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return GradientCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      radius: AppRadius.md,
      shadowLevel: ShadowLevel.small,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(entry.date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    entry.place,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
