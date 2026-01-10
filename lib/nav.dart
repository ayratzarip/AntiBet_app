import 'package:go_router/go_router.dart';
import 'package:antibet/screens/dashboard_screen.dart';
import 'package:antibet/screens/entry_form_screen.dart';
import 'package:antibet/screens/entry_wizard_screen.dart';
import 'package:antibet/screens/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/entry/new',
        name: 'new_entry',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: EntryWizardScreen(),
        ),
      ),
      GoRoute(
        path: '/entry/:id',
        name: 'entry',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == 'new') {
            return const NoTransitionPage(
              child: EntryWizardScreen(),
            );
          }
          return NoTransitionPage(
            child: EntryFormScreen(entryId: id),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SettingsScreen(),
        ),
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
}
