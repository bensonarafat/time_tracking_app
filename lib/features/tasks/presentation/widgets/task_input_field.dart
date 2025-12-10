import 'package:flutter/material.dart';

class TaskInputField extends StatefulWidget {
  final String? initialValue;
  final String hintText;
  final String submitButtonText;
  final String cancelButtonText;
  final ValueChanged<String> onSubmit;
  final VoidCallback onCancel;
  final bool autofocus;
  final bool showCancelButton;
  final bool showSubmitButton;
  final bool showSendIcon;

  const TaskInputField({
    super.key,
    this.initialValue,
    this.hintText = 'Enter content...',
    this.submitButtonText = 'Save',
    this.cancelButtonText = 'Cancel',
    required this.onSubmit,
    required this.onCancel,
    this.autofocus = true,
    this.showCancelButton = true,
    this.showSubmitButton = true,
    this.showSendIcon = false,
  });

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      widget.onSubmit(content);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            maxLines: 2,
            minLines: 1,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              suffixIcon: widget.showSendIcon
                  ? IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _submit,
                      color: Colors.blue,
                    )
                  : null,
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (!widget.showSendIcon) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.showCancelButton)
                  TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                    child: Text(
                      widget.cancelButtonText,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                if (widget.showCancelButton) const SizedBox(width: 8),
                if (widget.showSubmitButton)
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      widget.submitButtonText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
