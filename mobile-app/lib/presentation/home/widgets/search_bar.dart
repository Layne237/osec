import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';

/// Glassmorphic catalog search field with real-time filtering.
///
/// Champ de recherche glassmorphique avec filtrage en temps réel.
///
/// Named `CourseSearchBar` to avoid colliding with Material 3's own `SearchBar`.
///
/// Nommé `CourseSearchBar` pour éviter tout conflit avec le `SearchBar` de
/// Material 3.
class CourseSearchBar extends StatefulWidget {
  const CourseSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.clearTooltip,
    this.initialValue = '',
  });

  /// Placeholder copy. / Texte indicatif.
  final String hintText;

  /// Fired on every keystroke. / Déclenché à chaque frappe.
  final ValueChanged<String> onChanged;

  /// Accessibility label for the clear button. / Libellé du bouton d'effacement.
  final String clearTooltip;

  final String initialValue;

  @override
  State<CourseSearchBar> createState() => _CourseSearchBarState();
}

class _CourseSearchBarState extends State<CourseSearchBar> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _hasText = _controller.text.isNotEmpty;
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final hasText = value.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged(value);
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.containerSurface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? AppColors.royalBlue : AppColors.glassBorder,
              width: _isFocused ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 20,
                color:
                    _isFocused ? AppColors.royalBlueLight : AppColors.secondaryText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onChanged,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: AppColors.primaryText,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
              ),
              // Clear button only appears once there is something to clear.
              AnimatedSwitcher(
                duration: AppConstants.animationFast,
                child: _hasText
                    ? IconButton(
                        key: const ValueKey('clear'),
                        onPressed: _clear,
                        tooltip: widget.clearTooltip,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.secondaryText,
                        ),
                      )
                    : const SizedBox(key: ValueKey('empty'), width: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
