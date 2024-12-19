import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:firesafety/Widgets/custom_shimmer.dart';
import 'package:firesafety/Controllers/dashboard_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/select_subcategory_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    controller.initialFunctioun().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Dashboard"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Carousel Section
          _buildCarousel(),
          const SizedBox(height: 16),
          // Categories Section
          _buildCategoryGrid(),
        ],
      ),
      drawer: _appDrawer(),
    );
  }

  Widget _buildCarousel() {
    return (controller.getadvertiesmentModel.advertisementList != null)
        ? CarouselSlider.builder(
            itemCount:
                controller.getadvertiesmentModel.advertisementList?.length,
            itemBuilder: (context, index, realIndex) {
              final element =
                  controller.getadvertiesmentModel.advertisementList?[index];
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage("${element?.imagePath}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${element?.description}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              height: 180,
              viewportFraction: 0.9,
              enlargeCenterPage: true,
            ),
          )
        : const CustomShimmer(height: 180, width: double.infinity);
  }

  Widget _buildCategoryGrid() {
    return (controller.getCategoryModel.categoryList != null)
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.getCategoryModel.categoryList?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final element = controller.getCategoryModel.categoryList?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => SelectSubcategoryScreen(
                        categoryId: "${element?.categoryId}",
                        categoryName: "${element?.categoryName}",
                        userId: widget.userId,
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage("${element?.categoryImage}"),
                        radius: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${element?.categoryName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return const CustomShimmer(radius: 16);
            },
          );
  }

  Widget _appDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("User Info"),
          ),
          ListTile(title: Text("Home"), leading: Icon(Icons.home)),
          ListTile(title: Text("Settings"), leading: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
