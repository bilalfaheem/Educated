import 'package:edugated/data/guest_json/rest_api_guest_repository.dart';
import 'package:edugated/data/rest_api_activity_repository.dart';
import 'package:edugated/data/rest_api_add_contact_repository.dart';
import 'package:edugated/data/rest_api_contacts_repository.dart';
import 'package:edugated/data/rest_api_generate_gate_pass_repository.dart';
import 'package:edugated/data/rest_api_users_repository.dart';
import 'package:edugated/data/stagging_app_url.dart';
import 'package:edugated/domain/app_url/app_url.dart';
import 'package:edugated/domain/repositories/activity_repository.dart';
import 'package:edugated/domain/repositories/add_contact_repository.dart';
import 'package:edugated/domain/repositories/contacts.repository.dart';
import 'package:edugated/domain/repositories/generate_gate_pass_repository.dart';
import 'package:edugated/domain/repositories/guest_repository.dart';
import 'package:edugated/domain/repositories/users_repository.dart';
import 'package:edugated/domain/use_cases/add_contact_use_case.dart';
import 'package:edugated/domain/use_cases/generate_gate_pass_use_case.dart';
import 'package:edugated/domain/validator/add_contact_validator.dart';
import 'package:edugated/domain/validator/generate_gate_pass_validator.dart';
import 'package:edugated/features/activity/activity_cubit.dart';
import 'package:edugated/features/activity/activity_initial_params.dart';
import 'package:edugated/features/activity/activity_navigator.dart';
import 'package:edugated/features/add_contact/add_contact_cubit.dart';
import 'package:edugated/features/add_contact/add_contact_initial_params.dart';
import 'package:edugated/features/gate_pass/gate_pass_cubit.dart';
import 'package:edugated/features/gate_pass/gate_pass_initial_params.dart';
import 'package:edugated/features/gate_pass/gate_pass_navigator.dart';
import 'package:edugated/features/generate_gate_pass/generate_gate_pass_cubit.dart';
import 'package:edugated/features/generate_gate_pass/generate_gate_pass_initial_params.dart';
import 'package:edugated/features/generate_gate_pass/generate_gate_pass_navigator.dart';
import 'package:edugated/features/guest/guest_cubit.dart';
import 'package:edugated/features/guest/guest_initial_params.dart';
import 'package:edugated/features/guest/guest_navigator.dart';
import 'package:edugated/features/guest_pass/guest_pass_cubit.dart';
import 'package:edugated/features/guest_pass/guest_pass_initial_params.dart';
import 'package:edugated/features/guest_pass/guest_pass_navigator.dart';
import 'package:edugated/features/home/home_cubit.dart';
import 'package:edugated/features/home/home_initial_params.dart';
import 'package:edugated/features/home/home_navigator.dart';
import 'package:edugated/features/home/home_page.dart';
import 'package:edugated/navigation/app_navigator.dart';
import 'package:edugated/navigation/navigation.dart';
import 'package:edugated/network/network.dart';
import 'package:edugated/network/network_repository.dart';
import 'package:edugated/resources/validator.dart';
import 'package:edugated/services/date_picker_service.dart';
import 'package:edugated/services/pick_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  getIt.registerSingleton<Validator>(Validator());
  getIt.registerSingleton<AppUrl>(StaggingAppUrl());
  getIt.registerSingleton<Network>(NetworkRepository());
  getIt.registerSingleton<Navigation>(AppNavigator());

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Services >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  getIt.registerSingleton<PickImageService>(PickImageService());
  getIt.registerSingleton<DatePickerService>(DatePickerService());

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Repository >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  getIt.registerSingleton<UsersRepository>(RestApiUsersRepository(getIt()));
  getIt.registerSingleton<ActivityRepository>(
      RestApiActivityRepository(getIt(), getIt()));
  getIt.registerSingleton<ContactsRepository>(
      RestApiContactsRepository(getIt(), getIt()));
  getIt.registerSingleton<GenerateGatePassRepository>(
      RestApiGenerateGatePassRepository(getIt(), getIt()));
  getIt.registerSingleton<GuestRepository>(
      RestApiGuestRepository(getIt(), getIt()));

  // getIt.registerSingleton<ContactsRepository>(MockContactsRepository());
  getIt.registerSingleton<AddContactRepository>(
      RestApiAddContactRepository(getIt(), getIt()));

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< validation >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  getIt.registerSingleton<AddContactValidator>(AddContactValidator(getIt()));
  getIt.registerSingleton<GenerateGatePassValidator>(
      GenerateGatePassValidator(getIt()));

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Navigation >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  getIt.registerSingleton<ActivityNavigator>(ActivityNavigator(getIt()));
  getIt.registerSingleton<HomeNavigator>(HomeNavigator());
  getIt.registerSingleton<GatePassNavigator>(GatePassNavigator());
  getIt.registerSingleton<GuestNavigator>(GuestNavigator(getIt()));
  getIt.registerSingleton<GenerateGatePassNavigator>(
      GenerateGatePassNavigator(getIt()));
  getIt.registerSingleton<GuestPassNavigator>(GuestPassNavigator());

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Use Case >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  getIt.registerSingleton<AddContactUseCase>(AddContactUseCase(
    getIt(),
    getIt(),
  ));
  getIt.registerSingleton<GenerateGatePassUseCase>(GenerateGatePassUseCase(
    getIt(),
    getIt(),
  ));

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Cubit >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  getIt.registerFactoryParam<ActivityCubit, ActivityInitialParams, dynamic>(
      (params, _) => ActivityCubit(params, getIt(), getIt())..fetchActivity());
  getIt.registerFactoryParam<HomeCubit, HomeInitialParams, dynamic>(
      (params, _) => HomeCubit(params, getIt()));
  getIt.registerFactoryParam<GuestCubit, GuestInitialParams, dynamic>(
      (params, _) => GuestCubit(params, getIt(), getIt())..fetchGuestPass());
  getIt.registerFactoryParam<GatePassCubit, GatePassInitialParams, dynamic>(
      (params, _) => GatePassCubit(params, getIt()));
  getIt.registerFactoryParam<GenerateGatePassCubit,
          GenerateGatePassInitialParams, dynamic>(
      (params, _) =>
          GenerateGatePassCubit(params, getIt(), getIt(), getIt(), getIt())
            ..fetchContacts());
  getIt.registerFactoryParam<AddContactCubit, AddContactInitialParams, dynamic>(
      (param, _) => AddContactCubit(param, getIt(), getIt()));
  getIt.registerFactoryParam<GuestPassCubit, GuestPassInitialParams, dynamic>(
      (param, _) => GuestPassCubit(
            param,
          ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: GoogleFonts.nunito().fontFamily),
              home: HomePage(cubit: getIt(param1: const HomeInitialParams())));
        });
  }
}
