import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Sign UP',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'create a new user',
              style: Theme.of(context).textTheme.overline!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                filled: false,
                labelText: 'Name',
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                filled: false,
                labelText: 'Username',
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
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
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: InkWell(
              onTap: () {},
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
                    'Sign Up',
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
    );
  }
}
