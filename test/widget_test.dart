import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trash_paparazzi/main.dart';

Future<void> openApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(448, 998);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

Future<void> tapLabel(WidgetTester tester, String label) async {
  final target = find.text(label);
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void expectSelected(WidgetTester tester, String style) {
  final semantics = tester.widget<Semantics>(
    find.byKey(ValueKey('style-$style')),
  );
  expect(semantics.properties.selected, isTrue);
}

void main() {
  setUpAll(() async {
    for (final family in ['Syne', 'Outfit', 'SpaceMono']) {
      final file = family == 'SpaceMono' ? 'SpaceMono-Regular' : family;
      final loader = FontLoader(family)
        ..addFont(rootBundle.load('assets/fonts/$file.ttf'));
      await loader.load();
    }
  });
  // Android can report a zero viewport before its first surface is ready.
  testWidgets('startup handles an initially empty viewport', (tester) async {
    tester.view.physicalSize = Size.zero;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(448, 998);
    await tester.pumpAndSettle();
    expect(find.text('You Got Spotted!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // Catches a wrong route and loss of selection when returning.
  testWidgets('moment navigation preserves the chosen style after rewards', (
    tester,
  ) async {
    await openApp(tester);
    expect(find.text('You Got Spotted!'), findsOneWidget);
    await tapLabel(tester, 'Watch My Moment');
    expect(find.text('Your Moment'), findsOneWidget);
    expectSelected(tester, 'Hype');
    await tapLabel(tester, 'Funny');
    expectSelected(tester, 'Funny');
    await tapLabel(tester, 'Claim Reward');
    expect(find.text('Festival Perks'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Back'));
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expectSelected(tester, 'Funny');
    await tester.ensureVisible(find.byTooltip('Back'));
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('You Got Spotted!'), findsOneWidget);
  });

  // Catches submitting immediately or treating cancellation as consent.
  testWidgets('public display preview requires explicit confirmation', (
    tester,
  ) async {
    await openApp(tester);
    await tapLabel(tester, 'Watch My Moment');
    await tapLabel(tester, 'Submit to Festival Screen');
    expect(find.text('Show your moment publicly?'), findsOneWidget);
    await tapLabel(tester, 'Keep Private');
    expect(find.text('Submission preview confirmed'), findsNothing);
    await tapLabel(tester, 'Submit to Festival Screen');
    await tapLabel(tester, 'Confirm Preview');
    expect(find.text('Submission preview confirmed'), findsOneWidget);
    expect(
      find.text('Demo only. No video was uploaded or sent.'),
      findsOneWidget,
    );
  });

  // Catches a dead save button and false persistence promises.
  testWidgets('direct reward route offers honest Phase 1 save feedback', (
    tester,
  ) async {
    await openApp(tester);
    await tapLabel(tester, 'Claim Reward');
    expect(find.text('TP-DEMO-8849-X'), findsOneWidget);
    expect(find.text('QR preview • not scannable'), findsOneWidget);
    await tapLabel(tester, 'Save Reward');
    expect(find.text('Reward saving comes next'), findsOneWidget);
    await tapLabel(tester, 'Got It');
    await tester.ensureVisible(find.byTooltip('Back'));
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('You Got Spotted!'), findsOneWidget);
  });

  // Catches controls that pretend a missing video is playing.
  testWidgets('missing video control explains the preview', (tester) async {
    await openApp(tester);
    await tapLabel(tester, 'Watch My Moment');
    await tester.tap(find.byTooltip('Video playback preview'));
    await tester.pumpAndSettle();
    expect(find.text('Video playback comes in Phase 2'), findsOneWidget);
  });

  // Catches Back or outside dismissal being mistaken for consent.
  testWidgets('dismissing public consent leaves the moment private', (
    tester,
  ) async {
    await openApp(tester);
    await tapLabel(tester, 'Watch My Moment');
    await tapLabel(tester, 'Submit to Festival Screen');
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('Show your moment publicly?'), findsNothing);
    expect(find.text('Submission preview confirmed'), findsNothing);
    await tapLabel(tester, 'Submit to Festival Screen');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Submission preview confirmed'), findsNothing);
    await tapLabel(tester, 'Submit to Festival Screen');
    await tapLabel(tester, 'Confirm Preview');
    await tapLabel(tester, 'Cinematic');
    expect(find.text('Submission preview confirmed'), findsNothing);
  });

  // Catches copying a real voucher or omitting the clipboard operation.
  testWidgets('copy sends only the demo identifier to the clipboard', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await openApp(tester);
    await tapLabel(tester, 'Claim Reward');
    final copy = find.byTooltip('Copy demo reward code');
    await tester.ensureVisible(copy);
    await tester.tap(copy);
    await tester.pumpAndSettle();
    expect(copied, 'TP-DEMO-8849-X');
    expect(
      find.text('Demo reward code copied. This is not a redeemable voucher.'),
      findsOneWidget,
    );
  });

  // Catches overflowing fixed layouts and unreachable controls.
  for (final size in [
    const Size(235, 640),
    const Size(320, 640),
    const Size(998, 448),
    const Size(448, 998),
  ]) {
    testWidgets('all screens fit at $size with large text', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tapLabel(tester, 'Watch My Moment');
      expect(tester.takeException(), isNull);
      await tapLabel(tester, 'Claim Reward');
      expect(tester.takeException(), isNull);
      await tapLabel(tester, 'Save Reward');
      expect(find.text('Reward saving comes next'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
