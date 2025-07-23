import 'dart:async';
import 'dart:typed_data';
import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/main.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openPopup.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/util/saveFile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

Future<void> exportData(BuildContext context) async {
  try {
    openLoadingPopup(context);
    DBFileInfo currentDBFileInfo = await getCurrentDBFileInfo();
    popRoute(context);
    await saveFile(
      boxContext: context,
      dataStore: currentDBFileInfo.dbFileBytes.toList(),
      dataString: null,
      fileName: "sentinel_backup.sqlite",
      successMessage: "backup-saved-success".tr(),
      errorMessage: "error-saving".tr(),
    );
  } catch (e) {
    popRoute(context);
    openSnackbar(
      SnackbarMessage(
        title: "Error exporting data",
        description: e.toString(),
        icon: appStateSettings["outlinedIcons"]
            ? Icons.error_outlined
            : Icons.error_rounded,
      ),
    );
  }
}

Future<void> importData(BuildContext context) async {
  try {
    DBFileInfo? dbFileInfo = await getImportDBFileInfo(context);
    if (dbFileInfo != null) {
      final result = await openPopup(
        context,
        title: "load-backup".tr(),
        description: "load-backup-warning".tr(),
        icon: appStateSettings["outlinedIcons"]
            ? Icons.warning_outlined
            : Icons.warning_rounded,
        onSubmit: () => popRoute(context, true),
        onSubmitLabel: "load".tr(),
        onCancel: () => popRoute(context, false),
        onCancelLabel: "cancel".tr(),
      );
      if (result == true) {
        openLoadingPopup(context);
        await overwriteDefaultDB(dbFileInfo.dbFileBytes);
        popRoute(context);
        await updateSettings("databaseJustImported", true,
            pagesNeedingRefresh: [], updateGlobalState: false);
        restartAppPopup(
          context,
          description: "restart-required-to-load-backup".tr(),
        );
      }
    }
  } catch (e) {
    openSnackbar(
      SnackbarMessage(
        title: "Error importing data",
        description: e.toString(),
        icon: appStateSettings["outlinedIcons"]
            ? Icons.error_outlined
            : Icons.error_rounded,
      ),
    );
  }
}

Future<DBFileInfo?> getImportDBFileInfo(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );
  if (result != null && result.files.single.path != null) {
    try {
      final file = File(result.files.single.path!);
      Uint8List fileBytes = await file.readAsBytes();
      return DBFileInfo(fileBytes, Stream.value([]));
    } catch (e) {
      openSnackbar(
        SnackbarMessage(
          title: "Error reading file",
          description: e.toString(),
        ),
      );
    }
  }
  return null;
}