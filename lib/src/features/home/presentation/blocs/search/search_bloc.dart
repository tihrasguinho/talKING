import 'package:rxdart/rxdart.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/search_users_usecase/search_users_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_event.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_state.dart';

class SearchBloc {
  final ISearchUsersUsecase _searchUsersUsecase;

  final _controller = BehaviorSubject<SearchEvent>.seeded(FetchSearchEvent(''));

  SearchBloc(this._searchUsersUsecase);

  void emit(SearchEvent event) => _controller.sink.add(event);

  Stream<SearchState> get stream => _controller.stream.switchMap(_mapEventToState);

  Stream<SearchState> _mapEventToState(SearchEvent event) async* {
    if (event is FetchSearchEvent) {
      yield LoadingSearchState();

      final result = await _searchUsersUsecase(event.query);

      if (result.isRight()) {
        yield SuccessSearchState(result.getOrElse(() => []));
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        yield ErrorSearchState(exception.error);
      }
    } else if (event is ClearSearchEvent) {
      yield InitialSearchState();
    }
  }

  void dispose() {
    _controller.close();
  }
}
