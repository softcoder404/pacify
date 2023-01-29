import 'package:flutter/material.dart';

class PlaceTypes extends StatelessWidget {
  const PlaceTypes({
    Key? key,
    required this.types,
  }) : super(key: key);
  final List<String> types;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: types
          .map((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      e.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  if (types.indexOf(e) != types.length - 1) //hide on last item
                    Divider(
                      color: Colors.blueGrey.shade100,
                      height: 1,
                      thickness: .5,
                    ),
                ],
              ))
          .toList(),
    );
  }
}
