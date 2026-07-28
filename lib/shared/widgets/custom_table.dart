import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<DriveTableColumn> columns;
  final List<DriveTableRow> rows;

  const CustomTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, index) => _DriveTableRowWidget(
              columns: columns,
              row: rows[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: columns.map((col) {
          return Expanded(
            flex: col.flex,
            child: InkWell(
              onTap: col.onSort,
              child: Row(
                mainAxisAlignment: col.alignment,
                children: [
                  Text(
                    col.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (col.onSort != null) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_upward, size: 14, color: Colors.grey[500]),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DriveTableColumn {
  final String label;
  final int flex;
  final MainAxisAlignment alignment;
  final VoidCallback? onSort;

  const DriveTableColumn({
    required this.label,
    this.flex = 1,
    this.alignment = MainAxisAlignment.start,
    this.onSort,
  });
}

class DriveTableRow {
  final IconData? icon;
  final Color? iconColor;
  final List<String> cells;
  final VoidCallback? onTap;
  final List<Widget>? trailingActions;

  const DriveTableRow({
    this.icon,
    this.iconColor,
    required this.cells,
    this.onTap,
    this.trailingActions,
  });
}

class _DriveTableRowWidget extends StatefulWidget {
  final List<DriveTableColumn> columns;
  final DriveTableRow row;

  const _DriveTableRowWidget({required this.columns, required this.row});

  @override
  State<_DriveTableRowWidget> createState() => _DriveTableRowWidgetState();
}

class _DriveTableRowWidgetState extends State<_DriveTableRowWidget> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.row.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: _hovering ? Colors.grey.withOpacity(0.08) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: widget.columns.first.flex,
                child: Row(
                  children: [
                    if (widget.row.icon != null) ...[
                      Icon(widget.row.icon, size: 20, color: widget.row.iconColor ?? Colors.grey[600]),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        widget.row.cells.first,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              for (int i = 1; i < widget.row.cells.length; i++)
                Expanded(
                  flex: widget.columns[i].flex,
                  child: Text(
                    widget.row.cells[i],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              if (widget.row.trailingActions != null)
                ...widget.row.trailingActions!,
            ],
          ),
        ),
      ),
    );
  }
}