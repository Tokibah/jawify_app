import 'package:flutter/material.dart';

class CusTextField extends StatefulWidget {
  const CusTextField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.isObscure});

  final String hint;
  final TextEditingController controller;
  final bool isObscure;

  @override
  State<CusTextField> createState() => _CusTextFieldState();
}

class _CusTextFieldState extends State<CusTextField> {
  late bool show;

  @override
  void initState() {
    show = !widget.isObscure;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CusTextField oldWidget) {
    if (widget.isObscure != oldWidget.isObscure) {
      show = !widget.isObscure;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(height: 2),
        decoration: InputDecoration(
          hintText: widget.hint,
          suffixIcon: widget.isObscure
              ? IconButton(
                  onPressed: () => setState(() => show = !show),
                  icon: show
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off))
              : null,
        ),
        validator: (value) => value == null || value.isEmpty ? "" : null,
        obscuringCharacter: '#',
        obscureText: !show,
      ),
    );
  }
}
