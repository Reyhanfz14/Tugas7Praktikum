import 'package:flutter/material.dart';
import 'package:p7/cart_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoPaedi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final List<Product> products = [
    Product('Laptop'),
    Product('PS 5'),
    Product('Kursi Pijat'),
    Product('AC'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokopaedi'),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return IconButton(
                tooltip: 'Lihat keranjang',
                icon: Badge(
                  isLabelVisible: cart.totalItems > 0,
                  label: Text('${cart.totalItems}'),
                  child: const Icon(Icons.shopping_cart, size: 28),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Daftar Produk',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.shopping_bag, color: Colors.blue),
                    ),
                    title: Text(
                      product.nama,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Tersedia'),
                    trailing: IconButton(
                      tooltip: 'Tambah ke keranjang',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                      ),
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Provider.of<CartModel>(
                          context,
                          listen: false,
                        ).add(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.nama} masuk ke keranjang',
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 90,
                    color: Colors.blue.shade200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjang masih kosong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Yuk, tambahkan produk favoritmu!',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          product.nama,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: 'Hapus',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                          ),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cart.removeAt(index);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.nama} dihapus dari keranjang',
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: SafeArea(
                  top: false,
                  child: Text(
                    'Total: ${cart.totalItems} produk',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
