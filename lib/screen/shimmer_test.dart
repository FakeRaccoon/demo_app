import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Shimmer.fromColors(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]),
          ),
        ),
      ),
    );
  }
}
