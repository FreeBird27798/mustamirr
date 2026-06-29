import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final void Function(String) onRoleSelected;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleButton(
            label: 'معلم',
            value: 'teacher',
            selectedRole: selectedRole,
            onTap: onRoleSelected,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RoleButton(
            label: 'طالب',
            value: 'student',
            selectedRole: selectedRole,
            onTap: onRoleSelected,
          ),
        ),
      ],
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final String value;
  final String selectedRole;
  final void Function(String) onTap;

  const _RoleButton({
    required this.label,
    required this.value,
    required this.selectedRole,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedRole == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.glow.withValues(alpha: 0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderGrey,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.dark,
            ),
          ),
        ),
      ),
    );
  }
}
