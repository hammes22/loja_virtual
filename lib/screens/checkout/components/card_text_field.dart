import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  CardTextField({
    this.title,
    this.bold = false,
    this.color = Colors.white,
    this.hint,
    this.textInputType,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.onSubmitted,
    this.onSaved,
    this.initialValue,
  }) : textInputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next;

  final String title;
  final bool bold;
  final Color color;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        initialValue: initialValue,
        onSaved: onSaved,
        validator: validator,
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null)
                  Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      if (state.hasError)
                        const Text(
                          ' Inválido',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                          ),
                        )
                    ],
                  ),
                TextFormField(
                  initialValue: initialValue,
                  style: TextStyle(
                    color: title == null && state.hasError ? Colors.red : color,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: title == null && state.hasError
                            ? Colors.red.withAlpha(200)
                            : color.withAlpha(100),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                      counterText: ''),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,
                  textAlign: textAlign,
                  maxLength: maxLength,
                  onChanged: (text) {
                    state.didChange(text);
                  },
                  focusNode: focusNode,
                  onFieldSubmitted: onSubmitted,
                  textInputAction: textInputAction,
                ),
              ],
            ),
          );
        });
  }
}
