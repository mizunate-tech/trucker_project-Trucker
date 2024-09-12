/*
PROFILE STATS

This will be displayed on the profile page

number of:
-post
-following
-followers
 */

import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;

  const MyProfileStats({
    super.key,
    required this.postCount,
  });

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //textstyle for count
    var textStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);

    //textstyle for text
    var textStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //posts
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                postCount.toString(),
                style: textStyleForCount,
              ),
              Text(
                "Posts",
                style: textStyleForText,
              )
            ],
          ),
        ),
      ],
    );
  }
}
