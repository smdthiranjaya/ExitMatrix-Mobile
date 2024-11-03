import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? leadingImage; // Nullable type
  final String? actionImage; // Nullable type
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onActionPressed;

  CustomAppBar({
    Key? key,
    required this.title,
    this.leadingImage,
    this.actionImage,
    this.onLeadingPressed,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          false, // Prevents AppBar from automatically inserting a back button
      leading: leadingImage != null
          ? IconButton(
              icon: SizedBox(
                width: 30, // Set the desired width
                height: 30, // Set the desired height
                child: CircleAvatar(
                  backgroundImage: (leadingImage!.startsWith('http')
                          ? NetworkImage(leadingImage!) // For network images
                          : AssetImage(leadingImage!))
                      as ImageProvider, // For local assets, cast to ImageProvider
                  backgroundColor: Colors.transparent,
                ),
              ),
              onPressed: onLeadingPressed,
            )
          : null,
      actions: actionImage != null
          ? <Widget>[
              IconButton(
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(actionImage!),
                ),
                onPressed: onActionPressed,
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
