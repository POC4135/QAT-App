import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class SimpleDisclosureCard extends StatefulWidget {
  const SimpleDisclosureCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.collapsedLabel = 'Show details',
    this.expandedLabel = 'Hide details',
    this.initiallyExpanded = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final String collapsedLabel;
  final String expandedLabel;
  final bool initiallyExpanded;

  @override
  State<SimpleDisclosureCard> createState() => _SimpleDisclosureCardState();
}

class _SimpleDisclosureCardState extends State<SimpleDisclosureCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final ui = context.qatUi;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(ui.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                ),
                label: Text(
                  _expanded ? widget.expandedLabel : widget.collapsedLabel,
                ),
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: 14),
              widget.child,
            ],
          ],
        ),
      ),
    );
  }
}
