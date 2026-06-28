import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isLoading;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (_) => onSearch(),
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: Colors.white.withValues(alpha: 0.8),
            size: 22,
          ),
          suffixIcon: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 24,
                  ),
                  onPressed: onSearch,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
