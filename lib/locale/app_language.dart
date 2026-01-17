import 'package:flutter/material.dart';

typedef LocaleInstance = Map<AppLocale, String?>;
typedef K = AppLocale;

extension StaticString on AppLocale {
  static const String
      appName = 'Watashi QR',
      appVersion = '1.2.0.alpha',
      appVersionTag = 'v1.1.alpha_25.12.09',
      pngLabel = 'PNG',
      jpgLabel = 'JPG',
      svgLabel = 'SVG',
      nullString = 'NULL<String>',
      // Animations
      // Default font
      // External Services Label
      googleLabel = 'Google',
      bingLabel = 'Bing',
      wikipediaLabel = 'Wikipedia',
      googleUrl = 'https://www.google.com/search?q={code}',
      bingUrl = 'https://www.bing.com/search?q={code}',
      wikipediaUrl = 'https://wikipedia.org/w/index.php?search={code}',
      // Preferences Settings Keys
      // Preferences Entry Values
      // About Library Third
      // Activity KTX
      // Preference KTX
      // Lifecycle Livedata KTX
      // AppCompat
      // ConstraintLayout
      // RecyclerView
      // Material Components for Android
      // CameraX
      // Room
      // Retrofit
      // Gson
      // Coil
      // Koin
      // Zxing
      // Android Image Cropper
      // ez-vcard
      // Color Picker
      // Link
      sourceCodeLink = 'https://github.com/oniyukai/watashi_qr',
      // Local Language text
      localeLanguageEn = 'English',
      localeLanguageJa = '日本語',
      localeLanguageZhHans = '简体中文',
      localeLanguageZhHant = '繁體中文';
}

