import 'package:flutter/material.dart';

typedef DictInstance = Map<DictKey, String?>;

extension StaticString on DictKey {
  static const String
      appName = 'Watashi QR',
      appVersion = '1.2.0',
      appVersionTag = 'v1.1_26.02.01',
      pngSuffix = 'png',
      jpgSuffix = 'jpg',
      svgSuffix = 'svg',
      nullString = 'NULL<String>',
      // External Services Label
      searchReplaceWord = '{code}',
      googleLabel = 'Google',
      bingLabel = 'Bing',
      wikipediaLabel = 'Wikipedia',
      googleUrl = 'https://www.google.com/search?q=$searchReplaceWord',
      bingUrl = 'https://www.bing.com/search?q=$searchReplaceWord',
      wikipediaUrl = 'https://wikipedia.org/w/index.php?search=$searchReplaceWord',
      // Link
      sourceCodeLink = 'https://github.com/oniyukai/watashi_qr',
      // Local Language text
      localeLanguageEn = 'English',
      localeLanguageJa = '日本語',
      localeLanguageZhHans = '简体中文',
      localeLanguageZhHant = '繁體中文';
}

enum DictKey {
  // ===== Common: Basic UI & Permissions =====
  commonPermCameraDenied,
  commonUiDelete,
  commonUiCancel,
  commonUiBegin,
  commonUiEnd,
  commonUiActions,
  commonUiExamples,
  commonUiClipboardEmpty,

  // ===== Nav: Navigation & Page Titles =====
  navTitleScan,
  navTitleGenerate,
  navTitleHistory,
  navTitleSettings,
  navTitleCreateQrCode,
  navTitleCreateBarCode,

  // --- Creator Entry ---
  navCreateFromClipboard,
  navShareToAppLabel,

  // ===== Barcode: Formats, Types & Specs =====
  // --- Formats ---
  barcodeFormatQrCode,
  barcodeFormatDataMatrix,
  barcodeFormatAztec,
  barcodeFormatPdf417,
  barcodeFormatEan13,
  barcodeFormatEan8,
  barcodeFormatUpcA,
  barcodeFormatUpcE,
  barcodeFormatCode128,
  barcodeFormatCode93,
  barcodeFormatCode39,
  barcodeFormatCodabar,
  barcodeFormatItf,

  // --- Types ---
  barcodeTypeText,
  barcodeTypeWebsite,
  barcodeTypeContact,
  barcodeTypeMail,
  barcodeTypeSms,
  barcodeTypePhone,
  barcodeTypeLocation,
  barcodeTypeEvent,
  barcodeTypeWifi,
  barcodeTypeProduct,
  barcodeTypeIndustrial,

  // ===== History: Records Management =====
  historyStatusEmpty,
  historyDialogDeleteAll,
  historyDialogDeleteSelected,
  historyMenuDelete,
  historyStatusRemoved,
  historyMenuAdd,
  historyStatusAdded,
  historyMenuFavAdd,
  historyMenuFavRemove,

  // --- Data Exchange ---
  historyDataExportJson,
  historyDataImportJson,
  historyDataShareJson,
  historyDataExportSuccess,
  historyDataExportError,
  historyDataImportSuccess,
  historyDataImportError,

  // ===== Analysis: Scan Result Details =====
  analysisScanError,
  analysisGroupInfo,
  analysisLabelFormat,
  analysisLabelOrigin,
  analysisLabelContent,
  analysisStatusCopied,

  // --- Contact Detail ---
  analysisContactName,
  analysisContactOrganisation,
  analysisContactJobTitle,
  analysisContactPhone,
  analysisContactMail,
  analysisContactAddress,
  analysisContactNotes,

  // --- Event Detail ---
  analysisEventName,
  analysisEventStart,
  analysisEventEnd,
  analysisEventPlace,
  analysisEventDescription,

  // --- Comms Detail ---
  analysisPhoneNumber,
  analysisMailRecipient,
  analysisMailSubject,
  analysisMailBody,

  // --- Network & Geo Detail ---
  analysisWifiSsid,
  analysisWifiPassword,
  analysisWifiEncryption,
  analysisWifiIsHidden,
  analysisUriUrl,
  analysisGeoLatitude,
  analysisGeoLongitude,
  analysisGeoAltitude,
  analysisGeoQuery,

  // ===== Creator: Forms & Hints =====
  // --- Hints ---
  creatorHintText,
  creatorHintPhone,
  creatorHintUrl,
  creatorHintMessage,

  // --- Contact Creator ---
  creatorContactFromBook,
  creatorContactFromVcard,
  creatorContactHintName,
  creatorContactHintFirstName,
  creatorContactHintWebSite,
  creatorContactHintMail1,
  creatorContactHintMail2,
  creatorContactHintMail3,
  creatorContactHintPhone1,
  creatorContactHintPhone2,
  creatorContactHintPhone3,
  creatorContactHintStreetAddress,
  creatorContactHintPostalCode,
  creatorContactHintCity,
  creatorContactHintCountry,
  creatorContactHintRegion,
  creatorContactHintNotes,

