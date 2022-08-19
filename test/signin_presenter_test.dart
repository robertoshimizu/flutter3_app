// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter3_app/app/pages/login/login_presenter.dart';
import 'package:flutter3_app/app/pages/login/login_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter? loginPresenter;
  Future<void> loadPage(WidgetTester tester) async {
    loginPresenter = LoginPresenterSpy();
    final signinPage = MaterialApp(home: SignInScreen());
    await tester.pumpWidget(signinPage);
  }

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

    verify(loginPresenter!.auth()).called(1);
  });
}