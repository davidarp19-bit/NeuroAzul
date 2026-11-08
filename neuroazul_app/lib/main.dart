import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/database/database_providers.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!SupabaseConfig.isConfigured) {
    throw Exception(
      'Supabase no está configurado. '
      'Verifica SUPABASE_URL y SUPABASE_PUBLISHABLE_KEY.',
    );
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const ProviderScope(child: NeuroAzulApp()));
}

class NeuroAzulApp extends ConsumerWidget {
  const NeuroAzulApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseWarmup = ref.watch(localDatabaseWarmupProvider);

    return databaseWarmup.when(
      loading: () {
        return MaterialApp(
          title: 'NeuroAzul',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Preparando almacenamiento local...'),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return MaterialApp(
          title: 'NeuroAzul',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No fue posible iniciar el almacenamiento local.\n'
                  '$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
      data: (_) {
        return MaterialApp.router(
          title: 'NeuroAzul',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
