import 'package:flutter/material.dart';

import 'app_theme.dart';
import '../screens/devices/devices_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/other/other_hub_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  void _setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final normalScreens = [
      HomeScreen(
        onOpenDevicesTab: () => _setIndex(2),
      ),
      const HistoryScreen(),
      const DevicesScreen(),
      const ProfileScreen(),
    ];
    final accessibilityScreens = [
      const HomeScreen(
        onOpenDevicesTab: _noop,
      ),
      const OtherHubScreen(),
    ];
    final selectedIndex = ui.accessibilityMode
        ? (_currentIndex == 0 ? 0 : 1)
        : _currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: ui.accessibilityMode ? accessibilityScreens : normalScreens,
      ),
      bottomNavigationBar: ui.accessibilityMode
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: palette.surface,
                border: Border(
                  top: BorderSide(
                    color: palette.cardBorderStrong,
                    width: 2,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    10,
                    12,
                    10 + MediaQuery.of(context).padding.bottom.clamp(0, 12),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final buttonWidth = (constraints.maxWidth - 12) / 2;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            child: _A11yDestinationButton(
                              key: const ValueKey('a11y-tab-home'),
                              label: 'Home',
                              icon: selectedIndex == 0
                                  ? Icons.home_rounded
                                  : Icons.home_outlined,
                              selected: selectedIndex == 0,
                              onTap: () => _setIndex(0),
                            ),
                          ),
                          SizedBox(
                            width: buttonWidth,
                            child: _A11yDestinationButton(
                              key: const ValueKey('a11y-tab-other'),
                              label: 'Other',
                              icon: selectedIndex == 1
                                  ? Icons.dashboard_customize_rounded
                                  : Icons.dashboard_customize_outlined,
                              selected: selectedIndex == 1,
                              onTap: () => _setIndex(1),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _setIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_rounded),
                  selectedIcon: Icon(Icons.history_toggle_off_rounded),
                  label: 'History',
                ),
                NavigationDestination(
                  icon: Icon(Icons.sensors_outlined),
                  selectedIcon: Icon(Icons.sensors_rounded),
                  label: 'Devices',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }
}

void _noop() {}

class _A11yDestinationButton extends StatelessWidget {
  const _A11yDestinationButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Semantics(
        container: true,
        button: true,
        selected: selected,
        label: 'Open $label tab',
        excludeSemantics: true,
        onTap: onTap,
        child: InkWell(
          borderRadius: BorderRadius.circular(ui.disclosureRadius),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: ui.accessibilityMode ? 12 : 10,
            ),
            decoration: BoxDecoration(
              color: selected ? palette.surfaceMuted : palette.surface,
              borderRadius: BorderRadius.circular(ui.disclosureRadius),
              border: Border.all(
                color: selected
                    ? palette.textPrimary
                    : palette.cardBorderStrong,
                width: selected ? 2.5 : 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: ui.iconSize,
                  color: palette.textPrimary,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
