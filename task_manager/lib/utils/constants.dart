import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../main.dart';
import 'app_str.dart';

/// Empty Title & Subtite TextFields Warning
// emptyFieldsWarning(context) {
//   return FToast.toast(
//     context,
//     msg: AppStr.oopsMsg,
//     subMsg: "You must fill all Fields!",
//     corner: 20.0,
//     duration: 2000,
//     padding: const EdgeInsets.all(20),
//   );
// }

dynamic emptyWarning(BuildContext context) {
  return FToast.toast(context,
      msg: AppStr.oopsMsg,
      subMsg: 'You must fill all fields!',
      corner: 20.0,
      duration: 2000,
      padding: const EdgeInsets.all(20));
}

/// Nothing Enter When user try to edit the current task
// nothingEnterOnUpdateTaskMode(context) {
//   return FToast.toast(
//     context,
//     msg: AppStr.oopsMsg,
//     subMsg: "You must edit the tasks then try to update it!",
//     corner: 20.0,
//     duration: 3000,
//     padding: const EdgeInsets.all(20),
//   );
// }

dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(context,
      msg: AppStr.oopsMsg,
      subMsg: 'You must edit the tasks then try to update it!',
      corner: 20.0,
      duration: 5000,
      padding: const EdgeInsets.all(20));
}

/// No task Warning Dialog
// dynamic warningNoTask(BuildContext context) {
//   return PanaraInfoDialog.showAnimatedGrow(
//     context,
//     title: AppStr.oopsMsg,
//     message:
//         "There is no Task For Delete!\n Try adding some and then try to delete it!",
//     buttonText: "Okay",
//     onTapDismiss: () {
//       Navigator.pop(context);
//     },
//     panaraDialogType: PanaraDialogType.warning,
//   );
// }

dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: AppStr.oopsMsg,
      message:
          'There is no task for delete!\n Try adding some and then try to delete it!',
      buttonText: 'Okay', onTapDismiss: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.warning);
}

/// Delete All Tasks Dialog
// dynamic deleteAllTask(BuildContext context) {
//   return PanaraConfirmDialog.show(
//     context,
//     title: AppStr.areYouSure,
//     message:
//     "Do You really want to delete all tasks? You will no be able to undo this action!",
//     confirmButtonText: "Yes",
//     cancelButtonText: "No",
//     onTapCancel: () {
//       Navigator.pop(context);
//     },
//     onTapConfirm: () {
//       BaseWidget.of(context).dataStore.box.clear();
//       Navigator.pop(context);
//     },
//     panaraDialogType: PanaraDialogType.error,
//     barrierDismissible: false,
//   );
// }

dynamic deleteAllTasks(BuildContext context) {
  return PanaraConfirmDialog.show(context,
      title: AppStr.areYouSure,
      message:
          "Do you really want to delete all tasks? You will no be able to undo this action!",
      confirmButtonText: 'Yes',
      cancelButtonText: 'No',
      onTapConfirm: () {
        // clear all box data using this command later on
        BaseWidget.of(context).dataStore.box.clear();
        Navigator.pop(context);
      },
      onTapCancel: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false);
}

/// lottie asset address
String lottieURL = 'assets/lottie/1.json';
