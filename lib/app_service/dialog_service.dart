import 'package:aquatic_vendor_app/widgets/dialog_views/remove_product_dialog.dart';
import 'package:flutter/material.dart';

class DialogService {
  //remove confirmation
  static Future<bool>? removeDialogConfirmation({
    required BuildContext context,
    String? title,
    String? subtext,
    String? yesButtonText,
    String? noButtonText,
  }) async {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: StatefulBuilder(builder: (context, setState) {
        return RemoveProductDialog(
          title: title,
          subtext: subtext,
          yesButtonText: yesButtonText,
          noButtonText: noButtonText,
        );
      }),
    );
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
