// ignore_for_file: unused_import
import 'package:cpedidos_pmp/main.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/src/auth/external/datasources/auth_datasource_impl.dart';
import 'package:cpedidos_pmp/src/auth/infra/datasources/auth_datasource.dart';
import 'package:cpedidos_pmp/src/auth/infra/models/logged_user_model.dart';
import 'package:cpedidos_pmp/src/auth/infra/repositories/auth_repository_impl.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:cpedidos_pmp/src/auth/presentation/guards/auth_guard.dart';
import 'package:cpedidos_pmp/src/auth/presentation/guards/guest_guard.dart';
import 'package:cpedidos_pmp/src/auth/presentation/pages/login_page.dart';
import 'package:cpedidos_pmp/src/auth/presentation/widgets/logout_button.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/src/orders/external/datasources/order_datasource_impl.dart';
import 'package:cpedidos_pmp/src/orders/external/decorators/order_archive_datasource_decorator.dart';
import 'package:cpedidos_pmp/src/orders/external/decorators/order_datasource_decorator.dart';
import 'package:cpedidos_pmp/src/orders/external/dtos/order_dto.dart';
import 'package:cpedidos_pmp/src/orders/infra/datasources/order_datasource.dart';
import 'package:cpedidos_pmp/src/orders/infra/repositories/order_repository_impl.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_state.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_state.dart';
import 'package:cpedidos_pmp/src/orders/presentation/pages/order_register_page.dart';
import 'package:cpedidos_pmp/src/orders/presentation/pages/orders_search_page.dart';
import 'package:cpedidos_pmp/src/shared/config/firebase/firebase_config.dart';
import 'package:cpedidos_pmp/src/shared/config/firebase/firebase_options.g.dart';
import 'package:cpedidos_pmp/src/shared/config/sentry/sentry_config.dart';
import 'package:cpedidos_pmp/src/shared/config/theme/theme_config.dart';
import 'package:cpedidos_pmp/src/shared/helpers/debounce.dart';
import 'package:cpedidos_pmp/src/shared/helpers/input_formatters.dart';
import 'package:cpedidos_pmp/src/shared/helpers/universal_imports.dart';
import 'package:cpedidos_pmp/src/shared/managers/snackbar_manager.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service_impl.dart';
import 'package:cpedidos_pmp/src/shared/widgets/buttons/outline_button.dart';
import 'package:cpedidos_pmp/src/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:cpedidos_pmp/src/shared/widgets/inputs/password_input.dart';
import 'package:cpedidos_pmp/src/shared/widgets/inputs/select_input.dart';
import 'package:cpedidos_pmp/src/shared/widgets/inputs/text_area_input.dart';
import 'package:cpedidos_pmp/src/shared/widgets/inputs/text_input.dart';
import 'package:cpedidos_pmp/src/shared/widgets/loaders/logo_fullscreen_loader.dart';

void main() {}
