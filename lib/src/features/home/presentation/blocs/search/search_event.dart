abstract class SearchEvent {}

class InitialSearchEvent extends SearchEvent {}

class FetchSearchEvent extends SearchEvent {
  final String query;

  FetchSearchEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {}
