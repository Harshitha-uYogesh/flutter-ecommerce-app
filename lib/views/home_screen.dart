import 'package:ecommerce_shop/views/product_card.dart';
import 'package:ecommerce_shop/widgets/custom_icon_button.dart';
import 'package:ecommerce_shop/widgets/scrolling_deals.dart';
import 'package:ecommerce_shop/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/product_provider.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  void _onScroll() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !productProvider.isPaginating) {
      productProvider.fetchProducts(loadMore: true);
    }
  }

 @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
  appBar:  productProvider.isLoading
          ?  AppBar(
            title: Container(
           
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300]!,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              productProvider.searchQuery = query;
            },
            decoration: InputDecoration(
              hintText: "Search product",
              border: InputBorder.none,
              prefixIcon: Container(
              
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.search, color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              int cartItemCount = productProvider.cart.length;
              return Stack(
                children: [
                  CustomIconButton(
                    icon: Icons.shopping_cart,
                    onTap: () {
                            FocusScope.of(context).unfocus();
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  
                    iconColor: Colors.black,
                  ),
                   if (productProvider.cart.isNotEmpty)
                Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartItemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 10),
     CustomIconButton(icon:Icons.notifications ,onTap:() {
              
              } ,iconColor: Colors.black,),
         
          const SizedBox(width: 10),
        ],
      ),

   
      body: productProvider.isLoading
          ? ShimmerLoading():RefreshIndicator(
        onRefresh: () async {
          await productProvider.fetchProducts(
              loadMore: false);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
          
         SliverToBoxAdapter(
              child: SizedBox(
                height: 130,
                child: ScrollingDeals()  ),
            ),


            if (productProvider.isLoading)
              SliverToBoxAdapter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 6, 
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              ),

         
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: productProvider.filteredProducts.isEmpty
                  ? const SliverFillRemaining(
  hasScrollBody: false, 
  child: Center(
    child: Padding(
      padding:  EdgeInsets.all(20),
      child: Text(
        "No items available",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  ),
)

                  : SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                   final product = productProvider.filteredProducts[index];

                    return  ProductCard(product: product);  },
                  childCount: productProvider.filteredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),

          
            if (productProvider.isPaginating)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
