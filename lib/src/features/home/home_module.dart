import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/data/datasources/app_datasources.dart';
import 'package:talking/src/core/domain/repositories/app_repositories.dart';
import 'package:talking/src/core/domain/usecases/app_usecases.dart';
import 'package:talking/src/features/home/presentation/pages/image_view_page.dart';

import 'presentation/blocs/chats/chats_bloc.dart';
import 'presentation/blocs/current_user/current_user_bloc.dart';
import 'presentation/blocs/friends/friends_bloc.dart';
import 'presentation/blocs/messages/messages_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'presentation/controllers/conversation_controller.dart';
import 'presentation/controllers/main_controller.dart';
import 'presentation/controllers/profile_controller.dart';
import 'presentation/controllers/search_controller.dart';
import 'presentation/pages/chats_page.dart';
import 'presentation/pages/conversation_page.dart';
import 'presentation/pages/feed_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/search_page.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        // Get Current User

        Bind.lazySingleton<IGetCurrentUserDatasource>((i) => GetCurrentUserFirebaseDatasourceImp()),
        Bind.lazySingleton<IGetCurrentUserRepository>((i) => GetCurrentUserRepositoryImp(i())),
        Bind.lazySingleton<IGetCurrentUserUsecase>((i) => GetCurrentUserUsecaseImp(i())),
        Bind.singleton<CurrentUserBloc>((i) => CurrentUserBloc(i()), onDispose: (bloc) => bloc.dispose()),
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
        Bind.lazySingleton<FriendsBloc>((i) => FriendsBloc(i()), onDispose: (bloc) => bloc.dispose()),

        // Send Message

        Bind.lazySingleton<ISendMessageDatasource>((i) => SendMessageFirebaseDatasourceImp()),
        Bind.lazySingleton<ISendMessageRepository>((i) => SendMessageRepositoryImp(i())),
        Bind.lazySingleton<ISendMessageUsecase>((i) => SendMessageUsecaseImp(i())),

        // Get Messages

        Bind.lazySingleton<IGetMessagesDatasource>((i) => GetMessagesFirebaseDatasourceImp()),
        Bind.lazySingleton<IGetMessagesRepository>((i) => GetMessagesRepositoryImp(i())),
        Bind.lazySingleton<IGetMessagesUsecase>((i) => GetMessagesUsecaseImp(i())),

        // Update Online Status

        Bind.lazySingleton<IUpdateOnlineStatusDatasource>((i) => UpdateOnlineStatusFirebaseDatasourceImp()),
        Bind.lazySingleton<IUpdateOnlineStatusRepository>((i) => UpdateOnlineStatusRepositoryImp(i())),
        Bind.lazySingleton<IUpdateOnlineStatusUsecase>((i) => UpdateOnlineStatusUsecaseImp(i())),

        // Mark As Seen

        Bind.lazySingleton<IMarkAsSeenDatasource>((i) => MarkAsSeenFirebaseDatasourceImp()),
        Bind.lazySingleton<IMarkAsSeenRepository>((i) => MarkAsSeenRepositoryImp(i())),
        Bind.lazySingleton<IMarkAsSeenUsecase>((i) => MarkAsSeenUsecaseImp(i())),

        // Delete Message

        Bind.lazySingleton<IDeleteMessageDatasource>((i) => DeleteMessageFirebaseDatasourceImp()),
        Bind.lazySingleton<IDeleteMessageRepository>((i) => DeleteMessageRepositoryImp(i())),
        Bind.lazySingleton<IDeleteMessageUsecase>((i) => DeleteMessageUsecaseImp(i())),

        // Update Typing To

        Bind.lazySingleton<IUpdateTypingToDatasource>((i) => UpdateTypingToFirebaseDatasourceImp()),
        Bind.lazySingleton<IUpdateTypingToRepository>((i) => UpdateTypingToRepositoryImp(i())),
        Bind.lazySingleton<IUpdateTypingToUsecase>((i) => UpdateTypingToUsecaseImp(i())),

        // Conversation

        Bind.factory<MessagesBloc>((i) => MessagesBloc()),

        Bind.factory<ConversationController>((i) => ConversationController(i(), i(), i(), i())),

        Bind.factory<SearchController>((i) => SearchController(i())),

        // Chats

        Bind.lazySingleton<ChatsBloc>((i) => ChatsBloc(), onDispose: (bloc) => bloc.dispose()),

        Bind.factory<MainController>((i) => MainController(i(), i())),
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
        ChildRoute(
          '/conversation/:friendUid',
          child: (_, args) => ConversationPage(friendUid: args.data),
          duration: const Duration(milliseconds: 150),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/image-view',
          child: (_, args) => ImageViewPage(
            image: args.data['image'],
            isLocal: args.data['isLocal'] ?? false,
          ),
          transition: TransitionType.fadeIn,
        ),
      ];
}
