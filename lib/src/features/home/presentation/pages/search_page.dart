import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_bloc.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_event.dart';
import 'package:talking/src/features/home/presentation/blocs/search/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc bloc = Modular.get();

  final controller = TextEditingController();

  bool searching = false;

  void setSearching(bool val) {
    setState(() {
      searching = val;
    });
  }

  @override
  void initState() {
    super.initState();

    // Initial fetch to get 10 items
    bloc.add(FetchSearchEvent(''));

    // Listen to changes on textField and calls BloC
    controller.addListener(() {
      setSearching(controller.text.isNotEmpty);

      if (controller.text.length > 3) {
        bloc.add(FetchSearchEvent(controller.text));
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () => searching
              ? {
                  bloc.add(ClearSearchEvent()),
                  controller.clear(),
                }
              : Modular.to.pop(),
          icon: Icon(
            searching ? Icons.clear_rounded : Icons.arrow_back_rounded,
          ),
        ),
        title: TextField(
          controller: controller,
          cursorColor: Colors.white,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Colors.white,
              ),
          decoration: InputDecoration(
            hintText: 'Search by username',
            hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w200,
                ),
            border: InputBorder.none,
            filled: false,
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is LoadingSearchState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorSearchState) {
            return Center(child: Text(state.error));
          } else if (state is SuccessSearchState) {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 24.0),
              separatorBuilder: (_, __) {
                return const SizedBox(height: 24.0);
              },
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(
                    title: Text(
                      user.name,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    subtitle: Text(
                      '@${user.username}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white60,
                          ),
                    ),
                    leading: CustomCircleAvatar(
                      user: user,
                      size: const Size(52, 52),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'Find your friends by username!',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white70,
                    ),
              ),
            );
          }
        },
      ),
    );
  }
}
