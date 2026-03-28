import 'package:flutter/material.dart';
import 'package:health_trace/src/core/theme/app_theme_constants.dart';
import 'package:health_trace/src/core/theme/theme_helper.dart';

// ── Circular Icon Button (back, settings, share, etc.) ──────────────────────
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(color: context.border),
        ),
        child: Icon(icon, size: size * 0.44, color: context.textM),
      ),
    );
  }
}

// Custom Button Widget
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonVariant variant;
  final Size? size;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = ButtonVariant.primary,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || isLoading;

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: size,
            padding: padding,
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(text),
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: size,
            padding: padding,
          ),
          child: Text(text),
        );
      case ButtonVariant.tertiary:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          child: Text(text),
        );
    }
  }
}

enum ButtonVariant {
  primary,
  secondary,
  tertiary,
}

// Custom Input Field
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final VoidCallback? onChanged;
  final String? errorText;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            widget.label,
            style: AppTypography.labelLarge,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText && !_showPassword,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          onChanged: (value) {
            widget.onChanged?.call();
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: widget.suffixIcon != null || widget.obscureText
                ? GestureDetector(
                    onTap: () {
                      if (widget.obscureText) {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      } else {
                        widget.onSuffixIconTap?.call();
                      }
                    },
                    child: Icon(
                      widget.obscureText
                          ? (_showPassword ? Icons.visibility : Icons.visibility_off)
                          : widget.suffixIcon,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

// Custom Card Widget
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool bordered;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: margin ?? const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
          side: bordered
              ? const BorderSide(color: AppColors.borderColor)
              : BorderSide.none,
        ),
        color: backgroundColor,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}

// Custom Loading Widget
class AppLoadingIndicator extends StatelessWidget {
  final String? message;

  const AppLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: AppTypography.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

// Custom Error Widget
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Try Again',
              onPressed: onRetry!,
            ),
          ],
        ],
      ),
    );
  }
}

// Custom Empty State Widget
class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox,
            size: 64,
            color: AppColors.textColorLight,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textColorLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: actionLabel!,
              onPressed: onAction!,
            ),
          ],
        ],
      ),
    );
  }
}

// Divider Widget
class AppDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const AppDivider({
    super.key,
    this.height = 1,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Divider(
        height: height,
        color: color ?? AppColors.dividerColor,
      ),
    );
  }
}

// Custom Chip Widget
class AppChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;
  final bool selected;
  final Color? selectedColor;

  const AppChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.selected = false,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
      backgroundColor: selected
          ? (selectedColor ?? AppColors.primaryLight)
          : AppColors.dividerColor,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: selected ? AppColors.primaryColor : AppColors.textColor,
      ),
    );
  }
}
