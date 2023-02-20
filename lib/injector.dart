import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kiwi/kiwi.dart';

import 'src/auth/data/repositories/remote/firebase_auth_remote_repo.dart';
import 'src/auth/data/repositories/remote/firebase_user_remote_repo.dart';
import 'src/auth/domain/repositories/auth_repo.dart';
import 'src/auth/domain/repositories/user_repo.dart';
import 'src/auth/domain/usecases/do_login.dart';
import 'src/auth/domain/usecases/do_logout.dart';
import 'src/auth/domain/usecases/get_current_user.dart';
import 'src/auth/presentation/cubits/auth_cubit.dart';
import 'src/orders/data/repositories/remote/firebase_order_remote_repo.dart';
import 'src/orders/data/services/pdf_service.dart';
import 'src/orders/data/services/print_service.dart';
import 'src/orders/domain/repositories/order_repo.dart';
import 'src/orders/domain/services/pdf_service.dart';
import 'src/orders/domain/services/print_service.dart';
import 'src/orders/domain/usecases/delete_order.dart';
import 'src/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'src/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'src/orders/domain/usecases/print_orders_report.dart';
import 'src/orders/domain/usecases/save_order.dart';
import 'src/orders/presentation/cubits/order_register_cubit.dart';

bool _injected = false;

final _container = KiwiContainer();
KiwiContainer get inject => _container;

void setupInjector() {
  if (_injected) return;
  _injectFirebase();
  _injectThirdParty();
  _injectRepositories();
  _injectServices();
  _injectUsecases();
  _injectControllers();
  _injectStores();
  _injected = true;
}

void setupTestInjector([void Function(KiwiContainer)? setupMocks]) {
  _container.clear();
  _injected = false;
  setupInjector();
  setupMocks?.call(_container);
}

void _injectFirebase() {
  _container.registerFactory<FirebaseAuth>(
    (i) => FirebaseAuth.instance,
  );
  _container.registerFactory<FirebaseDatabase>(
    (i) => FirebaseDatabase.instance,
  );
}

void _injectThirdParty() {}

void _injectRepositories() {
  _container.registerFactory<IAuthRepo>(
    (i) => FirebaseAuthRemoteRepo(i()),
  );
  _container.registerFactory<IUserRepo>(
    (i) => FirebaseUserRemoteRepo(i()),
  );
  _container.registerFactory<IOrderRepo>(
    (i) => FirebaseOrderRemoteRepo(i()),
  );
}

void _injectServices() {
  _container.registerFactory<IPdfService>(
    (i) => PdfService(),
  );
  _container.registerFactory<IPrintService>(
    (i) => PrintService(),
  );
}

void _injectUsecases() {
  _container.registerFactory<IDoLogin>(
    (i) => DoLogin(i(), i()),
  );
  _container.registerFactory<IDoLogout>(
    (i) => DoLogout(i()),
  );
  _container.registerFactory<IGetCurrentUser>(
    (i) => GetCurrentUser(i(), i()),
  );
  _container.registerFactory<IDeleteOrder>(
    (i) => DeleteOrder(i()),
  );
  _container.registerFactory<IGetAllOrdersBySendDate>(
    (i) => GetAllOrdersBySendDate(i()),
  );
  _container.registerFactory<IGetOrderByTypeAndNumber>(
    (i) => GetOrderByTypeAndNumber(i()),
  );
  _container.registerFactory<ISaveOrder>(
    (i) => SaveOrder(i()),
  );
  _container.registerFactory<IPrintOrdersReport>(
    (i) => PrintOrdersReport(i(), i()),
  );
}

void _injectControllers() {
  _container.registerSingleton<AuthCubit>(
    (i) => AuthCubit(i(), i(), i()),
  );
  _container.registerFactory<OrderRegisterCubit>(
    (i) => OrderRegisterCubit(i(), i(), i()),
  );
}

void _injectStores() {}
