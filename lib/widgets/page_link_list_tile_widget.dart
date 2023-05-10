import 'package:flutter/material.dart';

import '../models/page_link.dart';

class PageLinkListTileWidget extends StatelessWidget {
  final PageLink pageLink;

  const PageLinkListTileWidget({Key? key, required this.pageLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: pageLink.icon,
      title: Text(pageLink.label),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushNamed(context, pageLink.route); // Navigate to the route
      },
    );
  }
}