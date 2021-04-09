import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class DisplayModeController extends StateNotifier<DiaryRecordDisplayMode> {
  DisplayModeController() : super(DiaryRecordDisplayMode.list) {
    SharedPreferences.getInstance().then((sp) {
      var displayMode = sp.getInt("displayMode");
      if (displayMode == null) return;
      state = DiaryRecordDisplayMode.values[displayMode];
    });
  }

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

var displayModeControllerProvider =
    StateNotifierProvider<DisplayModeController, DiaryRecordDisplayMode>(
        (ref) => DisplayModeController());

var displayModeStrProvider = Provider<String>((ref) {
  var displayMode = ref.watch(displayModeControllerProvider);
  if (displayMode == DiaryRecordDisplayMode.list) return "Списком";
  if (displayMode == DiaryRecordDisplayMode.day) return "По дням";
  if (displayMode == DiaryRecordDisplayMode.week) return "По неделям";
  throw "Хз как парсить в строку: $displayMode";
});
