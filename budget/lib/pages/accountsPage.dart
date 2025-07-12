import 'package:budget/colors.dart';
import 'package:budget/functions.dart';
import 'package:budget/main.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/accountAndBackup.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/outlinedButtonStacked.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return PageFramework(
      horizontalPaddingConstrained: true,
      dragDownToDismiss: true,
      expandedHeight: 56,
      title: "data-backup".tr(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButtonStacked(
                          text: "export-data".tr(),
                          iconData: appStateSettings["outlinedIcons"]
                              ? Icons.file_upload_outlined
                              : Icons.file_upload_rounded,
                          onTap: () async {
                            await exportData(context);
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButtonStacked(
                          text: "import-data".tr(),
                          iconData: appStateSettings["outlinedIcons"]
                              ? Icons.file_download_outlined
                              : Icons.file_download_rounded,
                          onTap: () async {
                            await importData(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFont(
                    text: "local-backup-description".tr(),
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    maxLines: 10,
                    textColor: getColor(context, "textLight"),
                  ),
                ),
                SizedBox(height: 75),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
