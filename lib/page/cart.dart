import 'package:flipkart_task/models/photos_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../provider/cart_provider.dart';
import '../widget/star_rating.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  int total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = ref.read(cartNotifierProvider);
    _calculation();
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Cart"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (cartProvider.cartData.isEmpty)
                  Column(
                    children: [
                      Image.asset("assets/images/empty-cart.png"),
                      SizedBox(height: 20.h),
                      const Text("The Cart Is Empty")
                    ],
                  )
                else
                  ...List.generate(cartProvider.cartData.length, (index) {
                    PhotosData data = cartProvider.cartData[index];
                    return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 15.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 9,
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      data.url,
                                      width: 100.h,
                                      height: 100.h,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 5.w),
                                      child: Text("Quantity",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.grey)),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (data.quantity > 1) {
                                                data.quantity--;
                                              }
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.remove)),
                                        Text(cartProvider
                                            .cartData[index].quantity
                                            .toString()),
                                        IconButton(
                                            onPressed: () {
                                              if (data.quantity >= 1) {
                                                data.quantity++;
                                              }
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.add)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 6.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        data.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    const StarRating(
                                      numberOfStars: 4,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text("Rs ${data.price}")
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                            ListTile(
                              onTap: () {
                                cartProvider.cartData.removeAt(index);
                                setState(() {});
                              },
                              leading: const Icon(Icons.delete_forever),
                              title: const Text("Remove"),
                              contentPadding: EdgeInsets.zero,
                            )
                          ],
                        ));
                  }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar());
  }

  _buildBottomNavigationBar() {
    final cartProvider = ref.read(cartNotifierProvider);
    if (cartProvider.cartData.isEmpty) {
      return Container(height: 0.h);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
          bottom: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Rs $total",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            height: 40.h,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .45,
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.r)),
            child: Text(
              "Place Order",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }

  _calculation() {
    final cartProvider = ref.read(cartNotifierProvider);
    if (cartProvider.cartData.isNotEmpty) {
      total = cartProvider.cartData
          .map((photoData) => photoData.quantity * photoData.price)
          .reduce((total, current) => total + current);
    }
  }
}
