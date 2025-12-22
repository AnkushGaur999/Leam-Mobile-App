sealed class DataState<T> {
  final T? data;
  final String? message;

  DataState({this.data, this.message});
}

final class DataSuccess<T> extends DataState<T> {
  DataSuccess({required T data}) : super(data: data);
}

final class DataError<T> extends DataState<T> {
  DataError({required String message}) : super(message: message);
}
