import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tiny's Bookshop",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF795548),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F2E9),
      ),
      home: const BookshopPage(),
    );
  }
}

class Book {
  final String title;
  final String author;
  final int price;
  final Color color;

  const Book(this.title, this.author, this.price, this.color);
}

const books = [
  Book(
    'Moth to a Flame',
    'Ashley Antoinette',
    1599,
    Color(0xFF804551),
  ),
  Book(
    'Forged by Fire',
    'Sharon M. Draper',
    1099,
    Color(0xFFAC6036),
  ),
  Book(
    'The Autobiography of Gucci Mane',
    'Gucci Mane with Neil Martinez-Belkin',
    1899,
    Color(0xFF416655),
  ),
  Book(
    "I'm Glad My Mom Died",
    'Jennette McCurdy',
    1799,
    Color(0xFF6C577C),
  ),
];

class BookshopPage extends StatefulWidget {
  const BookshopPage({super.key});

  @override
  State<BookshopPage> createState() => _BookshopPageState();
}

class _BookshopPageState extends State<BookshopPage> {
  final List<int> quantities = List.filled(books.length, 0);
  bool giftWrap = false;

  int get itemCount => quantities.fold(0, (sum, qty) => sum + qty);

  int get subtotal {
    int amount = 0;
    for (int i = 0; i < books.length; i++) {
      amount += books[i].price * quantities[i];
    }
    return amount;
  }

  // Charge gift wrapping once per order, only when books are selected.
  int get wrappingCost => giftWrap && itemCount > 0 ? 300 : 0;

  int get total => subtotal + wrappingCost;

  void changeQuantity(int index, int change) {
    setState(() {
      quantities[index] += change;
    });
  }

  void submitOrder() {
    final orderLines = <String>[];

    for (int i = 0; i < books.length; i++) {
      if (quantities[i] > 0) {
        orderLines.add(
          '${quantities[i]} x ${books[i].title}'
          ' — ${money(books[i].price * quantities[i])}',
        );
      }
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Order confirmed!'),
        content: SingleChildScrollView(
          child: Text(
            'Thank you for shopping at Tiny’s Bookshop!\n\n'
            '${orderLines.join('\n\n')}\n\n'
            '${giftWrap ? 'Gift wrapping: ${money(wrappingCost)}\n' : ''}'
            'Total: ${money(total)}\n\n'
            'Your books will be ready for pickup soon.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiny's Bookshop"),
        backgroundColor: const Color(0xFFF8F2E9),
        actions: [
          const Icon(Icons.shopping_bag_outlined),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 20),
            child: Center(child: Text('$itemCount')),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const ShopHeader(),
                const SizedBox(height: 24),
                const Text(
                  'Find your next good read',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Choose your books and make yourself at home.'),
                const SizedBox(height: 18),
                for (int i = 0; i < books.length; i++)
                  BookCard(
                    book: books[i],
                    quantity: quantities[i],
                    onAdd: () => changeQuantity(i, 1),
                    onRemove: quantities[i] > 0
                        ? () => changeQuantity(i, -1)
                        : null,
                  ),
                const SizedBox(height: 12),
                ShopPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Make it a gift'),
                        subtitle: const Text('Gift wrapping: \$3 per order'),
                        value: giftWrap,
                        onChanged: (value) {
                          setState(() {
                            giftWrap = value;
                          });
                        },
                      ),
                      // Conditional UI appears when gift wrapping is on.
                      if (giftWrap)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.card_giftcard),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your order will be wrapped with a gold bow.',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ShopPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Your order',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PriceRow(
                        label: 'Books ($itemCount)',
                        amount: subtotal,
                      ),
                      if (wrappingCost > 0)
                        PriceRow(
                          label: 'Gift wrapping',
                          amount: wrappingCost,
                        ),
                      const Divider(height: 26),
                      PriceRow(
                        label: 'Total',
                        amount: total,
                        bold: true,
                      ),
                      const SizedBox(height: 16),
                      if (itemCount == 0)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text('Add a book to begin your order.'),
                        ),
                      FilledButton.icon(
                        onPressed: itemCount > 0 ? submitOrder : null,
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text('Confirm order'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Good books. A little peace. Something just for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF715C50),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xFF49352D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.auto_stories,
            size: 64,
            color: Color(0xFFE5BE79),
            semanticLabel: 'Open book logo',
          ),
          SizedBox(height: 12),
          Text(
            "Tiny's Bookshop",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'A little shop for big stories',
            style: TextStyle(color: Color(0xFFF0DDC1)),
          ),
        ],
      ),
    );
  }
}

class ShopPanel extends StatelessWidget {
  final Widget child;

  const ShopPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // New UI element explored: Card with rounded corners and elevation.
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  const BookCard({
    super.key,
    required this.book,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ShopPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 86,
            decoration: BoxDecoration(
              color: book.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu_book,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: const TextStyle(color: Color(0xFF75675E)),
                ),
                const SizedBox(height: 8),
                Text(
                  money(book.price),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Remove ${book.title}',
                      onPressed: onRemove,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Add ${book.title}',
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final int amount;
  final bool bold;

  const PriceRow({
    super.key,
    required this.label,
    required this.amount,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 21 : 16,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(money(amount), style: style),
        ],
      ),
    );
  }
}