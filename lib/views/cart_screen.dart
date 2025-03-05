import 'dart:math';
import 'package:ecommerce_shop/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../controllers/product_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    double totalAmount = productProvider.cart.entries
        .fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));

    return WillPopScope(
      onWillPop: () async {
        _confettiController
            .stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("My Cart")),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: productProvider.cart.isEmpty
                      ? const Center(child: Text("Your cart is empty"))
                      : ListView.builder(
                          itemCount: productProvider.cart.length,
                          itemBuilder: (ctx, index) {
                            final product =
                                productProvider.cart.keys.elementAt(index);
                            final quantity = productProvider.cart[product] ?? 0;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                leading: Image.network(product.image,
                                    width: 50, height: 50),
                                title: Text(product.title),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${product.price}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB39DDB),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.deepPurple,
                                            Colors.blueAccent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.white),
                                            onPressed: () => productProvider
                                                .removeFromCart(product),
                                          ),
                                          Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle,
                                                color: Colors.white),
                                            onPressed: () => productProvider
                                                .addToCart(product),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (productProvider.cart.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$${totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB39DDB)),
                        ),
                      ],
                    ),
                  ),
                if (productProvider.cart.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: CustomButton(
                      onPressed: _startConfetti,
                      text: "Proceed to Checkout",
                    ),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.2,
                colors: const [
                  Colors.blueAccent,
                  Colors.deepPurple,
                  Colors.pink,
                  Colors.white
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
