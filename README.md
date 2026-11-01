# Tiny's Bookshop

A Flutter bookstore ordering app for the UI Fundamentals assignment.

## Features
- Four books with authors and sample prices
- Add and remove book quantities
- Automatically calculated order total
- Optional gift wrapping for $3 per order
- Gift message shown when wrapping is selected
- Order confirmation dialog
- Expandable pickup information
- Reusable widgets for book cards and price rows

## UI element explored
The app uses an ExpansionTile to let customers expand and collapse pickup information. A comment identifies it in lib/main.dart.

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