enum AppLocale {
  // Permission Denied
  cameraPermissionDenied,
  // Menu Item
  titleScan,
  titleHistory,
  titleGenerate,
  titleSettings,
  titleQrCodeCreator,
  titleBarCodeCreator,
  createQrFromClipboard,
  shareToThisAppLabel,
  // Barcode Type
  barcodeQrCodeLabel,
  barcodeDataMatrixLabel,
  barcodePdf417Label,
  barcodeAztecLabel,
  barcodeEan13Label,
  barcodeEan8Label,
  barcodeUpcALabel,
  barcodeUpcELabel,
  barcodeCode128Label,
  barcodeCode93Label,
  barcodeCode39Label,
  barcodeCodabarLabel,
  barcodeItfLabel,
  // QR Type
  qrCodeTypeNameText,
  qrCodeTypeNameWebSite,
  qrCodeTypeNameContact,
  qrCodeTypeNameMail,
  qrCodeTypeNameSms,
  qrCodeTypeNamePhone,
  qrCodeTypeNameLocation,
  qrCodeTypeNameEvent,
  qrCodeTypeNameWifi,
  // Product Type
  barCodeTypeProduct,
  barCodeTypeIndustrial,
  // Error Correction Level
  qrCodeErrorCorrectionLevelLabel,
  qrCodeErrorCorrectionLevelSettingsLabel,
  qrCodeErrorCorrectionLevelNameLow,
  qrCodeErrorCorrectionLevelNameMedium,
  qrCodeErrorCorrectionLevelNameQuartile,
  qrCodeErrorCorrectionLevelNameHigh,
  // History
  labelHistoryEmpty,
  popupMessageConfirmationDeleteHistory,
  popupMessageConfirmationDeleteSelectedItemsHistory,
  menuItemHistoryDeleteFromHistory,
  menuItemHistoryRemovedFromHistory,
  menuItemHistoryAddInHistory,
  menuItemHistoryAddedInHistory,
  menuItemHistoryAddFavorite,
  menuItemHistoryRemoveFavorite,
  deleteLabel,
  cancelLabel,
  // Export File
  exportJsonLabel,
  importJsonLabel,
  shareJsonLabel,
  snackBarMessageFileExportSuccess,
  snackBarMessageFileExportError,
  snackBarMessageFileImportSuccess,
  snackBarMessageFileImportError,
  // CaptureActivity
  // BarcodeAnalysisActivity
  scanErrorLabel,
  aboutBarcodeInformationLabel,
  aboutBarcodeFormatLabel,
  aboutBarcodeOriginLabel,
  // Product
  // Barcode Searching Error
  // Food Beauty and Pet Food Product
  // Overview
  // Details
  // Ingredients
  // Veggie
  // Nutrition
  // Table
  // For 100g
  // Book
  // Music
  // Matrix Barcode
  barCodeContentLabel,
  // Matrix Barcode Contact Analysis
  matrixContactNameLabel,
  matrixContactOrganisationLabel,
  matrixContactJobTitleLabel,
  matrixContactPhoneLabel,
  matrixContactMailLabel,
  matrixContactAddressLabel,
  matrixContactNotesLabel,
  // Matrix Barcode Agenda Analysis
  matrixAgendaNameEventLabel,
  matrixAgendaStartDateEventLabel,
  matrixAgendaEndDateEventLabel,
  matrixAgendaPlaceEventLabel,
  matrixAgendaDescriptionEventLabel,
  // Matrix Barcode Phone Analysis
  matrixPhoneTelNumberLabel,
  // Matrix Barcode Email Analysis
  matrixEmailRecipientLabel,
  matrixSubjectLabel,
  matrixBodyLabel,
  // Matrix Barcode Wi-Fi Analysis
  matrixWifiSsidLabel,
  matrixWifiPasswordLabel,
  matrixWifiEncryptionLabel,
  matrixWifiIsHiddenLabel,
  // Matrix Barcode URL Analysis
  matrixUriUrlLabel,
  // Matrix Barcode URI UPI Analysis
  // Matrix Barcode URL Localisation Analysis
  matrixLocalisationLatitudeLabel,
  matrixLocalisationLongitudeLabel,
  matrixLocalisationAltitudeLabel,
  matrixLocalisationQueryLabel,
  // Barcode Description
  barcodeCode39DescriptionLabel,
  barcodeCode93DescriptionLabel,
  barcodeCode128DescriptionLabel,
  barcodeItfDescriptionLabel,
  barcodeCodabarDescriptionLabel,
  barcodeUpcADescriptionLabel,
  barcodeUpcEDescriptionLabel,
  barcodeEan13DescriptionLabel,
  barcodeEan8DescriptionLabel,
  // Barcode Composition
  barcodeTextCompositionLabel,
  barcodeTextNoSpecialCompositionLabel,
  barcodeTextUpperNoSpecialCompositionLabel,
  barcodeDigitsCompositionLabel,
  barcodeEvenDigitsCompositionLabel,
  barcode7Digits1CheckCompositionLabel,
  barcode11Digits1CheckCompositionLabel,
  barcode12Digits1CheckCompositionLabel,
  // SnackBar Feedback
  snackBarMessageSaveBitmapOk,
  snackBarMessageSaveBitmapError,
  // Actions
  actionsLabel,
  barcodeCopiedLabel,
  actionWebSearchLabel,
  actionSendMailLabel,
  actionSendSmsLabel,
  actionCallPhoneLabel,
  actionAddToCalendar,
  actionAddToContacts,
  actionShareVcfFile,
  actionShowLocation,
  actionOpenLink,
  actionModifyBarcode,
  actionModifyNotes,
  // Wi-Fi Connection
  // QR Code Generator
  // Barcode Generator Errors
  errorBarcodeNoneCharacterMessage,
  errorBarcodeNotANumberMessage,
  errorBarcodeWrongLengthMessage,
  errorBarcodeWrongKeyMessage,
  errorBarcodeEncodingIso88591ErrorMessage,
  errorBarcodeEncodingUsAsciiErrorMessage,
  errorBarcode93RegexErrorMessage,
  errorBarcode39RegexErrorMessage,
  errorBarcodeCodabarRegexErrorMessage,
  errorBarcodeItfErrorMessage,
  errorBarcodeUpcENotStartWith0ErrorMessage,
  errorBarcodeQrUrlFormatMessage,
  errorBarcodeQrPhoneNumberMissingMessage,
  // Action Barcode Generated
  clipboardEmpty,
  // Barcode Image Editor
  // Form
  qrCodeTextGeneratorHintTextInputEditText,
  qrCodeTextGeneratorHintPhoneInputEditText,
  qrCodeTextGeneratorHintUrlInputEditText,
  qrCodeTextInputEditTextHintMessage,
  // Contact Creator
  qrCodeTypeNameGenerateFromContact,
  qrCodeImportContactFromVcard,
  qrCodeTextInputEditTextHintName,
  qrCodeTextInputEditTextHintFirstName,
  qrCodeTextInputEditTextHintWebSite,
  qrCodeTextInputEditTextHintMail1,
  qrCodeTextInputEditTextHintMail2,
  qrCodeTextInputEditTextHintMail3,
  qrCodeTextInputEditTextHintPhone1,
  qrCodeTextInputEditTextHintPhone2,
  qrCodeTextInputEditTextHintPhone3,
  qrCodeTextInputEditTextHintStreetAddress,
  qrCodeTextInputEditTextHintPostalCode,
  qrCodeTextInputEditTextHintCity,
  qrCodeTextInputEditTextHintCountry,
  qrCodeTextInputEditTextHintRegion,
  qrCodeTextInputEditTextHintNotes,
  spinnerTypeMobile,
  spinnerTypeFax,
  spinnerTypeHome,
  spinnerTypeWork,
  spinnerTypeOther,
  // Mail Creator
  qrCodeTextInputEditTextHintEmail,
  qrCodeTextInputEditTextHintEmailSubject,
  // Geo Localisation Creator
  qrCodeTextInputEditTextHintLocalisationLatitude,
  qrCodeTextInputEditTextHintLocalisationLongitude,
  qrCodeTextInputEditTextHintLocalisationHeight,
  qrCodeTextInputEditTextHintLocalisationRequest,
  // Wifi Creator
  qrCodeTextInputEditTextHintWifiSsid,
  qrCodeTextInputEditTextHintWifiPassword,
  qrCodeTextInputEditTextHintWifiHide,
  spinnerWifiEncryptionWep,
  spinnerWifiEncryptionWpa,
  spinnerWifiEncryptionSae,
  spinnerWifiEncryptionNone,
  // Event Creator
  qrCodeTextInputEditTextHintAgendaEventName,
  qrCodeTextInputEditTextHintAgendaPlace,
  qrCodeTextInputEditTextHintAgendaDescription,
  checkBoxEventAllOfDay,
  beginLabel,
  endLabel,
  // URL
  // Custom search URL
  customSearchUrls,
  customSearchUrlsAddUrl,
  customSearchUrlsModifyUrl,
  customSearchUrlsListIsEmptyMessage,
  popupMessageConfirmationDeletedAllCustomUrls,
  customUrlDeleted,
  customUrlAdded,
  customUrlUpdated,
  customSearchUrlsAddInfo,
  examples,
  customSearchUrlsErrorUrl,
  errorEmptyFields,
  // API Base URL
  // URL Engines
  // E-Commerce Engines
  // API Product Engines
  // API Sources Links
  // API Sources Description
  // Preferences
  preferencesDefault,
  // Appearance Settings
  preferencesAppearanceTitle,
  preferencesThemeLabel,
  preferencesSwitchSystemThemeLabel,
  preferencesSwitchLightThemeLabel,
  preferencesSwitchDarkThemeLabel,
  preferencesColor,
  preferencesColorMaterialYou,
  preferencesColorBlue,
  preferencesColorOrange,
  preferencesColorGreen,
  preferencesColorRed,
  preferencesColorPurple,
  // Languages Settings
  preferencesLanguagesTitle,
  preferencesLanguagesChange,
  // Remote API
  // About Remote API
  // Scan Settings
  preferencesScanTitle,
  preferencesSwitchScanAutoOpenWebsiteLabel,
  preferencesSwitchScanContinuousScanLabel,
  preferencesSwitchScanVibrateLabel,
  preferencesSwitchScanBipLabel,
  preferencesSwitchScanScreenRotationLabel,
  preferencesSwitchScanBarcodeCopiedLabel,
  preferencesSwitchScanUseFrontCameraLabel,
  // Barcode Generation Settings
  preferencesBarcodeGenerationTitle,
  // History settings-->
  preferencesSwitchScanAddBarcodeToTheHistoryLabel,
  preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel,
  preferencesSwitchHistorySaveDuplicatesLabel,
  // Search Engine Settings
  preferencesSearchTitle,
  preferencesSearchEngine,
  // Settings: Additional options
  // Shortcuts
  // About Settings
  preferencesAboutTitle,
  preferencesAboutOpenSourceLibrariesLabel,
  preferencesApplicationVersionLabel,
  preferencesApplicationVersionTagLabel,
  preferencesSourceCodeLabel;

  String get s => _instance[this] ?? '<$name>';

  static late LocaleInstance _instance;

  static void load(BuildContext context) {
    _instance = Localizations.of<LocaleInstance>(context, LocaleInstance)!;
  }
}