  // --- Spinner Options ---
  creatorOptionMobile,
  creatorOptionFax,
  creatorOptionHome,
  creatorOptionWork,
  creatorOptionOther,

  // --- Mail Creator ---
  creatorMailHintEmail,
  creatorMailHintSubject,

  // --- Geo Creator ---
  creatorGeoHintLatitude,
  creatorGeoHintLongitude,
  creatorGeoHintAltitude,
  creatorGeoHintQuery,

  // --- Wifi Creator ---
  creatorWifiHintSsid,
  creatorWifiHintPassword,
  creatorWifiHintHide,
  creatorWifiEncryptionWep,
  creatorWifiEncryptionWpa,
  creatorWifiEncryptionSae,
  creatorWifiEncryptionNone,

  // --- Event Creator ---
  creatorEventHintSummary,
  creatorEventHintPlace,
  creatorEventHintDescription,
  creatorEventOptionAllDay,

  // ===== Barcode Specs: Rule & Description =====
  // --- Descriptions ---
  barcodeDescriptionEan13,
  barcodeDescriptionEan8,
  barcodeDescriptionUpcA,
  barcodeDescriptionUpcE,
  barcodeDescriptionCode128,
  barcodeDescriptionCode93,
  barcodeDescriptionCode39,
  barcodeDescriptionCodabar,
  barcodeDescriptionItf,

  // --- Rule Composition ---
  barcodeCompositionText,
  barcodeCompositionTextSimple,
  barcodeCompositionTextUpperSimple,
  barcodeCompositionDigits,
  barcodeCompositionEvenDigitNumbers,
  barcodeComposition7Digits1Check,
  barcodeComposition11Digits1Check,
  barcodeComposition12Digits1Check,

  // ===== Action: Interaction & Feedback =====
  actionStatusImageSaveOk,
  actionStatusImageSaveError,
  actionWebSearch,
  actionSendMail,
  actionSendSms,
  actionCallPhone,
  actionAddToCalendar,
  actionAddToContacts,
  actionShareVcfFile,
  actionShowLocation,
  actionOpenLink,
  actionModifyBarcode,
  actionModifyNotes,

  // --- Validation Errors ---
  errorEmptyFields,
  errorInvalidValue,
  errorNotNumber,
  errorWrongLength,
  errorWrongCheckDigit,
  errorUnsupportedCharsIso88591,
  errorUnsupportedCharsAscii,
  errorRegexCode93,
  errorRegexCode39,
  errorRegexCodabar,
  errorItfEvenDigit,
  errorUpcEStartZero,
  errorUrlFormat,
  errorPhoneNumber,

  // ===== Setting: Sections & Options =====
  settingOptionDefault,

  // --- Appearance ---
  settingGroupAppearance,
  settingOptionTheme,
  settingOptionThemeSystem,
  settingOptionThemeLight,
  settingOptionThemeDark,
  settingOptionColor,
  settingOptionColorMaterialYou,
  settingOptionColorBlue,
  settingOptionColorOrange,
  settingOptionColorGreen,
  settingOptionColorRed,
  settingOptionColorPurple,

  // --- Languages ---
  settingGroupLanguages,
  settingOptionLanguagesChange,

  // --- Scan ---
  settingGroupScan,
  settingOptionScanAutoOpenWebsite,
  settingOptionScanContinuousScan,
  settingOptionScanVibrate,
  settingOptionScanBip,
  settingOptionScanLockOrient,
  settingOptionScanAutoCopy,
  settingOptionScanUseFrontCamera,

  // --- Generation ---
  settingGroupGeneration,
  settingOptionQrErrorCorrectionLevel,
  settingDialogQrErrorCorrectionLevelTitle,
  settingOptionQrErrorCorrectionLevelLow,
  settingOptionQrErrorCorrectionLevelMedium,
  settingOptionQrErrorCorrectionLevelQuartile,
  settingOptionQrErrorCorrectionLevelHigh,

  // --- History Logic ---
  settingOptionHistoryAddScan,
  settingOptionHistoryAddCreate,
  settingOptionHistoryAddWithDuplicates,

  // --- Search ---
  settingGroupSearch,
  settingOptionSearchEngine,
  settingOptionCustomSearch,
  settingOptionCustomSearchAdd,
  settingOptionCustomSearchEdit,
  settingOptionCustomSearchEmpty,
  settingOptionCustomSearchClearAll,
  settingOptionCustomSearchDeleted,
  settingOptionCustomSearchAdded,
  settingOptionCustomSearchUpdated,
  settingOptionCustomSearchInfo,
  settingErrorCustomUrl,

  // --- About ---
  settingGroupAbout,
  settingOptionLicenses,
  settingOptionVersion,
  settingOptionVersionTag,
  settingOptionSourceCode;

  String get s => _instance[this] ?? '<$name>';

  static late DictInstance _instance;

  static void load(BuildContext context) {
    _instance = Localizations.of<DictInstance>(context, DictInstance)!;
  }
}
