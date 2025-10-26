import 'package:entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:interface_adapters/src/ui/res/values/constants.dart'
    as constants;

class HomeAppBarButton extends StatelessWidget {
  const HomeAppBarButton({
    required this.language,
    super.key,
  });

  final Language language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            kHomePath,
            // This predicate removes all routes from the stack without
            // exceptions.
            (Route<Object?> route) => false,
            arguments: language,
          );
        },
        borderRadius: BorderRadius.circular(100),
        child: const ClipOval(
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              '${constants.kImagesPath}ethical_scanner_logo.jpeg',
            ),
          ),
        ),
      ),
    );
  }
}
