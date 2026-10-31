# Tiny's Bookshop

A Flutter bookstore ordering app for the UI Fundamentals assignment.

## Features
- Four books with authors and sample prices
- Add and remove book quantities
- Automatically calculated order total
- Optional gift wrapping for $3 per order
- Gift message shown when wrapping is selected
- Order confirmation dialog
- Reusable widgets for book cards and price rows

## UI element explored
The app uses Card widgets with rounded corners and elevation to organize the books and order details. A comment identifies this in lib/main.dart.

## Run the app
With Flutter installed, run:

```sh
flutter pub get
flutter run -d web-server
```

Open the local address printed in the terminal.

## Checks
```sh
flutter analyze
flutter test
```

The widget test checks book selection, gift wrapping, the calculated total, and order confirmation.

This is a class demonstration. It does not process payments or place real orders.