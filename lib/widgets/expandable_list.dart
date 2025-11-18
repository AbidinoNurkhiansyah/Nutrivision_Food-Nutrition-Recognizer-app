import 'package:flutter/material.dart';

class ExpandableList extends StatefulWidget {
  final List<Widget> children;
  final int initialItemCount;

  const ExpandableList({
    super.key,
    required this.children,
    this.initialItemCount = 5,
  });

  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemCount = expanded
        ? widget.children.length
        : widget.initialItemCount.clamp(0, widget.children.length);

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.children.take(itemCount),
        if (widget.children.length > widget.initialItemCount)
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    expanded ? "Show less" : "Show more",
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
