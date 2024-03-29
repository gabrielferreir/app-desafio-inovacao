import 'package:app_desafio_inovacao/core/prefs/preferences.dart';
import 'package:app_desafio_inovacao/main/auth/auth.dart';
import 'package:app_desafio_inovacao/main/home/home.dart';
import 'package:app_desafio_inovacao/main/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth.dart';

class AuthContent extends StatefulWidget {
  final AuthBloc authBloc;
  final Preferences prefs;

  AuthContent({@required this.authBloc, @required this.prefs});

  @override
  _AuthContentState createState() => _AuthContentState();
}

class _AuthContentState extends State<AuthContent> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: widget.authBloc,
        listener: (BuildContext context, AuthState state) {
          if (state.stateAuth == StateAuth.logged) _goHome();
          if (state.stateAuth == StateAuth.initial) _goLogin();
        },
        child: BlocBuilder(
            bloc: widget.authBloc,
            builder: (BuildContext context, AuthState state) {
              return Container();
            }));
  }

  _goHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  _goLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
