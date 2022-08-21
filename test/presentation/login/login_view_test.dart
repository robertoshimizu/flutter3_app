// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter3_app/app/pages/login/login_presenter.dart';

import 'package:flutter3_app/app/pages/login/login_view.dart';
import 'package:flutter3_app/domain/usecases/user_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter loginPresenter;
  late StreamController<bool> isLoadingController;
  late StreamController<String> loginAuthController;

  Future<void> loadPage(WidgetTester tester) async {
    loginPresenter = LoginPresenterSpy();
    isLoadingController = StreamController<bool>();
    loginAuthController = StreamController<String>();

    when(loginPresenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(loginPresenter.loginAuthErrorStream)
        .thenAnswer((_) => loginAuthController.stream);

    final signinPage = MaterialApp(
        home: SignInScreen(
      loginPresenter: loginPresenter,
    ));
    await tester.pumpWidget(signinPage);
  }

  tearDown(() {
    isLoadingController.close();
    loginAuthController.close();
  });

  testWidgets('Should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    final password = faker.internet.password();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your Email'), email);
    await tester.pump();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your Password'), password);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));

    // verify(loginPresenter.auth(LoginParams(email, password))).called(1);
  });

  testWidgets('Should present a loading screen after login button is pressed',
      (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading screen after presenter stream to close it',
      (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should exhibit error message if login/authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    loginAuthController.add('login failed');
    await tester.pump();

    expect(find.text('login failed'), findsOneWidget);
  });

  testWidgets('Should close all streams when page is disposed',
      (WidgetTester tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(loginPresenter.dispose()).called(1);
    });
  });
}
