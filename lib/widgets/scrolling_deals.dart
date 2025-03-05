import 'dart:async';
import 'package:ecommerce_shop/controllers/product_provider.dart';
import 'package:ecommerce_shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScrollingDeals extends StatefulWidget {
  @override
  _ScrollingDealsState createState() => _ScrollingDealsState();
}

class _ScrollingDealsState extends State<ScrollingDeals> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  late Timer _timer;

  final Map<String, String> personalizedDeals = {
    "Shoes": "👟 Special Sneaker Offer - Flat 30% OFF!",
    "Phone": "📱 Get 20% off on the latest smartphones!",
    "T-shirt": "👕 Fashion Sale - Up to 50% OFF!",
    "Headphones": "🎧 Music Lovers - Flat 25% OFF on Headphones!",
    "Watch": "⌚ Premium Watches - Buy 1 Get 1 Free!",
    "Bag": "🎒 Travel in Style - 40% OFF on Bags!",
    "Laptop": "💻 Big Tech Sale - Flat ₹5000 OFF on Laptops!",
  };

  final List<String> defaultDeals = [
    "🔥 Flash Sale - Don't Miss Out!",
    "🎁 Special Discounts on Accessories!",
    "🛒 Shop More, Save More!",
    "🚀 Limited-Time Offers Just for You!",
    "🏡 Home Essentials at Best Prices!"
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0); 
        } else {
          _scrollController.animateTo(
            currentScroll + MediaQuery.of(context).size.width * 0.8 + 10,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        }

    
        setState(() {
          _currentIndex = (_currentIndex + 1) % 5;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  List<String> getPersonalizedDeals(Map<Product, int> cart) {
    Set<String> userDeals = {}; 

    if (cart.isEmpty) {
      return defaultDeals;
    }

    for (var product in cart.keys) {
      for (var keyword in personalizedDeals.keys) {
        if (product.title.toLowerCase().contains(keyword.toLowerCase())) {
          userDeals.add(personalizedDeals[keyword]!);
        }
      }
    }

   
    while (userDeals.length < 5) {
      userDeals.add(defaultDeals[userDeals.length % defaultDeals.length]);
    }

    return userDeals.take(5).toList(); 
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<String> deals = getPersonalizedDeals(productProvider.cart);

    return Column(
      children: [
    
        SizedBox(
          height: 105,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            itemCount: deals.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        deals[index], 
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     
                     
                    ],
                  ),
                ),
              );
            },
          ),
        ),

      
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: deals.length, 
          effect: const WormEffect(
            dotColor: Color(0xFFB39DDB),
            activeDotColor: Colors.deepPurple,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
        SizedBox(height: 5,)
      ],
    );
  }
}
