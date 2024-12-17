// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String buttonText;
  final Function onPressed;
  final double width;
  final double height;
  final bool isCircular;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.width,
    required this.height,
    this.isCircular = false,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: widget.isCircular ? widget.height : widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isPressed ? Colors.transparent : const Color(0xFFFF5307),
          borderRadius: widget.isCircular
              ? BorderRadius.circular(widget.height / 2)
              : BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFF5307),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
