import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import '../../services/establecimientos_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/dashboard_stat_card.dart';
import '../../widgets/module_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int? _totalEstablecimientos;
  bool _loadingTotals = true;

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  Future<void> _loadTotals() async {
    setState(() {
      _loadingTotals = true;
    });
    try {
      final results = await Future.wait([
        _fetchTotalEstablecimientos(),
      ]);
      if (mounted) {
        setState(() {
          _totalEstablecimientos = results[0];
          _loadingTotals = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingTotals = false;
        });
      }
    }
  }

  Future<int?> _fetchTotalEstablecimientos() async {
    try {
      final lista = await EstablecimientosService.instance.getAll();
      return lista.length;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Panel Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualizar totales',
            onPressed: _loadTotals,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTotals,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),

              Text(
                'Resumen general',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _buildStatRow(context),
              const SizedBox(height: 32),

              Text(
                'Módulos',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),

              ModuleCard(
                icon: Icons.car_crash_rounded,
                iconColor: AppTheme.error,
                title: 'Estadísticas de Accidentes',
                description:
                    'Visualiza gráficas por clase, gravedad, barrios y días de la semana. Datos procesados con Isolate.',
                onTap: () => context.push(AppRoutes.accidentes),
              ),
              const SizedBox(height: 12),

              ModuleCard(
                icon: Icons.store_rounded,
                iconColor: AppTheme.primary,
                title: 'Establecimientos',
                description:
                    'Crea, edita y elimina establecimientos. Sube el logo de cada uno.',
                onTap: () => context.push(AppRoutes.establecimientos),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido 👋',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Panel de Control',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Accidentes viales y gestión de establecimientos',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DashboardStatCard(
            label: 'Establecimientos',
            value: _loadingTotals
                ? null
                : (_totalEstablecimientos?.toString() ?? '–'),
            icon: Icons.store_rounded,
            color: AppTheme.primary,
            onTap: () => context.push(AppRoutes.establecimientos),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DashboardStatCard(
            label: 'Módulo Accidentes',
            value: _loadingTotals ? null : '100K+',
            icon: Icons.car_crash_rounded,
            color: AppTheme.error,
            onTap: () => context.push(AppRoutes.accidentes),
          ),
        ),
      ],
    );
  }
}
