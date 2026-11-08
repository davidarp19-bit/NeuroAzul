import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import 'sync_viewmodel.dart';

class SyncStatusScreen extends ConsumerStatefulWidget {
  final String profileId;

  const SyncStatusScreen({super.key, required this.profileId});

  @override
  ConsumerState<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends ConsumerState<SyncStatusScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(syncViewModelProvider.notifier)
          .loadPending(profileId: widget.profileId);
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(syncViewModelProvider.notifier)
        .loadPending(profileId: widget.profileId);
  }

  Future<void> _sync() async {
    await ref
        .read(syncViewModelProvider.notifier)
        .syncPending(profileId: widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(syncViewModelProvider);

    final hasPending = state.pendingCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización'),
        leading: IconButton(
          onPressed: () {
            context.go('/child/${widget.profileId}/menu');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: state.isLoading || state.isSyncing ? null : _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  Icon(
                    hasPending
                        ? Icons.sync_problem_outlined
                        : Icons.cloud_done_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    hasPending
                        ? 'Sincronización pendiente'
                        : 'Todo está sincronizado',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    state.isLoading
                        ? 'Consultando el almacenamiento local...'
                        : hasPending
                        ? '${state.pendingCount} intento(s) pendiente(s) de sincronización.'
                        : 'No existen intentos pendientes para este perfil.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(
                              Icons.storage_outlined,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Intentos pendientes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.pendingCount}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (state.message != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        state.message!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: state.isSyncing || !hasPending ? null : _sync,
                      icon: state.isSyncing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync),
                      label: Text(
                        state.isSyncing
                            ? 'Sincronizando...'
                            : 'Sincronizar ahora',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: state.isLoading || state.isSyncing
                          ? null
                          : _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Actualizar estado'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
