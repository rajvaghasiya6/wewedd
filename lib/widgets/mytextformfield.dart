// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';

class MyTextFormField extends StatefulWidget {
  late bool autoFocus;
  late String? hintText;
  late String? lable;
  late TextInputType? keyboardType;
  late int? maxLength;
  late FocusNode? focusNode;
  late EdgeInsetsGeometry? contentPadding;
  late bool showEye;
  late TextCapitalization? textCapitalization = TextCapitalization.sentences;
  late FormFieldValidator<String>? validator;
  late ValueChanged<String>? onChanged;
  late ValueChanged<String>? onFieldSubmitted;
  late TextEditingController? controller;
  late TextInputAction? textInputAction;
  late bool isPassword = false;
  late bool readOnly = false;
  bool? isEnableInteractiveSelection;
  late bool isEnable = true;
  late Widget? icon;
  late Widget? suffix;
  late Widget? suffixIcon;
  late int? maxLines;
  late int? minLines;
  List<TextInputFormatter>? inputFormatters;

  MyTextFormField(
      {Key? key,
      this.hintText,
      this.keyboardType,
      this.lable,
      this.maxLength,
      this.focusNode,
      this.showEye = false,
      this.textCapitalization,
      this.validator,
      this.onChanged,
      this.onFieldSubmitted,
      this.controller,
      this.textInputAction,
      this.isPassword = false,
      this.readOnly = false,
      this.isEnableInteractiveSelection,
      this.icon,
      this.suffix,
      this.suffixIcon,
      this.maxLines,
      this.minLines,
      this.contentPadding,
      this.inputFormatters,
      this.isEnable = true,
      this.autoFocus = false})
      : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.lable != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 9.0, left: 4, right: 4),
            child: Text("${widget.lable}",
                style: poppinsLight.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        TextFormField(
          autofocus: widget.autoFocus,
          enabled: widget.isEnable,
          enableInteractiveSelection:
              widget.isEnableInteractiveSelection ?? true,
          readOnly: widget.readOnly,
          controller: widget.controller,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.sentences,
          keyboardType: widget.keyboardType,
          style: const TextStyle(fontSize: 12),
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          validator: widget.validator,
          textInputAction: widget.textInputAction,
          obscureText: widget.isPassword,
          inputFormatters: widget.inputFormatters,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            filled: true,
            // fillColor: white.withOpacity(0.8),
            hintText: widget.hintText ?? "",
            hintStyle: poppinsNormal.copyWith(color: grey, fontSize: 13),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.only(left: 20, right: 0, top: 20, bottom: 20),
            counterText: "",
            errorStyle: TextStyle(
                color: Colors.red.shade500,
                fontWeight: FontWeight.w500,
                fontSize: 12),
            prefixIcon: widget.icon,
            suffix: widget.suffix,
            suffixIcon: widget.suffixIcon,
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                color: Colors.red,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
