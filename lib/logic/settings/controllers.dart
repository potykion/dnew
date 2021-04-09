import 'package:dnew/logic/settings/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

var savedDisplayModeProvider = FutureProvider<int?>((_) async {
  return (await SharedPreferences.getInstance()).getInt("displayMode");
});

class DisplayModeController extends StateNotifier<DiaryRecordDisplayMode> {
  DisplayModeController(DiaryRecordDisplayMode state) : super(state);

  Future<void> setNextDisplayMode() async {
    late DiaryRecordDisplayMode nextDisplayMode;
    try {
      nextDisplayMode = DiaryRecordDisplayMode.values[state.index + 1];
    } on RangeError {
      nextDisplayMode = DiaryRecordDisplayMode.values[0];
    }

    (await SharedPreferences.getInstance())
        .setInt("displayMode", nextDisplayMode.index);

    state = nextDisplayMode;
  }
}

var displayModeControllerProvider = StateNotifierProvider<DisplayModeController, DiaryRecordDisplayMode>((ref) {
  return DisplayModeController(ref.watch(savedDisplayModeProvider).maybeWhen(
        data: (displayMode) => displayMode == null
            ? DiaryRecordDisplayMode.list
            : DiaryRecordDisplayMode.values[displayMode],
        orElse: () => DiaryRecordDisplayMode.list,
      ));
});

var displayModeStrProvider = Provider<String>((ref) {
  var displayMode = ref.watch(displayModeControllerProvider);
  if (displayMode == DiaryRecordDisplayMode.list) return "Списком";
  if (displayMode == DiaryRecordDisplayMode.day) return "По дням";
  if (displayMode == DiaryRecordDisplayMode.week) return "По неделям";
  throw "Хз как парсить в строку: $displayMode";
});
