import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/widgets/app_loader.dart';
import 'package:talking/src/features/auth/presentation/controllers/reset_password_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordController controller = Modular.get();

  final email = TextEditingController();

  bool loading = false;

  void setLoading(bool val) {
    setState(() {
      loading = val;
    });
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loading: loading,
      child: Scaffold(
        appBar: AppBar(),
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Reset Password',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'a link will be sent to your email',
                style: Theme.of(context).textTheme.overline!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: email,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  filled: false,
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: InkWell(
                onTap: () async {
                  setLoading(true);

                  await controller.resetPassword(email.text);

                  setLoading(false);
                },
                borderRadius: BorderRadius.circular(8.0),
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                child: Ink(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Reset',
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
