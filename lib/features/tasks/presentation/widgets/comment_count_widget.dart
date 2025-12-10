import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/comment/comment_bloc.dart';

class CommentCountWidget extends StatefulWidget {
  final String taskId;
  const CommentCountWidget({super.key, required this.taskId});

  @override
  State<CommentCountWidget> createState() => _CommentCountWidgetState();
}

class _CommentCountWidgetState extends State<CommentCountWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(LoadCommentsEvent(widget.taskId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        int commentCount = 0;

        if (state is CommentsLoaded) {
          commentCount = state.comments.length;
        }
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.comment_sharp, size: 15, color: Colors.grey),
            Text(
              "$commentCount Comments",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
