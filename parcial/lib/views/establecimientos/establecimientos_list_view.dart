import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/establecimiento_model.dart';
import '../../routes/app_router.dart';
import '../../services/establecimientos_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/logo_widget.dart';

class EstablecimientosListView extends StatefulWidget {
  const EstablecimientosListView({super.key});

  @override
  State<EstablecimientosListView> createState() => _EstablecimientosListViewState();
}

class _EstablecimientosListViewState extends State<EstablecimientosListView> {
  bool _isLoading = true;
  String? _error;
  List<EstablecimientoModel> _establecimientos = [];

  @override
  void initState() {
    super.initState();
    _fetchEstablecimientos();
  }

  Future<void> _fetchEstablecimientos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final list = await EstablecimientosService.instance.getAll();
      if (mounted) {
        setState(() {
          _establecimientos = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteEstablecimiento(EstablecimientoModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Desea eliminar "${item.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await EstablecimientosService.instance.delete(item.id!);
      _fetchEstablecimientos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminado con éxito')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Establecimientos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AppRoutes.establecimientoForm);
          _fetchEstablecimientos();
        },
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchEstablecimientos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_establecimientos.isEmpty) {
      return const Center(child: Text('No hay establecimientos registrados.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchEstablecimientos,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _establecimientos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _establecimientos[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: LogoWidget(logoUrl: item.logoUrl),
              title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('NIT: ${item.nit}'),
                  Text(item.direccion),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primary),
                    onPressed: () async {
                      await context.push(AppRoutes.establecimientoForm, extra: item);
                      _fetchEstablecimientos();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.error),
                    onPressed: () => _deleteEstablecimiento(item),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
