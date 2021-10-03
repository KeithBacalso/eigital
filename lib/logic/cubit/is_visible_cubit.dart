import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'is_visible_state.dart';

class IsVisibleCubit extends Cubit<IsVisibleState> {
  IsVisibleCubit() : super(IsVisibleState(isVisible: true));

  void visible() => emit(IsVisibleState(isVisible: false));
}
