import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_widget_test.dart';
import 'matchers.dart';
import 'mocks.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    final mockContactDao = MockContactDao();

    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
    ));
    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, "Transfer", Icons.monetization_on));

    expect(transferFeatureItem, findsOneWidget);
    await tester.tap(transferFeatureItem);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll());


    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) {
      return _textFieldMatcher(widget, 'Full name');
    });
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Alex');

    final accountNumberTextField = find.byWidgetPredicate((widget) {
      return _textFieldMatcher(widget, 'Account number');
    });
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(RaisedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    verify(mockContactDao.save(Contact(0, 'Alex', 1000)));

    final contactsListback = find.byType(ContactsList);
    expect(contactsListback, findsOneWidget);

    verify(mockContactDao.findAll());
  });
}

bool _textFieldMatcher(Widget widget, String labelText) {
  if (widget is TextField) {
    return widget.decoration.labelText == labelText;
  }
  return false;
}
