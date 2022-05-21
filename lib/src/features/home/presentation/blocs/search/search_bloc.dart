import 'package:bloc/bloc.dart';
import 'package:talking/src/core/others/app_exception.dart';
import 'package:talking/src/features/home/domain/usecases/search_users_usecase/search_users_usecase.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_event.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ISearchUsersUsecase _searchUsersUsecase;

  SearchBloc(this._searchUsersUsecase) : super(InitialSearchState()) {
    on<FetchSearchEvent>((event, emit) async {
      emit(LoadingSearchState());

      final result = await _searchUsersUsecase(event.query);

      if (result.isRight()) {
        emit(SuccessSearchState(result.getOrElse(() => [])));
      } else {
        final exception = result.fold((l) => l, (r) => null) as AppException;

        emit(ErrorSearchState(exception.error));
      }
    });

    on<ClearSearchEvent>((event, emit) => emit(SuccessSearchState([])));
  }
}
