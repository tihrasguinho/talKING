import 'package:rxdart/rxdart.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/get_current_user_usecase/get_current_user_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_event.dart';
import 'package:talking/src/features/home/presentation/blocs/current_user/current_user_state.dart';

class CurrentUserBloc {
  final IGetCurrentUserUsecase _getCurrentUserUsecase;

  final _controller = BehaviorSubject<CurrentUserEvent>.seeded(FetchCurrentUserEvent());

  CurrentUserBloc(this._getCurrentUserUsecase);

  void emit(CurrentUserEvent event) => _controller.sink.add(event);

  Stream<CurrentUserState> get stream => _controller.stream.switchMap(_mapEventToState);

  Stream<CurrentUserState> _mapEventToState(CurrentUserEvent event) async* {
    if (event is FetchCurrentUserEvent) {
      yield LoadingCurrentUserState();

      final result = await _getCurrentUserUsecase();

      if (result.isRight()) {
        final user = result.fold((l) => null, (r) => r) as UserEntity;

        yield SuccessCurrentUserState(user);
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        yield ErrorCurrentUserState(exception.error);
      }
    }
  }

  void dispose() {
    _controller.close();
  }
}
