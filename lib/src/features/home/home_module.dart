import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/features/home/data/datasources/get_current_user_datasource/get_current_user_datasource.dart';
import 'package:talking/src/features/home/data/datasources/get_current_user_datasource/get_current_user_firebase_datasource_imp.dart';
import 'package:talking/src/features/home/data/datasources/get_friends_datasource/get_friends_datasource.dart';
import 'package:talking/src/features/home/data/datasources/get_friends_datasource/get_friends_firebase_datasource_imp.dart';
import 'package:talking/src/features/home/data/datasources/search_users_datasource/search_users_datasource.dart';
import 'package:talking/src/features/home/data/datasources/search_users_datasource/search_users_firebase_datasource_imp.dart';
import 'package:talking/src/features/home/data/datasources/send_friend_request_datasource/send_friend_request_datasource.dart';
import 'package:talking/src/features/home/data/datasources/send_friend_request_datasource/send_friend_request_firebase_datasource_imp.dart';
import 'package:talking/src/features/home/data/repositories/get_current_user_repository_imp.dart';
import 'package:talking/src/features/home/data/repositories/get_friends_repository_imp.dart';
import 'package:talking/src/features/home/data/repositories/search_users_repository_imp.dart';
import 'package:talking/src/features/home/data/repositories/send_friend_request_repository_imp.dart';
import 'package:talking/src/features/home/domain/repositories/get_current_user_repository.dart';
import 'package:talking/src/features/home/domain/repositories/get_friends_repository.dart';
import 'package:talking/src/features/home/domain/repositories/search_users_repository.dart';
import 'package:talking/src/features/home/domain/repositories/send_friend_request_repository.dart';
import 'package:talking/src/features/home/domain/usecases/get_current_user_usecase/get_current_user_usecase.dart';
import 'package:talking/src/features/home/domain/usecases/get_current_user_usecase/get_current_user_usecase_imp.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase_imp.dart';
import 'package:talking/src/features/home/domain/usecases/search_users_usecase/search_users_usecase.dart';
import 'package:talking/src/features/home/domain/usecases/search_users_usecase/search_users_usecase_imp.dart';
import 'package:talking/src/features/home/domain/usecases/send_friend_request_usecase/send_friend_request_usecase.dart';
import 'package:talking/src/features/home/domain/usecases/send_friend_request_usecase/send_friend_request_usecase_imp.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_bloc.dart';
import 'package:talking/src/features/home/presentation/controllers/profile_controller.dart';
import 'package:talking/src/features/home/presentation/controllers/search_controller.dart';
import 'package:talking/src/features/home/presentation/pages/main_page.dart';
import 'package:talking/src/features/home/presentation/pages/chats_page.dart';
import 'package:talking/src/features/home/presentation/pages/feed_page.dart';
import 'package:talking/src/features/home/presentation/pages/home_page.dart';
import 'package:talking/src/features/home/presentation/pages/profile_page.dart';
import 'package:talking/src/features/home/presentation/pages/search_page.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        // Get Current User

        Bind.lazySingleton<IGetCurrentUserDatasource>((i) => GetCurrentUserFirebaseDatasourceImp()),
        Bind.lazySingleton<IGetCurrentUserRepository>((i) => GetCurrentUserRepositoryImp(i())),
        Bind.lazySingleton<IGetCurrentUserUsecase>((i) => GetCurrentUserUsecaseImp(i())),
        Bind.factory<ProfileController>((i) => ProfileController(i())),

        // Search Users

        Bind.lazySingleton<ISearchUsersDatasource>((i) => SearchUsersFirebaseDatasourceImp()),
        Bind.lazySingleton<ISearchUsersRepository>((i) => SearchUsersRepositoryImp(i())),
        Bind.lazySingleton<ISearchUsersUsecase>((i) => SearchUsersUsecaseImp(i())),
        Bind.factory<SearchBloc>((i) => SearchBloc(i())),

        // Friend Request

        Bind.lazySingleton<ISendFriendRequestDatasource>((i) => SendFriendRequestFirebaseDatasourceImp()),
        Bind.lazySingleton<ISendFriendRequestRepository>((i) => SendFriendRequestRepositoryImp(i())),
        Bind.lazySingleton<ISendFriendRequestUsecase>((i) => SendFriendRequestUsecaseImp(i())),

        // Get Friends

        Bind.lazySingleton<IGetFriendsDatasource>((i) => GetFriendsFirebaseDatasourceImp()),
        Bind.lazySingleton<IGetFriendsRepository>((i) => GetFriendsRepositoryImp(i())),
        Bind.lazySingleton<IGetFriendsUsecase>((i) => GetFriendsUsecaseImp(i())),
        Bind.lazySingleton<FriendsBloc>((i) => FriendsBloc(i()), onDispose: (bloc) => bloc.close()),

        Bind.factory<SearchController>((i) => SearchController(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const MainPage(),
          transition: TransitionType.fadeIn,
          duration: const Duration(milliseconds: 150),
          children: [
            ChildRoute('/home', child: (_, __) => const HomePage()),
            ChildRoute('/chats', child: (_, __) => const ChatsPage()),
            ChildRoute('/feed', child: (_, __) => const FeedPage()),
            ChildRoute('/profile', child: (_, __) => const ProfilePage()),
          ],
        ),
        ChildRoute(
          '/search',
          child: (_, __) => const SearchPage(),
          duration: const Duration(milliseconds: 150),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}
