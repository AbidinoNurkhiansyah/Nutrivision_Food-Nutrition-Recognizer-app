import 'package:flutter/material.dart';

class ClassificatioinItem extends StatelessWidget {
  final String item;
  final String value;

  const ClassificatioinItem({
    super.key,
    required this.item,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 224, 236, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Color.fromRGBO(172, 63, 120, .8),
              ),
            ),
            Text(
              item,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Color.fromRGBO(155, 37, 98, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
