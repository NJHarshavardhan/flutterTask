import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/../components/loader.dart';
import '/../models/photos_data.dart';
import '/../page/home/item_detail.dart';
import '/../utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constant.dart';
import '../../utils/api_service.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final apiService = ApiService();
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  List<PhotosData> photosData = [];
  List<Categories> categories = [];
  bool loading = true;

  fetchPhotos() async {
    try {
      final data = await apiService.getPhotos();
      photosData.addAll(data);
      setState(() {
        loading = false;
      });
    } catch (e) {
      Helper().printMessage('Error fetching photos: $e');
    }
  }

  @override
  void initState() {
    fetchPhotos();
    _addCategories();
    super.initState();
  }

  _addCategories() {
    categories = [
      Categories(title: "Laptop", icon: const Icon(Icons.laptop)),
      Categories(title: "Phone", icon: const Icon(Icons.phone_android)),
      Categories(title: "Head\nPhone", icon: const Icon(Icons.headphones)),
      Categories(title: "Furniture", icon: const Icon(Icons.bed)),
      Categories(title: "Foods", icon: const Icon(Icons.fastfood_outlined)),
      Categories(
          title: "Two\nWheeler",
          icon: const Icon(Icons.directions_bike_outlined)),
      Categories(title: "Hotel", icon: const Icon(Icons.local_hotel_outlined)),
      Categories(title: "Toys", icon: const Icon(Icons.toys_rounded)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loader(loading: loading);
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            title: const Text(appTitle),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(65.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                margin: EdgeInsets.only(bottom: 15.h),
                height: 40.h,
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
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  _buildBanner(),
                  Positioned(
                      bottom: 10.h,
                      left: 12.w,
                      right: 12.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: photosData.map((item) {
                          int index = photosData.indexOf(item);
                          return Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ))
                ],
              ),
              _buildCategories(),
              SizedBox(height: 10.h),
              _title("Recommended for you"),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: photosData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  PhotosData data = photosData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemDetail(photosData: data)),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          SizedBox(
                            height: 150.h,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              child: Image.network(data.url),
                            ),
                          ),
                          Text(
                            data.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("Price: Rs ${data.price}")
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
              ),
              SizedBox(height: 40.h),
            ]),
          )),
        ],
      ),
    );
  }

  _buildBanner() {
    return CarouselSlider(
      carouselController: _carouselController,
      items: photosData.map((item) {
        return Container(
          height: 250.h,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.red,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey,
                Colors.white
              ], // Define your start and end colors here
            ),
          ),
          alignment: Alignment.center,
          child: Image.network(
            item.url,
            height: 250.h,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 210,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 1.0,
      ),
    );
  }

  _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          child: _title("Categories"),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(categories.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50.h,
                              child: CircleAvatar(
                                child: categories[index].icon,
                              ),
                            ),
                            SizedBox(
                              height: 50.h,
                              child: Text(
                                categories[index].title,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                })
              ],
            )),
      ],
    );
  }

  _title(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class Categories {
  Categories({
    required this.title,
    required this.icon,
  });

  late final String title;
  late final Widget icon;
}
