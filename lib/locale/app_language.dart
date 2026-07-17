import 'package:flutter/material.dart';

typedef DictInstance = Map<DictKey, String?>;

extension StaticString on DictKey {
  static const String
      appName = 'Watashi QR',
      appVersion = '1.2.1',
      appVersionTag = 'v1.1_26.07.18+7',
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
  // ===== Common: Basic UI & Label =====
  commonLabelCameraDenied,
  commonLabelDelete,
  commonUiCancel,
  commonUiCopied,

  // ===== Nav: Navigation & Page Titles =====
  navUiPopExitApp,
  navTitleScanner,
  navTitleCreator,
  navTitleHistory,
  navTitleSettings,
  navTitleCreateQrCode,
  navTitleCreateBarCode,

  // --- Creator Entry ---
  navLabelCreateFromClipboard,
  navLabelShareToApp,

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
  analysisLabelContent,
  analysisGroupInfo,
  analysisLabelFormat,
  analysisLabelOrigin,
  analysisLabelErrorLevel,
  analysisLabelNotes,
  analysisLabelActions,

  // --- Comms Detail ---
  analysisEmail,
  analysisPhone,
  analysisMessage,

  // --- Contact Detail ---
  analysisContactName,
  analysisContactOrganisation,
  analysisContactJobTitle,
  analysisContactWebSite,
  analysisContactAddress,
  analysisContactNotes,

  // --- Event Detail ---
  analysisEventName,
  analysisEventStart,
  analysisEventEnd,
  analysisEventPlace,
  analysisEventDescription,

  // --- Mail Detail ---
  analysisMailSubject,

  // --- Network Detail ---
  analysisWifiSsid,
  analysisWifiPassword,
  analysisWifiEncryption,
  analysisWifiIsHidden,

  // --- Geo Detail ---
  analysisGeoLatitude,
  analysisGeoLongitude,
  analysisGeoAltitude,
  analysisGeoQuery,

  // ===== Creator: Forms & Hints =====
  // --- Comms ---
  creatorUiClipboardEmpty,
  creatorHintUrl,
  creatorHintEmail,
  creatorHintPhone,
  creatorHintMessage,

  // --- Contact Creator ---
  creatorContactFromBook,
  creatorContactFromVcard,
  creatorContactHintName,
  creatorContactHintFirstName,
  creatorContactHintOrganisation,
  creatorContactHintJobTitle,
  creatorContactHintWebSite,
  creatorContactHintStreetAddress,
  creatorContactHintPostalCode,
  creatorContactHintCity,
  creatorContactHintCountry,
  creatorContactHintRegion,
  creatorContactHintNotes,

  // --- Spinner Options ---
  creatorContactOptionMobile,
  creatorContactOptionFax,
  creatorContactOptionHome,
  creatorContactOptionWork,
  creatorContactOptionOther,

  // --- Mail Creator ---
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
  creatorEventLabelBegin,
  creatorEventLabelEnd,

  // ===== Barcode Specs: Rule & Description =====
  // --- Descriptions ---
  barcodeDescriptionQrCode,
  barcodeDescriptionDataMatrix,
  barcodeDescriptionAztec,
  barcodeDescriptionPdf417,
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
  barcodeCompositionEvenLengthNumbers,
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
  errorItfEvenLength,
  errorUpcEStartZero,
  errorUrlFormat,
  errorPhoneNumber,

  // ===== Setting: Sections & Options =====
  // --- Appearance ---
  settingGroupAppearance,
  settingOptionTheme,
  settingOptionThemeSystem,
  settingOptionThemeLight,
  settingOptionThemeDark,
  settingOptionColor,
  settingOptionColorMaterialYou,
  settingOptionColorBlue,
  settingOptionColorViolet,
  settingOptionColorPurple,
  settingOptionColorPink,
  settingOptionColorDeepOrange,
  settingOptionColorOrange,
  settingOptionColorYellow,
  settingOptionColorGreen,
  settingOptionColorTeal,

  // --- Languages ---
  settingGroupLanguages,
  settingOptionLanguagesChange,
  settingOptionLanguagesDefault,

  // --- Scan ---
  settingGroupScan,
  settingOptionScanAutoOpenWebsite,
  settingOptionScanContinuousScan,
  settingOptionScanVibrate,
  settingOptionScanBip,
  settingOptionScanLockOrient,
  settingOptionScanAutoCopy,
  settingOptionScanUseFrontCamera,

  // --- Create ---
  settingGroupCreate,
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
  settingOptionCustomSearchClearSelected,
  settingOptionCustomSearchClearAll,
  settingOptionCustomSearchDeleted,
  settingOptionCustomSearchAdded,
  settingOptionCustomSearchUpdated,
  settingOptionCustomSearchInfo,
  settingOptionCustomSearchExample,
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
