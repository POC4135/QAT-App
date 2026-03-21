import 'package:flutter_test/flutter_test.dart';

import 'package:qat/core/app_theme.dart';

void main() {
  test('accessibility tokens use larger controls and stronger borders', () {
    const normalUi = QatUiConfig.normal;
    const accessibilityUi = QatUiConfig.accessibility;
    const normalPalette = QatPalette.normal;
    const accessibilityPalette = QatPalette.accessibility;

    expect(accessibilityUi.accessibilityMode, isTrue);
    expect(accessibilityUi.reducedMotion, isTrue);
    expect(accessibilityUi.buttonHeight, greaterThan(normalUi.buttonHeight));
    expect(
      accessibilityUi.heroButtonSize,
      greaterThan(normalUi.heroButtonSize),
    );
    expect(
      accessibilityPalette.cardBorderStrong.computeLuminance(),
      lessThan(normalPalette.cardBorderStrong.computeLuminance()),
    );
  });

  test('theme uses the bundled Atkinson Hyperlegible font family', () {
    final theme = buildQatTheme(
      accessibilityMode: false,
      reducedMotion: false,
    );

    expect(theme.textTheme.bodyLarge?.fontFamily, 'AtkinsonHyperlegible');
    expect(theme.textTheme.titleLarge?.fontFamily, 'AtkinsonHyperlegible');
  });
}
