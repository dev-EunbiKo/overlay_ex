// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String>? onChanged;
  final String hint;

  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint = 'Select an Item',
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final GlobalKey _dropdownKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder:
            (context) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: Colors.transparent)),
                  CompositedTransformFollower(
                    link: _layerLink,
                    offset: Offset(0, 60),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: _getButtonWidth(),
                        constraints: BoxConstraints(maxWidth: 200),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == widget.value;

                            return InkWell(
                              onTap: () {
                                widget.onChanged?.call(item);
                                _closeDropdown();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.blue.withAlpha(50)
                                          : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.blue.shade900
                                                  : Colors.black,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: Colors.blue.shade900,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: widget.items.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );
      Overlay.of(context).insert(_overlayEntry!);
      setState(() {
        _isOpen = true;
      });
    }
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
    });
    _hideDropdown();
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _getButtonWidth() {
    final RenderBox? renderBox =
        _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 200;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            key: _dropdownKey,
            onTap: _toggleDropdown,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value ?? widget.hint,
                      style: TextStyle(
                        color:
                            widget.value != null
                                ? Colors.black
                                : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
