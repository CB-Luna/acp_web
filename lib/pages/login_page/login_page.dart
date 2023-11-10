import 'package:flutter/material.dart';

import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/login_page/widgets/animated_login_widget.dart';
import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/pages/login_page/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    this.token,
  }) : super(key: key);

  final Token? token;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgacp.png'),
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > mobileSize) {
              return const LoginPageDesktop();
            } else {
              return const LoginPageMobile();
            }
          }),
        ),
      ),
    );
  }
}

class LoginPageDesktop extends StatelessWidget {
  const LoginPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        AnimatedLoginWidget(),
        Positioned(
          top: 113.33,
          right: 80,
          child: LoginForm(),
        ),
      ],
    );
  }
}

class LoginPageMobile extends StatelessWidget {
  const LoginPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: LoginForm());
  }
}
