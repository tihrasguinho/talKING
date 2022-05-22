import 'package:bloc/bloc.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_friends_usecase/get_friends_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_event.dart';
import 'package:talking/src/features/home/presentation/blocs/friends/friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final IGetFriendsUsecase _getFriendsUsecase;

  FriendsBloc(this._getFriendsUsecase) : super(InitialFriendsState()) {
    on<FetchFriendsEvent>((event, emit) async {
      emit(LoadingFriendsState());

      final result = await _getFriendsUsecase();

      if (result.isRight()) {
        emit(SuccessFriendsState(result.getOrElse(() => [])));
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        emit(ErrorFriendsState(exception.error));
      }
    });
  }
}
