import 'package:aquatic_vendor_app/widgets/input/app_button.dart';
import 'package:flutter/material.dart';

class RemoveProductDialog extends StatefulWidget {
  final String? title;
  final String? subtext;
  final String? yesButtonText;
  final String? noButtonText;
  RemoveProductDialog({
    this.title,
    this.subtext,
    this.yesButtonText,
    this.noButtonText,
    Key? key,
  }) : super(key: key);

  @override
  _RemoveProductDialogState createState() => _RemoveProductDialogState();
}

class _RemoveProductDialogState extends State<RemoveProductDialog> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title ?? 'Remove Product',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.subtext ?? 'Are you sure want to remove ?',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 14.0,
                        height: 1.5,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          padding: 8.0,
                          height: 42.0,
                          width: double.infinity,
                          title: widget.noButtonText ?? 'Go Back',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: AppButton(
                          padding: 8.0,
                          height: 42.0,
                          width: double.infinity,
                          title: widget.yesButtonText ?? 'Remove',
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
