import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    final appState = AppStateScope.of(context);
    final username = _usernameController.text.trim();
    appState.signIn(username.isEmpty ? 'Resident' : username);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final accessibilityMode = ui.accessibilityMode;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ui.screenHorizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(ui.cardPadding - 4),
                    decoration: BoxDecoration(
                      color: palette.surfaceMuted,
                      borderRadius: BorderRadius.circular(ui.cardRadius),
                    ),
                    child: Icon(
                      Icons.health_and_safety_rounded,
                      color: palette.ok,
                      size: ui.iconSize + 4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    accessibilityMode
                        ? 'Sign in to get help fast'
                        : 'QuickAid resident access',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    accessibilityMode
                        ? 'Use your username and password to open a simpler, larger version of the app.'
                        : 'Sign in to check system readiness, start an alert quickly, and review recent incidents without digging through long screens.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(ui.cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accessibilityMode ? 'Sign in' : 'Resident sign in',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            accessibilityMode
                                ? 'This demo accepts any username and password.'
                                : 'Placeholder sign-in only for this build. Use any username and password.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _usernameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter username',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            onSubmitted: (_) => _signIn(),
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter password',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: Semantics(
                              button: true,
                              label: 'Sign in to QuickAid',
                              child: FilledButton.icon(
                                onPressed: _signIn,
                                icon: const Icon(Icons.login_rounded),
                                label: const Text('Sign In'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.help),
                              child: const Text('Need help?'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
