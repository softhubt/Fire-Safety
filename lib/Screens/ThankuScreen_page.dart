import 'package:flutter/material.dart';


class ThankYouScreen extends StatefulWidget {
  final String fromWhere;

  ThankYouScreen({Key? key, required this.fromWhere}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            widget.fromWhere == "tiffin" ? "assets/Artboard 1icons_pfp.png" : "assets/thankyouVector.png",
            height: 300,
          ),
          SizedBox(height: 20),
          Text(
            widget.fromWhere == "tiffin" ? "Your tiffin has\nbeen Cancelled" : "THANK\nYOU!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fromWhere == "tiffin" ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Image.asset(
        "assets/bottomCurve.png",
        fit: BoxFit.cover,
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AssessmentPage()),
          // );
        },
        child: Text(
          'Next',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange, // Button color
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position the button at the bottom right corner
    );
  }
}
