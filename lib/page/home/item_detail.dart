import 'package:flipkart_task/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/constant.dart';
import '../../models/photos_data.dart';
import '../../provider/cart_provider.dart';
import '../../widget/star_rating.dart';

class ItemDetail extends ConsumerStatefulWidget {
  final PhotosData photosData;

  const ItemDetail({super.key, required this.photosData});

  @override
  ConsumerState<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends ConsumerState<ItemDetail> {
  bool isSaved = false;
  bool isDataAdded = false;

  @override
  void initState() {
    super.initState();
    final cartProvider = ref.read(cartNotifierProvider);
    isDataAdded = cartProvider.cartData
        .any((element) => element.id == widget.photosData.id);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = ref.read(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.h),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              margin: EdgeInsets.only(bottom: 15.h),
              height: 40.h,
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 25.sp,
                      )),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {},
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        labelText: 'Search',
                        border: const OutlineInputBorder(),
                        suffixIcon: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.mic_none),
                              SizedBox(width: 8.w),
                              const Icon(Icons.camera_alt_outlined),
                              SizedBox(width: 8.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: cartProvider.cartData.isEmpty
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.topCenter,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, AppRoutes.home,
                                    arguments: {"index": 4});
                              },
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                size: 25.sp,
                              ))),
                      cartProvider.cartData.isEmpty
                          ? Container()
                          : Positioned(
                              right: 2.w,
                              child: CircleAvatar(
                                  radius: 8.r,
                                  child: Text(
                                    cartProvider.cartData.length.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )))
                    ],
                  )
                ],
              )),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.photosData.url,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 10.w,
                  top: 12.h,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSaved = !isSaved;
                      });
                    },
                    child: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : Colors.black,
                      size: 25.sp,
                    ),
                  ),
                ),
                Positioned(
                  right: 10.w,
                  top: 40.h,
                  child: GestureDetector(
                    onTap: () {
                      Share.share(
                          '$appTitle - ${widget.photosData.title} to click this link ${"https://jsonplaceholder.typicode.com/photos/${widget.photosData.id}"}');
                    },
                    child: Icon(
                      Icons.share_outlined,
                      size: 25.sp,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.photosData.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    child: RichText(
                      text: TextSpan(
                        text: 'Price: ',
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: <TextSpan>[
                          TextSpan(
                              text: " Rs ${widget.photosData.price} ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    child: const StarRating(
                      numberOfStars: 4,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text("All offers & Coupons",
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15.sp,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: SizedBox(
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                final cartProvider = ref.read(cartNotifierProvider);
                if (!isDataAdded) {
                  cartProvider.cartData.add(widget.photosData);
                }
                Navigator.popAndPushNamed(context, AppRoutes.home,
                    arguments: {"index": 4});
              },
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.50,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: Text(isDataAdded ? "Go to Cart" : "Add to Cart",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                color: Colors.orange,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                child: Text("Buy now",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
