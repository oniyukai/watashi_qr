// extension KeyTools on LanguageKey {
//   static String labelGenerator(String func, String typeDef) {
//     String s = '';
//     for (final item in LanguageKey.values) {
//       s += 'String get ${item.name} => $func($typeDef.${item.name});\n';
//     }
//     return s;
//   }
//
//   static String templateGenerator(Map<LanguageKey, String> map, String typeDef) {
//     String s = '';
//     for (final item in LanguageKey.values) {
//       final text = map[item] != null ? "'${map[item]}'" : null;
//       s += '$typeDef.${item.name}: $text,\n';
//     }
//     return s;
//   }
// }

enum LanguageKey {
  // Permission Denied
  cameraPermissionDenied,
  // AlertDialog
  closeDialogLabel,
  yesLabel,
  noLabel,
  goToDialogLabel,
  error,
  // ImageView Description
  imageViewDescriptionFlag,
  imageViewDescriptionLogo,
  imageViewDescriptionTypeIcon,
  imageViewDescriptionBarCode,
  imageViewDescriptionIcon,
  imageViewDescriptionProductFront,
  imageViewDescriptionNutriscore,
  imageViewDescriptionNovaGroup,
  imageViewDescriptionEcoScore,
  imageViewDescriptionBackground,
  imageViewDescriptionImage,
  sliderDescriptionZoom,
  // Menu Item
  titleScan,
  titleHistory,
  titleGenerate,
  titleSettings,
  titleQrCodeCreator,
  titleBarCodeCreator,
  createQrFromClipboard,
  informationLabel,
  barcodeLabel,
  downloadFromApiLabel,
  shareToThisAppLabel,
  menuMore,
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
  qrCodeTypeNameGeographicCoordinates,
  qrCodeTypeNameAgenda,
  qrCodeTypeNameWifi,
  qrCodeTypeNameApps,
  // Product Type
  barCodeTypeProduct,
  barCodeTypeIndustrial,
  barCodeTypeNameUnknown,
  // Error Correction Level
  qrCodeErrorCorrectionLevelLabel,
  qrCodeErrorCorrectionLevelSettingsLabel,
  qrCodeErrorCorrectionLevelNameLow,
  qrCodeErrorCorrectionLevelNameMedium,
  qrCodeErrorCorrectionLevelNameQuartile,
  qrCodeErrorCorrectionLevelNameHigh,
  // History
  labelHistoryEmpty,
  snackBarMessageItemDeleted,
  snackBarMessageItemsDeleted,
  popupMessageConfirmationDeleteHistory,
  popupMessageConfirmationDeleteSelectedItemsHistory,
  menuItemHistoryDelete,
  menuItemHistoryDeleteFromHistory,
  menuItemHistoryRemovedFromHistory,
  menuItemHistoryAddInHistory,
  menuItemHistoryAddedInHistory,
  menuItemHistoryAddFavorite,
  menuItemHistoryRemoveFavorite,
  deleteLabel,
  cancelLabel,
  recordLabel,
  // Export File
  exportLabel,
  exportJsonLabel,
  importJsonLabel,
  shareJsonLabel,
  snackBarMessageFileExportSuccess,
  snackBarMessageFileExportError,
  snackBarMessageFileImportSuccess,
  snackBarMessageFileImportError,
  // CaptureActivity
  // BarcodeAnalysisActivity
  barcodeInformationSearchLabel,
  scanErrorLabel,
  scanErrorShortInformationLabel,
  barcodeScannedLabel,
  barcodeFoundOnLabel,
  barcodeNotFoundOnApiLabel,
  noInternetPermission,
  aboutBarcodeInformationLabel,
  aboutBarcodeLabel,
  aboutBarcodeFormatLabel,
  aboutBarcodeContentLabel,
  aboutBarcodeOriginLabel,
  // Product
  // Barcode Searching Error
  // Food Beauty and Pet Food Product
  // Overview
  // Details
  // Ingredients
  // Additif
  // Veggie
  // Nutrition
  // Table
  // For 100g
  // Book
  // Music
  // Matrix Barcode
  barCodeContentLabel,
  barCodeAnalysisLabel,
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
  matrixEmailCcLabel,
  matrixEmailBccLabel,
  matrixSubjectLabel,
  matrixBodyLabel,
  // Matrix Barcode Wi-Fi Analysis
  matrixWifiSsidLabel,
  matrixWifiPasswordLabel,
  matrixWifiEncryptionLabel,
  matrixWifiIsHiddenLabel,
  matrixWifiAnonymousIdentityLabel,
  matrixWifiIdentityLabel,
  matrixWifiEapMethodLabel,
  matrixWifiPhase2MethodLabel,
  // Matrix Barcode URL Analysis
  matrixUriUrlLabel,
  matrixUriMaliciousLabel,
  // Matrix Barcode URI UPI Analysis
  // Matrix Barcode URL Localisation Analysis
  matrixLocalisationLatitudeLabel,
  matrixLocalisationLongitudeLabel,
  matrixLocalisationAltitudeLabel,
  matrixLocalisationQueryLabel,
  matrixLocalisationButtonFindLocation,
  matrixLocalisationSearchCurrentPositionLabel,
  matrixLocalisationLocationDisabledLabel,
  // Barcode Description
  barcodeIndustrialDescriptionLabel,
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
  // Snackbar Feddbacks
  snackBarMessagePermissionRefused,
  snackBarMessageSaveBitmapOk,
  snackBarMessageSaveBitmapError,
  snackBarMessageShareBitmapError,
  // Actions
  actionsLabel,
  intentChooserShareTitle,
  intentChooserMailTitle,
  copyBarcodeLabel,
  copyLabel,
  barcodeCopiedLabel,
  barcodeSearchErrorLabel,
  barcodeSearchErrorNoCompatibleApplicationFound,
  searchLabel,
  actionTitleDialogLabel,
  actionGoToUrlLabel,
  actionWebSearchLabel,
  actionProductSearchLabel,
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
  apply,
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
  errorBarcodeQrEmailMissingMessage,
  errorBarcodeQrLocalisationMissingMessage,
  // Action Barcode Generated
  barcodeCreatorConfirmTextLabel,
  saveLabel,
  shareLabel,
  shareImageLabel,
  shareTextLabel,
  popupMessageConfirmationSaveImage,
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
  qrCodeTextRadioButtonLabelM,
  qrCodeTextRadioButtonLabelMrs,
  qrCodeTextRadioButtonLabelMiss,
  qrCodeTextRadioButtonLabelNone,
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
  qrCodeSpinnerPromptNone,
  spinnerTypeMobile,
  spinnerTypeFax,
  spinnerTypeHome,
  spinnerTypeWork,
  spinnerTypeOther,
  // EPC Creator
  qrCodeTextInputEditTextHintEpcServiceTag,
  qrCodeTextInputEditTextHintEpcVersion,
  qrCodeTextInputEditTextHintEpcCharacterSet,
  qrCodeTextInputEditTextHintEpcIdentification,
  qrCodeTextInputEditTextHintEpcBic,
  qrCodeTextInputEditTextHintEpcName,
  qrCodeTextInputEditTextHintEpcIban,
  qrCodeTextInputEditTextHintEpcAmount,
  qrCodeTextInputEditTextHintEpcPurpose,
  qrCodeTextInputEditTextHintEpcRemittanceRef,
  qrCodeTextInputEditTextHintEpcRemittanceText,
  qrCodeTextInputEditTextHintEpcInformation,
  qrCodeTextInputEditTextEpcNameError,
  qrCodeTextInputEditTextEpcIbanError,
  listBankEmptyMessage,
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
  customUrls,
  customSearchUrlsAddUrl,
  customSearchUrlsModifyUrl,
  customSearchUrlsList,
  customSearchUrlsListIsEmptyMessage,
  popupMessageConfirmationDeletedAllCustomUrls,
  customUrlDeleted,
  customUrlAdded,
  customUrlUpdated,
  customSearchUrlsAddInfo,
  examples,
  customSearchUrlsErrorUrl,
  errorEmptyFields,
  customSearchUrlsisDuplicated,
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
  preferencesSwitchScanUseFrontcameraLabel,
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
  preferencesSourceCodeLabel,
  // About Permissions
  // About BDD
  // About Library Third
  // Countries
}