import 'package:go_router/go_router.dart';
import '../models/establecimiento_model.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/accidentes/accidentes_view.dart';
import '../views/establecimientos/establecimientos_list_view.dart';
import '../views/establecimientos/establecimiento_form_view.dart';

class AppRoutes {
  static const dashboard = '/';
  static const accidentes = '/accidentes';
  static const establecimientos = '/establecimientos';
  static const establecimientoForm = '/establecimiento-form';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      path: AppRoutes.accidentes,
      builder: (context, state) => const AccidentesView(),
    ),
    GoRoute(
      path: AppRoutes.establecimientos,
      builder: (context, state) => const EstablecimientosListView(),
    ),
    GoRoute(
      path: AppRoutes.establecimientoForm,
      builder: (context, state) {
        final model = state.extra as EstablecimientoModel?;
        return EstablecimientoFormView(model: model);
      },
    ),
  ],
);
