import 'package:ecommerce/utils/dimensions.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textController; 
  final String hintText; 
  final IconData icon; 
  final Color backgroundColor;
  final Color iconColor; 
  const AppTextField({super.key, required this.textController, required this.hintText, required this.icon, required this.backgroundColor, required this.iconColor});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> { 
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30),
        padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
        decoration: BoxDecoration(
          color: widget.backgroundColor, 
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 1.5, 
              offset: const Offset(0,3),
              color: Colors.grey.withOpacity(0.15)
            )
          ]
        ),
        child: TextFormField(
          controller: widget.textController,
          obscureText: widget.hintText=="Password"? !_passwordVisible:false,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: Dimensions.font15,
              color: Colors.grey
            ),
            suffixIcon: widget.hintText=="Password"?
              IconButton(
                icon: Icon(
                  _passwordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
                color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                      _passwordVisible = !_passwordVisible;
                  });
                },
              )
              : null 
            ,
            prefixIcon: Icon(widget.icon, color: widget.iconColor),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width:1.0,
                color: Colors.transparent,
              )
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width:1.0,
                color: Colors.transparent,
              )
            ),
            
          ),
        )
    );
  }
}