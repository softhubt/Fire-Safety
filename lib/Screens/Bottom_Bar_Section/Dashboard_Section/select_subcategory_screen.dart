import 'package:firesafety/Screens/Bottom_Bar_Section/My_Course_Section/my_purchase_categotylist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firesafety/Constant/color_constant.dart';
import 'package:firesafety/Constant/layout_constant.dart';
import 'package:firesafety/Constant/textstyle_constant.dart';
import 'package:firesafety/Controllers/select_subcategory_controller.dart';
import 'package:firesafety/Screens/Bottom_Bar_Section/Dashboard_Section/course_list_screen.dart';
import 'package:firesafety/Widgets/custom_appbar.dart';
import 'package:firesafety/Widgets/custom_no_data_found.dart';

class SelectSubcategoryScreen extends StatefulWidget {
  final String categoryId;
  final String userId;

  const SelectSubcategoryScreen({super.key, required this.categoryId, required this.userId});

  @override
  State<SelectSubcategoryScreen> createState() => _SelectSubcategoryScreenState();
}

class _SelectSubcategoryScreenState extends State<SelectSubcategoryScreen> {
  SelectSubcategoryController controller = Get.put(SelectSubcategoryController());

  @override
  void initState() {
    super.initState();
    // Fetch the subcategory data when the screen is initialized
    controller
        .getSubcategory(categoryId: widget.categoryId, userId: widget.userId)
        .whenComplete(() => setState(() {})); // Call setState to refresh the UI after data load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Subcategories",
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: ColorConstant.white)),
      ),
      body: Padding(
        padding: screenPadding,
        child: (controller.getSubcategoryModel.subcategoryList != null)
            ? ListView.builder(
          itemCount: controller.getSubcategoryModel.subcategoryList?.length,
          itemBuilder: (BuildContext context, int index) {
            // Access the subcategory data for each item
            var subcategory = controller.getSubcategoryModel.subcategoryList?[index];

            return GestureDetector(
              onTap: () {
                // Access the subcategory object
                var subcategory = controller.getSubcategoryModel.subcategoryList?[index];

                // Check if the subcategory has been purchased (is_purchase == 1)
                if (subcategory?.isPurchase == 1) {
                  // If is_purchase is 1, navigate to MypurchesCatrgotyListscreen
                  Get.to(() => MypurchesCatrgotyListscreen(
                    userId: widget.userId,
                  ));
                } else {
                  // If is_purchase is 0, navigate to CourseListScreen
                  Get.to(() => CourseListScreen(
                    categoryId: "${subcategory?.categoryId}",
                    subcategoryId: "${subcategory?.subcategoryId}",
                    amount: "${subcategory?.amount}",
                    days: "${subcategory?.days}",
                    userId: widget.userId,
                    isPurchase: "${subcategory?.isPurchase}",
                  ));
                }
              },
              child: Card(
                child: Container(

                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child:
                  Column(
                    children: [
                      // Display subcategory name above the image, not centered
                      // Text(
                      //   "${subcategory?.subcategoryName}",
                      //   style: TextStyleConstant.semiBold16(),
                      //   textAlign: TextAlign.start, // Align to start (left)
                      //   overflow: TextOverflow.ellipsis,
                      // ),

                      // Image display at the top - full width
                      SizedBox(
                        height: Get.height * 0.2, // Adjust height as necessary
                        width: double.infinity, // Full width
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18), // Set the border radius to make it circular
                          child: Container(
                            child: Image.network(
                              "${subcategory?.subcategoryImage}",
                              fit: BoxFit.fill, // Stretch image to cover entire area
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10), // Spacing between image and text

                      // Text content
                      Row(
                        children: [
                          // Text content with subcategory details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.school,  // School icon
                                      size: 20,       // Adjust the icon size as needed
                                      color: ColorConstant.primary,  // Optional: Set the icon color
                                    ),
                                    SizedBox(width: 8),  // Space between the icon and the text
                                    Text(
                                      "${subcategory?.subcategoryName}",
                                      style: TextStyleConstant.semiBold16(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Row with "Buy" and "Price" buttons
                      SizedBox(height: 10), // Add space between text and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Buy Button
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeightPadding,
                              left: screenWidthPadding,
                              right: screenWidthPadding,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Show price or handle price-related actions
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Price"),
                                    content: Text(
                                      "₹${subcategory?.amount}",
                                      style: TextStyle(color: ColorConstant.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primary, // Customize button color if needed
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('₹${subcategory?.amount}',
                                  style: TextStyleConstant.semiBold16(color: Colors.white)),
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the purchase screen
                              Get.to(() => CourseListScreen(
                                categoryId: "${subcategory?.categoryId}",
                                subcategoryId: "${subcategory?.subcategoryId}",
                                amount: "${subcategory?.amount}",
                                days: "${subcategory?.days}",
                                userId: widget.userId,
                                isPurchase: "${subcategory?.isPurchase}",
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.primary,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Buy Now', style: TextStyleConstant.semiBold16(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            );
          },
        )
            : const CustomNoDataFound(),
      ),
    );
  }
}
