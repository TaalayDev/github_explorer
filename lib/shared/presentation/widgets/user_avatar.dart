import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/theme/theme.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.url, required this.radius});

  final String url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final placeholderColor = context.extraColors.shimmerHighlight;
    return CircleAvatar(
      radius: radius,
      backgroundColor: placeholderColor,
      backgroundImage: CachedNetworkImageProvider(url),
    );
  }
}
