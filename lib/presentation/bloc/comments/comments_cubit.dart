import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;

  CommentsCubit(this._repository, this._postId) : super(const CommentsState());

  //load comments
  Future<void> loadComments() async {
    emit(state.copyWith(status: CommentsStatus.loading));

    try {
      final comments = await _repository.getComments(_postId);
      emit(state.copyWith(comment: comments, status: CommentsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: 'Не удалось загрузить коментарий',
        ),
      );
    }
  }

  //addComment
  Future<void> addComment() async {
    if (!state.canSubmit) return;
    final inputText = state.inputText.trim();
    final previousComments = List<Comment>.from(state.comment);

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: _postId,
      authorId: 'me',
      content: inputText,
      createdAt: DateTime.now().toIso8601String(),
    );

    emit(
      state.copyWith(
        inputText: '',
        comment: [...state.comment, comment],
        status: CommentsStatus.success,
        errorMessage: null,
      ),
    );

    try {
      await _repository.addComment(comment);
    } catch (e) {
      emit(
        state.copyWith(
          inputText: inputText,
          comment: previousComments,
          status: CommentsStatus.failure,
          errorMessage: 'Не удалось отправить комментарий',
        ),
      );
    }
  }

  //input changed
  void inputChanged(String value) {
    emit(
      state.copyWith(
        inputText: value,
        status: state.status == CommentsStatus.failure
            ? CommentsStatus.success
            : state.status,
        errorMessage: null,
      ),
    );
  }
}
