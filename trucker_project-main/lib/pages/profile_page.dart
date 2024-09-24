import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_project/components/models/user.dart';
import 'package:trucker_project/components/my_bio_box.dart';
import 'package:trucker_project/components/my_input_alert_box.dart';
import 'package:trucker_project/components/my_post_tile.dart';
import 'package:trucker_project/components/my_profile_stats.dart';
import 'package:trucker_project/helper/navigate_pages.dart';
import 'package:trucker_project/services/auth/auth_service.dart';
import 'package:trucker_project/services/database/database_provider.dart';

/*
 
 PROFILE PAGE

This is a profile page for a given uid

 */
class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
//providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
// user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // text controller for bio
  final bioTextController = TextEditingController();

  // loading...
  bool _isLoading = true;

  //on startup,
  @override
  void initState() {
    super.initState();

    // load the user info
    loadUser();
  }

  Future<void> loadUser() async {
    // get the user profile info
    user = await databaseProvider.userProfile(widget.uid);

    // finished loading...
    setState(() {
      _isLoading = false;
    });
  }

  // show edit bio box
  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textcontroller: bioTextController,
        hintText: "Bio...",
        onPressed: saveBio,
        onPressedText: "Save",
      ),
    );
  }

  // save updated bio
  Future<void> saveBio() async {
    // start loading
    setState(() {
      _isLoading = true;
    });

    // update bio
    await databaseProvider.updateBio(bioTextController.text);

    // reload the user
    await loadUser();

    // finish loading
    setState(() {
      _isLoading = false;
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // listen to user post
    final allUserPosts = listeningProvider.filterUserPost(widget.uid);

    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // App Bar
      appBar: AppBar(
        title: Text(_isLoading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          // username handle
          Center(
            child: Text(
              _isLoading ? '' : '@${user!.username}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 25),
          // profile picture
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 25),
          // profile stats -> post
          MyProfileStats(
            postCount: allUserPosts.length,
          ),

          const SizedBox(height: 25),

          // edit bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //text
                Text(
                  "Bio",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),

                //button
                //only show edit button if its current users page
                if (user != null && user!.uid == currentUserId)
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
              ],
            ),
          ),

          const SizedBox(height: 10),
          // bio box
          MyBioBox(text: _isLoading ? '...' : user!.bio),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: Text(
              "Posts",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          // list of post from user
          allUserPosts.isEmpty
              ?

              // user post is empty
              const Center(
                  child: Text("No Post Yet..."),
                )
              :
              // user post is !empty
              ListView.builder(
                  itemCount: allUserPosts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // get individual post
                    final post = allUserPosts[index];

                    // post tile ui
                    return MyPostTile(
                      post: post,
                      onUserTap: () {},
                      onPostTap: () => goPostPage(context, post),
                    );
                  },
                )
        ],
      ),
    );
  }
}
