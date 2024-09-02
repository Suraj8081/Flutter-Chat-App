import 'package:flutter/material.dart';
import 'package:my_chat/helper/utils.dart';

class InputFormField extends StatefulWidget {
  const InputFormField({
    super.key,
    required this.lableText,
    this.textEditingController,
    this.prefixIcon,
    this.observerText = false,
    this.isPassword = false,
    this.autocorrect = false,
    this.suffixIcon,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.suffixIconColor,
    this.preffixIconColor,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.initialValue,
    this.isDisable=false,
  });
  final String? initialValue;
  final String lableText;
  final TextEditingController? textEditingController;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool observerText;
  final bool isPassword;
  final bool autocorrect;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;
  final TextInputType keyboardType;
  final Color? suffixIconColor;
  final Color? preffixIconColor;
  final TextCapitalization textCapitalization;
  final bool isDisable;

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  bool _togglePassword = true;

  void _passwordToggle() {
    setState(() {
      _togglePassword = !_togglePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      onSaved: widget.onSaved,
      keyboardType: widget.keyboardType,
      autocorrect: widget.autocorrect,
      initialValue: widget.initialValue,
      enabled: !widget.isDisable,
      textCapitalization: widget.textCapitalization,
      validator: widget.validator,
      decoration: InputDecoration(
        label: Text(widget.lableText),
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: _passwordToggle,
                icon: Icon(
                    _togglePassword ? Icons.visibility : Icons.visibility_off),
              )
            : widget.suffixIcon,
        suffixIconColor:
            widget.suffixIconColor ?? getThemeColor(context).primary,
        prefixIconColor:
            widget.preffixIconColor ?? getThemeColor(context).primary,
      ),
      obscureText: widget.observerText ? _togglePassword : false,
    );
  }
}
