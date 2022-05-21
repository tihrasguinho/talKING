import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:talking/src/core/widgets/app_loader.dart';
import 'package:talking/src/features/auth/presentation/controllers/signin_controller.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final SigninController controller = Modular.get();

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  void setLoading(bool val) {
    setState(() {
      loading = val;
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loading: loading,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'talKING',
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'chat everywhere',
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
              child: TextField(
                controller: password,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  filled: false,
                  labelText: 'Password',
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextButton(
                  onPressed: () => Modular.to.pushNamed('/reset-password'),
                  child: Text(
                    'FORGOT YOUR PASSWORD?',
                    style: Theme.of(context).textTheme.overline!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();

                  setLoading(true);

                  await controller.signIn(email.text, password.text);

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
                      'Sign In',
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextButton(
                  onPressed: () => Modular.to.pushNamed('/signup'),
                  child: Text(
                    "DON'T HAVE AN ACCOUNT? SIGN UP HERE! ",
                    style: Theme.of(context).textTheme.overline!.copyWith(
                          color: Theme.of(context).primaryColor,
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
