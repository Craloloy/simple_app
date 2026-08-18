import 'package:flutter/material.dart';

void main() => runApp(const ShoplyApp());

class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoply',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5A36)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class Product {
  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.sold,
  });

  final String name;
  final String category;
  final String price;
  final String oldPrice;
  final String description;
  final String imageUrl;
  final double rating;
  final String sold;
}

const products = <Product>[
  Product(
    name: 'Wireless Headphones',
    category: 'Audio',
    price: '₱1,899',
    oldPrice: '₱2,499',
    description: 'Comfortable wireless headphones with rich sound, soft ear cushions, and a long-lasting battery for everyday listening.',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85',
    rating: 4.8,
    sold: '1.2k sold',
  ),
  Product(
    name: 'Smart Watch Series 2',
    category: 'Wearables',
    price: '₱3,499',
    oldPrice: '₱4,299',
    description: 'A sleek smartwatch for notifications, fitness tracking, daily activity, and keeping up with your schedule.',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=85',
    rating: 4.7,
    sold: '856 sold',
  ),
  Product(
    name: 'Everyday Laptop',
    category: 'Computers',
    price: '₱29,999',
    oldPrice: '₱32,999',
    description: 'A slim everyday laptop made for schoolwork, browsing, productivity, and creative projects.',
    imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=85',
    rating: 4.9,
    sold: '324 sold',
  ),
  Product(
    name: 'Portable Bluetooth Speaker',
    category: 'Audio',
    price: '₱2,299',
    oldPrice: '₱2,799',
    description: 'Compact Bluetooth speaker with clear audio and a portable design for rooms, desks, and weekend trips.',
    imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=900&q=85',
    rating: 4.6,
    sold: '672 sold',
  ),
  Product(
    name: 'Minimal Desk Lamp',
    category: 'Home',
    price: '₱1,299',
    oldPrice: '₱1,699',
    description: 'A clean and practical desk lamp for reading, studying, and creating a comfortable workspace.',
    imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=900&q=85',
    rating: 4.8,
    sold: '943 sold',
  ),
  Product(
    name: 'Classic Camera',
    category: 'Gadgets',
    price: '₱18,499',
    oldPrice: '₱20,999',
    description: 'A compact camera for everyday photography, travel, and capturing memorable moments.',
    imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=900&q=85',
    rating: 4.7,
    sold: '218 sold',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String searchText = '';
  final categories = const ['All', 'Audio', 'Wearables', 'Computers', 'Home', 'Gadgets'];

  List<Product> get visibleProducts => products.where((product) {
        final categoryMatch = selectedCategory == 'All' || product.category == selectedCategory;
        final searchMatch = searchText.isEmpty || product.name.toLowerCase().contains(searchText.toLowerCase());
        return categoryMatch && searchMatch;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        title: const Text('shoply', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -1)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SearchBar(onChanged: (value) => setState(() => searchText = value))),
            SliverToBoxAdapter(child: _PromoBanner()),
            SliverToBoxAdapter(
              child: _CategoryBar(
                categories: categories,
                selected: selectedCategory,
                onSelected: (category) => setState(() => selectedCategory = category),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Flash deals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    Text('${visibleProducts.length} products', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(product: visibleProducts[index]),
                  childCount: visibleProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.64,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search products',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(12, 2, 12, 18),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=1200&q=85',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF202020)),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.black87, Colors.transparent], begin: Alignment.centerLeft, end: Alignment.centerRight),
            ),
          ),
          const Positioned(
            left: 18,
            top: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UP TO 40% OFF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                SizedBox(height: 8),
                Text('New arrivals\nfor less.', style: TextStyle(color: Colors.white, fontSize: 28, height: 1.0, fontWeight: FontWeight.w900)),
                SizedBox(height: 10),
                Text('Shop now →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.categories, required this.selected, required this.onSelected});
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final active = category == selected;
          return ChoiceChip(
            label: Text(category),
            selected: active,
            onSelected: (_) => onSelected(category),
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFFFFE4DE),
            side: BorderSide(color: active ? const Color(0xFFFF5A36) : Colors.grey.shade200),
            labelStyle: TextStyle(
              color: active ? const Color(0xFFE94827) : Colors.grey.shade700,
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductScreen(productName: product.name)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined, size: 42),
                    ),
                    loadingBuilder: (context, child, progress) => progress == null
                        ? child
                        : Container(color: Colors.grey.shade100, child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFF5A36), borderRadius: BorderRadius.circular(5)),
                      child: const Text('SALE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: const Icon(Icons.favorite_border_rounded, size: 19),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 7),
                  Text(product.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  Text(product.oldPrice, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, decoration: TextDecoration.lineThrough)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFB000)),
                      const SizedBox(width: 2),
                      Text(product.rating.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 5),
                      Text(product.sold, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.productName});
  final String productName;

  Product get product => products.firstWhere((item) => item.name == productName, orElse: () => products.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product details', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.category.toUpperCase(), style: const TextStyle(color: Color(0xFFE94827), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 6),
                Text(product.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFFFB000), size: 20),
                  Text(' ${product.rating}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('  •  ${product.sold}', style: TextStyle(color: Colors.grey.shade600)),
                ]),
                const SizedBox(height: 14),
                Text(product.price, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                Text(product.oldPrice, style: TextStyle(color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
                const SizedBox(height: 22),
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.55)),
                const SizedBox(height: 26),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Add to cart'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54), side: const BorderSide(color: Color(0xFFFF5A36)), foregroundColor: const Color(0xFFE94827)),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF5A36), minimumSize: const Size.fromHeight(54)),
                    child: const Text('Buy now'),
                  )),
                ]),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(productName: product.name))),
                  icon: const Icon(Icons.info_outline_rounded),
                  label: const Text('View full details'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.productName});
  final String productName;

  Product get product => products.firstWhere((item) => item.name == productName, orElse: () => products.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
          const SizedBox(height: 24),
          _InfoTile(icon: Icons.category_outlined, title: 'Category', value: product.category),
          _InfoTile(icon: Icons.star_outline_rounded, title: 'Rating', value: '${product.rating} / 5'),
          _InfoTile(icon: Icons.inventory_2_outlined, title: 'Availability', value: 'In stock'),
          _InfoTile(icon: Icons.local_shipping_outlined, title: 'Delivery', value: '2–5 business days'),
          const SizedBox(height: 20),
          OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded), label: const Text('Back to product')),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFFE94827)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: Text(value, style: TextStyle(color: Colors.grey.shade700)),
    );
  }
}
