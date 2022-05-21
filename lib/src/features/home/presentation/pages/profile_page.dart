import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';
import 'package:talking/src/core/widgets/custom_circle_avatar.dart';
import 'package:talking/src/features/home/presentation/controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF242424),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Modular.to.pushNamed('/search'),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24.0),
          FutureBuilder<UserEntity?>(
            future: controller.getCurrentUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242424),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        user: snapshot.data!,
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            snapshot.data?.email ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            snapshot.data?.username ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   icon: Icon(Icons.person_add_rounded),
      //   label: Text('Add Friend'),
      // ),
    );
  }
}
