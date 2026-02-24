import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2340),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2D3561), width: 1),
      ),

      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white, fontSize: 15),

        decoration: InputDecoration(
          hintText: 'Search movies...',

          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 15),

          prefixIcon: const Icon(Icons.search, color: Color(0xFF01B4E4), size: 20),
          
          suffixIcon: _hasText

              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear?.call();
                  },
                )

              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),

        onSubmitted: widget.onSearch,
        textInputAction: TextInputAction.search,
      ),

    );
  }
}
