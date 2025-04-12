import 'package:flutter/material.dart';

class Language {

  final Map<String, String> _translations;
  final Language? _fallbackLanguage;

  Language(this._translations, {Language? fallbackLanguage})
      : _fallbackLanguage = fallbackLanguage;

  static Language? of(BuildContext context) {
    return Localizations.of<Language>(context, Language);
  }

  String _translate(String key) {
    final String? translation = _translations[key];
    if (translation != null) {
      return translation;
    } else if (_fallbackLanguage != null) {
      return _fallbackLanguage._translate(key);
    } else {
      return 'Warning: Translation key "$key" not found.';
    }
  }

  // Permission Denied
  String get cameraPermissionDenied => _translate('cameraPermissionDenied');
  // AlertDialog
  String get closeDialogLabel => _translate('closeDialogLabel');
  String get yesLabel => _translate('yesLabel');
  String get noLabel => _translate('noLabel');
  String get goToDialogLabel => _translate('goToDialogLabel');
  String get error => _translate('error');
  // ImageView Description
  String get imageViewDescriptionFlag => _translate('imageViewDescriptionFlag');
  String get imageViewDescriptionLogo => _translate('imageViewDescriptionLogo');
  String get imageViewDescriptionTypeIcon => _translate('imageViewDescriptionTypeIcon');
  String get imageViewDescriptionBarCode => _translate('imageViewDescriptionBarCode');
  String get imageViewDescriptionIcon => _translate('imageViewDescriptionIcon');
  String get imageViewDescriptionProductFront => _translate('imageViewDescriptionProductFront');
  String get imageViewDescriptionNutriscore => _translate('imageViewDescriptionNutriscore');
  String get imageViewDescriptionNovaGroup => _translate('imageViewDescriptionNovaGroup');
  String get imageViewDescriptionEcoScore => _translate('imageViewDescriptionEcoScore');
  String get imageViewDescriptionBackground => _translate('imageViewDescriptionBackground');
  String get imageViewDescriptionImage => _translate('imageViewDescriptionImage');
  String get sliderDescriptionZoom => _translate('sliderDescriptionZoom');
  // Menu Item
  String get titleScan => _translate('titleScan');
  String get titleHistory => _translate('titleHistory');
  String get titleGenerate => _translate('titleGenerate');
  String get titleSettings => _translate('titleSettings');
  String get titleQrCodeCreator => _translate('titleQrCodeCreator');
  String get titleBarCodeCreator => _translate('titleBarCodeCreator');
  String get createQrFromClipboard => _translate('createQrFromClipboard');
  String get informationLabel => _translate('informationLabel');
  String get barcodeLabel => _translate('barcodeLabel');
  String get downloadFromApiLabel => _translate('downloadFromApiLabel');
  String get shareToThisAppLabel => _translate('shareToThisAppLabel');
  String get menuMore => _translate('menuMore');
  // Barcode Type
  String get barcodeQrCodeLabel => _translate('barcodeQrCodeLabel');
  String get barcodeDataMatrixLabel => _translate('barcodeDataMatrixLabel');
  String get barcodePdf417Label => _translate('barcodePdf417Label');
  String get barcodeAztecLabel => _translate('barcodeAztecLabel');
  String get barcodeEan13Label => _translate('barcodeEan13Label');
  String get barcodeEan8Label => _translate('barcodeEan8Label');
  String get barcodeUpcALabel => _translate('barcodeUpcALabel');
  String get barcodeUpcELabel => _translate('barcodeUpcELabel');
  String get barcodeCode128Label => _translate('barcodeCode128Label');
  String get barcodeCode93Label => _translate('barcodeCode93Label');
  String get barcodeCode39Label => _translate('barcodeCode39Label');
  String get barcodeCodabarLabel => _translate('barcodeCodabarLabel');
  String get barcodeItfLabel => _translate('barcodeItfLabel');
  // QR Type
  String get qrCodeTypeNameText => _translate('qrCodeTypeNameText');
  String get qrCodeTypeNameWebSite => _translate('qrCodeTypeNameWebSite');
  String get qrCodeTypeNameContact => _translate('qrCodeTypeNameContact');
  String get qrCodeTypeNameMail => _translate('qrCodeTypeNameMail');
  String get qrCodeTypeNameSms => _translate('qrCodeTypeNameSms');
  String get qrCodeTypeNamePhone => _translate('qrCodeTypeNamePhone');
  String get qrCodeTypeNameGeographicCoordinates => _translate('qrCodeTypeNameGeographicCoordinates');
  String get qrCodeTypeNameAgenda => _translate('qrCodeTypeNameAgenda');
  String get qrCodeTypeNameWifi => _translate('qrCodeTypeNameWifi');
  String get qrCodeTypeNameApps => _translate('qrCodeTypeNameApps');
  // Product Type
  String get barCodeTypeProduct => _translate('barCodeTypeProduct');
  String get barCodeTypeIndustrial => _translate('barCodeTypeIndustrial');
  String get barCodeTypeNameUnknown => _translate('barCodeTypeNameUnknown');
  // Error Correction Level
  String get qrCodeErrorCorrectionLevelLabel => _translate('qrCodeErrorCorrectionLevelLabel');
  String get qrCodeErrorCorrectionLevelSettingsLabel => _translate('qrCodeErrorCorrectionLevelSettingsLabel');
  String get qrCodeErrorCorrectionLevelNameLow => _translate('qrCodeErrorCorrectionLevelNameLow');
  String get qrCodeErrorCorrectionLevelNameMedium => _translate('qrCodeErrorCorrectionLevelNameMedium');
  String get qrCodeErrorCorrectionLevelNameQuartile => _translate('qrCodeErrorCorrectionLevelNameQuartile');
  String get qrCodeErrorCorrectionLevelNameHigh => _translate('qrCodeErrorCorrectionLevelNameHigh');
  // History
  String get labelHistoryEmpty => _translate('labelHistoryEmpty');
  String get snackBarMessageItemDeleted => _translate('snackBarMessageItemDeleted');
  String get snackBarMessageItemsDeleted => _translate('snackBarMessageItemsDeleted');
  String get popupMessageConfirmationDeleteHistory => _translate('popupMessageConfirmationDeleteHistory');
  String get popupMessageConfirmationDeleteSelectedItemsHistory => _translate('popupMessageConfirmationDeleteSelectedItemsHistory');
  String get menuItemHistoryDelete => _translate('menuItemHistoryDelete');
  String get menuItemHistoryDeleteFromHistory => _translate('menuItemHistoryDeleteFromHistory');
  String get menuItemHistoryRemovedFromHistory => _translate('menuItemHistoryRemovedFromHistory');
  String get menuItemHistoryAddInHistory => _translate('menuItemHistoryAddInHistory');
  String get menuItemHistoryAddedInHistory => _translate('menuItemHistoryAddedInHistory');
  String get menuItemHistoryAddFavorite => _translate('menuItemHistoryAddFavorite');
  String get menuItemHistoryRemoveFavorite => _translate('menuItemHistoryRemoveFavorite');
  String get deleteLabel => _translate('deleteLabel');
  String get cancelLabel => _translate('cancelLabel');
  String get recordLabel => _translate('recordLabel');
  // Export File
  String get exportLabel => _translate('exportLabel');
  String get exportJsonLabel => _translate('exportJsonLabel');
  String get importJsonLabel => _translate('importJsonLabel');
  String get snackBarMessageFileExportSuccess => _translate('snackBarMessageFileExportSuccess');
  String get snackBarMessageFileExportError => _translate('snackBarMessageFileExportError');
  String get snackBarMessageFileImportSuccess => _translate('snackBarMessageFileImportSuccess');
  String get snackBarMessageFileImportError => _translate('snackBarMessageFileImportError');
  // CaptureActivity
  // BarcodeAnalysisActivity
  String get barcodeInformationSearchLabel => _translate('barcodeInformationSearchLabel');
  String get scanErrorLabel => _translate('scanErrorLabel');
  String get scanErrorShortInformationLabel => _translate('scanErrorShortInformationLabel');
  String get barcodeScannedLabel => _translate('barcodeScannedLabel');
  String get barcodeFoundOnLabel => _translate('barcodeFoundOnLabel');
  String get barcodeNotFoundOnApiLabel => _translate('barcodeNotFoundOnApiLabel');
  String get noInternetPermission => _translate('noInternetPermission');
  String get aboutBarcodeInformationLabel => _translate('aboutBarcodeInformationLabel');
  String get aboutBarcodeLabel => _translate('aboutBarcodeLabel');
  String get aboutBarcodeFormatLabel => _translate('aboutBarcodeFormatLabel');
  String get aboutBarcodeContentLabel => _translate('aboutBarcodeContentLabel');
  String get aboutBarcodeOriginLabel => _translate('aboutBarcodeOriginLabel');
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
  String get barCodeContentLabel => _translate('barCodeContentLabel');
  String get barCodeAnalysisLabel => _translate('barCodeAnalysisLabel');
  // Matrix Barcode Contact Analysis
  String get matrixContactNameLabel => _translate('matrixContactNameLabel');
  String get matrixContactOrganisationLabel => _translate('matrixContactOrganisationLabel');
  String get matrixContactJobTitleLabel => _translate('matrixContactJobTitleLabel');
  String get matrixContactPhoneLabel => _translate('matrixContactPhoneLabel');
  String get matrixContactMailLabel => _translate('matrixContactMailLabel');
  String get matrixContactAddressLabel => _translate('matrixContactAddressLabel');
  String get matrixContactNotesLabel => _translate('matrixContactNotesLabel');
  // Matrix Barcode Agenda Analysis
  String get matrixAgendaNameEventLabel => _translate('matrixAgendaNameEventLabel');
  String get matrixAgendaStartDateEventLabel => _translate('matrixAgendaStartDateEventLabel');
  String get matrixAgendaEndDateEventLabel => _translate('matrixAgendaEndDateEventLabel');
  String get matrixAgendaPlaceEventLabel => _translate('matrixAgendaPlaceEventLabel');
  String get matrixAgendaDescriptionEventLabel => _translate('matrixAgendaDescriptionEventLabel');
  // Matrix Barcode Phone Analysis
  String get matrixPhoneTelNumberLabel => _translate('matrixPhoneTelNumberLabel');
  // Matrix Barcode Email Analysis
  String get matrixEmailRecipientLabel => _translate('matrixEmailRecipientLabel');
  String get matrixEmailCcLabel => _translate('matrixEmailCcLabel');
  String get matrixEmailBccLabel => _translate('matrixEmailBccLabel');
  String get matrixSubjectLabel => _translate('matrixSubjectLabel');
  String get matrixBodyLabel => _translate('matrixBodyLabel');
  // Matrix Barcode Wi-Fi Analysis
  String get matrixWifiSsidLabel => _translate('matrixWifiSsidLabel');
  String get matrixWifiPasswordLabel => _translate('matrixWifiPasswordLabel');
  String get matrixWifiEncryptionLabel => _translate('matrixWifiEncryptionLabel');
  String get matrixWifiIsHiddenLabel => _translate('matrixWifiIsHiddenLabel');
  String get matrixWifiAnonymousIdentityLabel => _translate('matrixWifiAnonymousIdentityLabel');
  String get matrixWifiIdentityLabel => _translate('matrixWifiIdentityLabel');
  String get matrixWifiEapMethodLabel => _translate('matrixWifiEapMethodLabel');
  String get matrixWifiPhase2MethodLabel => _translate('matrixWifiPhase2MethodLabel');
  // Matrix Barcode URL Analysis
  String get matrixUriUrlLabel => _translate('matrixUriUrlLabel');
  String get matrixUriMaliciousLabel => _translate('matrixUriMaliciousLabel');
  // Matrix Barcode URI UPI Analysis
  // Matrix Barcode URL Localisation Analysis
  String get matrixLocalisationLatitudeLabel => _translate('matrixLocalisationLatitudeLabel');
  String get matrixLocalisationLongitudeLabel => _translate('matrixLocalisationLongitudeLabel');
  String get matrixLocalisationAltitudeLabel => _translate('matrixLocalisationAltitudeLabel');
  String get matrixLocalisationQueryLabel => _translate('matrixLocalisationQueryLabel');
  String get matrixLocalisationButtonFindLocation => _translate('matrixLocalisationButtonFindLocation');
  String get matrixLocalisationSearchCurrentPositionLabel => _translate('matrixLocalisationSearchCurrentPositionLabel');
  String get matrixLocalisationLocationDisabledLabel => _translate('matrixLocalisationLocationDisabledLabel');
  // Barcode Description
  String get barcodeIndustrialDescriptionLabel => _translate('barcodeIndustrialDescriptionLabel');
  String get barcodeCode39DescriptionLabel => _translate('barcodeCode39DescriptionLabel');
  String get barcodeCode93DescriptionLabel => _translate('barcodeCode93DescriptionLabel');
  String get barcodeCode128DescriptionLabel => _translate('barcodeCode128DescriptionLabel');
  String get barcodeItfDescriptionLabel => _translate('barcodeItfDescriptionLabel');
  String get barcodeCodabarDescriptionLabel => _translate('barcodeCodabarDescriptionLabel');
  String get barcodeUpcADescriptionLabel => _translate('barcodeUpcADescriptionLabel');
  String get barcodeUpcEDescriptionLabel => _translate('barcodeUpcEDescriptionLabel');
  String get barcodeEan13DescriptionLabel => _translate('barcodeEan13DescriptionLabel');
  String get barcodeEan8DescriptionLabel => _translate('barcodeEan8DescriptionLabel');
  // Barcode Composition
  String get barcodeTextCompositionLabel => _translate('barcodeTextCompositionLabel');
  String get barcodeTextNoSpecialCompositionLabel => _translate('barcodeTextNoSpecialCompositionLabel');
  String get barcodeTextUpperNoSpecialCompositionLabel => _translate('barcodeTextUpperNoSpecialCompositionLabel');
  String get barcodeDigitsCompositionLabel => _translate('barcodeDigitsCompositionLabel');
  String get barcodeEvenDigitsCompositionLabel => _translate('barcodeEvenDigitsCompositionLabel');
  String get barcode7Digits1CheckCompositionLabel => _translate('barcode7Digits1CheckCompositionLabel');
  String get barcode11Digits1CheckCompositionLabel => _translate('barcode11Digits1CheckCompositionLabel');
  String get barcode12Digits1CheckCompositionLabel => _translate('barcode12Digits1CheckCompositionLabel');
  // Snackbar Feddbacks
  String get snackBarMessagePermissionRefused => _translate('snackBarMessagePermissionRefused');
  String get snackBarMessageSaveBitmapOk => _translate('snackBarMessageSaveBitmapOk');
  String get snackBarMessageSaveBitmapError => _translate('snackBarMessageSaveBitmapError');
  String get snackBarMessageShareBitmapError => _translate('snackBarMessageShareBitmapError');
  // Actions
  String get actionsLabel => _translate('actionsLabel');
  String get intentChooserShareTitle => _translate('intentChooserShareTitle');
  String get intentChooserMailTitle => _translate('intentChooserMailTitle');
  String get copyBarcodeLabel => _translate('copyBarcodeLabel');
  String get copyLabel => _translate('copyLabel');
  String get barcodeCopiedLabel => _translate('barcodeCopiedLabel');
  String get barcodeSearchErrorLabel => _translate('barcodeSearchErrorLabel');
  String get barcodeSearchErrorNoCompatibleApplicationFound => _translate('barcodeSearchErrorNoCompatibleApplicationFound');
  String get searchLabel => _translate('searchLabel');
  String get actionTitleDialogLabel => _translate('actionTitleDialogLabel');
  String get actionGoToUrlLabel => _translate('actionGoToUrlLabel');
  String get actionWebSearchLabel => _translate('actionWebSearchLabel');
  String get actionProductSearchLabel => _translate('actionProductSearchLabel');
  String get actionSendMailLabel => _translate('actionSendMailLabel');
  String get actionSendSmsLabel => _translate('actionSendSmsLabel');
  String get actionCallPhoneLabel => _translate('actionCallPhoneLabel');
  String get actionAddToCalendar => _translate('actionAddToCalendar');
  String get actionAddToContacts => _translate('actionAddToContacts');
  String get actionShareVcfFile => _translate('actionShareVcfFile');
  String get actionShowLocation => _translate('actionShowLocation');
  String get actionOpenLink => _translate('actionOpenLink');
  String get actionModifyBarcode => _translate('actionModifyBarcode');
  String get actionModifyNotes => _translate('actionModifyNotes');
  String get apply => _translate('apply');
  // Wi-Fi Connection

  // QR Code Generator
  // Barcode Generator Errors
  String get errorBarcodeNoneCharacterMessage => _translate('errorBarcodeNoneCharacterMessage');
  String get errorBarcodeNotANumberMessage => _translate('errorBarcodeNotANumberMessage');
  String get errorBarcodeWrongLengthMessage => _translate('errorBarcodeWrongLengthMessage');
  String get errorBarcodeWrongKeyMessage => _translate('errorBarcodeWrongKeyMessage');
  String get errorBarcodeEncodingIso88591ErrorMessage => _translate('errorBarcodeEncodingIso88591ErrorMessage');
  String get errorBarcodeEncodingUsAsciiErrorMessage => _translate('errorBarcodeEncodingUsAsciiErrorMessage');
  String get errorBarcode93RegexErrorMessage => _translate('errorBarcode93RegexErrorMessage');
  String get errorBarcode39RegexErrorMessage => _translate('errorBarcode39RegexErrorMessage');
  String get errorBarcodeCodabarRegexErrorMessage => _translate('errorBarcodeCodabarRegexErrorMessage');
  String get errorBarcodeItfErrorMessage => _translate('errorBarcodeItfErrorMessage');
  String get errorBarcodeUpcENotStartWith0ErrorMessage => _translate('errorBarcodeUpcENotStartWith0ErrorMessage');
  String get errorBarcodeQrUrlFormatMessage => _translate('errorBarcodeQrUrlFormatMessage');
  String get errorBarcodeQrPhoneNumberMissingMessage => _translate('errorBarcodeQrPhoneNumberMissingMessage');
  String get errorBarcodeQrEmailMissingMessage => _translate('errorBarcodeQrEmailMissingMessage');
  String get errorBarcodeQrLocalisationMissingMessage => _translate('errorBarcodeQrLocalisationMissingMessage');
  // Action Barcode Generated
  String get barcodeCreatorConfirmTextLabel => _translate('barcodeCreatorConfirmTextLabel');
  String get saveLabel => _translate('saveLabel');
  String get shareLabel => _translate('shareLabel');
  String get shareImageLabel => _translate('shareImageLabel');
  String get shareTextLabel => _translate('shareTextLabel');
  String get popupMessageConfirmationSaveImage => _translate('popupMessageConfirmationSaveImage');
  String get clipboardEmpty => _translate('clipboardEmpty');
  // Barcode Image Editor
  // Form
  String get qrCodeTextGeneratorHintTextInputEditText => _translate('qrCodeTextGeneratorHintTextInputEditText');
  String get qrCodeTextGeneratorHintPhoneInputEditText => _translate('qrCodeTextGeneratorHintPhoneInputEditText');
  String get qrCodeTextGeneratorHintUrlInputEditText => _translate('qrCodeTextGeneratorHintUrlInputEditText');
  String get qrCodeTextInputEditTextHintMessage => _translate('qrCodeTextInputEditTextHintMessage');
  // Contact Creator
  String get qrCodeTypeNameGenerateFromContact => _translate('qrCodeTypeNameGenerateFromContact');
  String get qrCodeImportContactFromVcard =>  _translate('qrCodeImportContactFromVcard');
  String get qrCodeTextRadioButtonLabelM => _translate('qrCodeTextRadioButtonLabelM');
  String get qrCodeTextRadioButtonLabelMrs => _translate('qrCodeTextRadioButtonLabelMrs');
  String get qrCodeTextRadioButtonLabelMiss => _translate('qrCodeTextRadioButtonLabelMiss');
  String get qrCodeTextRadioButtonLabelNone => _translate('qrCodeTextRadioButtonLabelNone');
  String get qrCodeTextInputEditTextHintName => _translate('qrCodeTextInputEditTextHintName');
  String get qrCodeTextInputEditTextHintFirstName => _translate('qrCodeTextInputEditTextHintFirstName');
  String get qrCodeTextInputEditTextHintWebSite => _translate('qrCodeTextInputEditTextHintWebSite');
  String get qrCodeTextInputEditTextHintMail1 => _translate('qrCodeTextInputEditTextHintMail1');
  String get qrCodeTextInputEditTextHintMail2 => _translate('qrCodeTextInputEditTextHintMail2');
  String get qrCodeTextInputEditTextHintMail3 => _translate('qrCodeTextInputEditTextHintMail3');
  String get qrCodeTextInputEditTextHintPhone1 => _translate('qrCodeTextInputEditTextHintPhone1');
  String get qrCodeTextInputEditTextHintPhone2 => _translate('qrCodeTextInputEditTextHintPhone2');
  String get qrCodeTextInputEditTextHintPhone3 => _translate('qrCodeTextInputEditTextHintPhone3');
  String get qrCodeTextInputEditTextHintStreetAddress => _translate('qrCodeTextInputEditTextHintStreetAddress');
  String get qrCodeTextInputEditTextHintPostalCode => _translate('qrCodeTextInputEditTextHintPostalCode');
  String get qrCodeTextInputEditTextHintCity => _translate('qrCodeTextInputEditTextHintCity');
  String get qrCodeTextInputEditTextHintCountry => _translate('qrCodeTextInputEditTextHintCountry');
  String get qrCodeTextInputEditTextHintRegion => _translate('qrCodeTextInputEditTextHintRegion');
  String get qrCodeTextInputEditTextHintNotes => _translate('qrCodeTextInputEditTextHintNotes');
  String get qrCodeSpinnerPromptNone => _translate('qrCodeSpinnerPromptNone');
  String get spinnerTypeMobile => _translate('spinnerTypeMobile');
  String get spinnerTypeFax => _translate('spinnerTypeFax');
  String get spinnerTypeHome => _translate('spinnerTypeHome');
  String get spinnerTypeWork => _translate('spinnerTypeWork');
  String get spinnerTypeOther => _translate('spinnerTypeOther');
  // EPC Creator
  String get qrCodeTextInputEditTextHintEpcServiceTag => _translate('qrCodeTextInputEditTextHintEpcServiceTag');
  String get qrCodeTextInputEditTextHintEpcVersion => _translate('qrCodeTextInputEditTextHintEpcVersion');
  String get qrCodeTextInputEditTextHintEpcCharacterSet => _translate('qrCodeTextInputEditTextHintEpcCharacterSet');
  String get qrCodeTextInputEditTextHintEpcIdentification => _translate('qrCodeTextInputEditTextHintEpcIdentification');
  String get qrCodeTextInputEditTextHintEpcBic => _translate('qrCodeTextInputEditTextHintEpcBic');
  String get qrCodeTextInputEditTextHintEpcName => _translate('qrCodeTextInputEditTextHintEpcName');
  String get qrCodeTextInputEditTextHintEpcIban => _translate('qrCodeTextInputEditTextHintEpcIban');
  String get qrCodeTextInputEditTextHintEpcAmount => _translate('qrCodeTextInputEditTextHintEpcAmount');
  String get qrCodeTextInputEditTextHintEpcPurpose => _translate('qrCodeTextInputEditTextHintEpcPurpose');
  String get qrCodeTextInputEditTextHintEpcRemittanceRef => _translate('qrCodeTextInputEditTextHintEpcRemittanceRef');
  String get qrCodeTextInputEditTextHintEpcRemittanceText => _translate('qrCodeTextInputEditTextHintEpcRemittanceText');
  String get qrCodeTextInputEditTextHintEpcInformation => _translate('qrCodeTextInputEditTextHintEpcInformation');
  String get qrCodeTextInputEditTextEpcNameError => _translate('qrCodeTextInputEditTextEpcNameError');
  String get qrCodeTextInputEditTextEpcIbanError => _translate('qrCodeTextInputEditTextEpcIbanError');
  String get listBankEmptyMessage => _translate('listBankEmptyMessage');
  // Mail Creator
  String get qrCodeTextInputEditTextHintEmail => _translate('qrCodeTextInputEditTextHintEmail');
  String get qrCodeTextInputEditTextHintEmailSubject => _translate('qrCodeTextInputEditTextHintEmailSubject');
  // Geo Localisation Creator
  String get qrCodeTextInputEditTextHintLocalisationLatitude => _translate('qrCodeTextInputEditTextHintLocalisationLatitude');
  String get qrCodeTextInputEditTextHintLocalisationLongitude => _translate('qrCodeTextInputEditTextHintLocalisationLongitude');
  String get qrCodeTextInputEditTextHintLocalisationHeight => _translate('qrCodeTextInputEditTextHintLocalisationHeight');
  String get qrCodeTextInputEditTextHintLocalisationRequest => _translate('qrCodeTextInputEditTextHintLocalisationRequest');
  // Wifi Creator
  String get qrCodeTextInputEditTextHintWifiSsid => _translate('qrCodeTextInputEditTextHintWifiSsid');
  String get qrCodeTextInputEditTextHintWifiPassword => _translate('qrCodeTextInputEditTextHintWifiPassword');
  String get qrCodeTextInputEditTextHintWifiHide => _translate('qrCodeTextInputEditTextHintWifiHide');
  String get spinnerWifiEncryptionWep => _translate('spinnerWifiEncryptionWep');
  String get spinnerWifiEncryptionWpa => _translate('spinnerWifiEncryptionWpa');
  String get spinnerWifiEncryptionSae => _translate('spinnerWifiEncryptionSae');
  String get spinnerWifiEncryptionNone => _translate('spinnerWifiEncryptionNone');
  // Event Creator
  String get qrCodeTextInputEditTextHintAgendaEventName => _translate('qrCodeTextInputEditTextHintAgendaEventName');
  String get qrCodeTextInputEditTextHintAgendaPlace => _translate('qrCodeTextInputEditTextHintAgendaPlace');
  String get qrCodeTextInputEditTextHintAgendaDescription => _translate('qrCodeTextInputEditTextHintAgendaDescription');
  String get checkBoxEventAllOfDay => _translate('checkBoxEventAllOfDay');
  String get beginLabel => _translate('beginLabel');
  String get endLabel => _translate('endLabel');

  // URL
  // Custom search URL
  String get customSearchUrls => _translate('customSearchUrls');
  String get customUrls => _translate('customUrls');
  String get customSearchUrlsAddUrl => _translate('customSearchUrlsAddUrl');
  String get customSearchUrlsModifyUrl => _translate('customSearchUrlsModifyUrl');
  String get customSearchUrlsList => _translate('customSearchUrlsList');
  String get customSearchUrlsListIsEmptyMessage => _translate('customSearchUrlsListIsEmptyMessage');
  String get popupMessageConfirmationDeletedAllCustomUrls => _translate('popupMessageConfirmationDeletedAllCustomUrls');
  String get customUrlDeleted => _translate('customUrlDeleted');
  String get customUrlAdded => _translate('customUrlAdded');
  String get customUrlUpdated => _translate('customUrlUpdated');
  String get customSearchUrlsAddInfo => _translate('customSearchUrlsAddInfo');
  String get examples => _translate('examples');
  String get customSearchUrlsErrorUrl => _translate('customSearchUrlsErrorUrl');
  String get errorEmptyFields => _translate('errorEmptyFields');
  String get customSearchUrlsisDuplicated => _translate('customSearchUrlsisDuplicated');
  // API Base URL
  // URL Engines
  // E-Commerce Engines
  // API Product Engines
  // API Sources Links
  // API Sources Description
  // Preferences
  String get preferencesDefault => _translate('preferencesDefault');
  // Appearance Settings
  String get preferencesAppearanceTitle => _translate('preferencesAppearanceTitle');
  String get preferencesThemeLabel => _translate('preferencesThemeLabel');
  String get preferencesSwitchSystemThemeLabel => _translate('preferencesSwitchSystemThemeLabel');
  String get preferencesSwitchLightThemeLabel => _translate('preferencesSwitchLightThemeLabel');
  String get preferencesSwitchDarkThemeLabel => _translate('preferencesSwitchDarkThemeLabel');
  String get preferencesColor => _translate('preferencesColor');
  String get preferencesColorMaterialYou => _translate('preferencesColorMaterialYou');
  String get preferencesColorBlue => _translate('preferencesColorBlue');
  String get preferencesColorOrange => _translate('preferencesColorOrange');
  String get preferencesColorGreen => _translate('preferencesColorGreen');
  String get preferencesColorRed => _translate('preferencesColorRed');
  String get preferencesColorPurple => _translate('preferencesColorPurple');
  // Languages Settings
  String get preferencesLanguagesTitle => _translate('preferencesLanguagesTitle');
  String get preferencesLanguagesChange => _translate('preferencesLanguagesChange');
  // Remote API
  // About Remote API
  // Scan Settings
  String get preferencesScanTitle => _translate('preferencesScanTitle');
  String get preferencesSwitchScanAutoOpenWebsiteLabel => _translate('preferencesSwitchScanAutoOpenWebsiteLabel');
  String get preferencesSwitchScanContinuousScanLabel => _translate('preferencesSwitchScanContinuousScanLabel');
  String get preferencesSwitchScanVibrateLabel => _translate('preferencesSwitchScanVibrateLabel');
  String get preferencesSwitchScanBipLabel => _translate('preferencesSwitchScanBipLabel');
  String get preferencesSwitchScanScreenRotationLabel => _translate('preferencesSwitchScanScreenRotationLabel');
  String get preferencesSwitchScanBarcodeCopiedLabel => _translate('preferencesSwitchScanBarcodeCopiedLabel');
  String get preferencesSwitchScanUseFrontcameraLabel => _translate('preferencesSwitchScanUseFrontcameraLabel');
  // Barcode Generation Settings
  String get preferencesBarcodeGenerationTitle => _translate('preferencesBarcodeGenerationTitle');
  // History settings-->
  String get preferencesSwitchScanAddBarcodeToTheHistoryLabel => _translate('preferencesSwitchScanAddBarcodeToTheHistoryLabel');
  String get preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel => _translate('preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel');
  String get preferencesSwitchHistorySaveDuplicatesLabel => _translate('preferencesSwitchHistorySaveDuplicatesLabel');
  // Search Engine Settings
  String get preferencesSearchTitle => _translate('preferencesSearchTitle');
  String get preferencesSearchEngine => _translate('preferencesSearchEngine');
  // Settings: Additional options
  // Shortcuts
  // About Settings
  String get preferencesAboutTitle => _translate('preferencesAboutTitle');
  String get preferencesAboutOpenSourceLibrariesLabel => _translate('preferencesAboutOpenSourceLibrariesLabel');
  String get preferencesApplicationVersionLabel => _translate('preferencesApplicationVersionLabel');
  String get preferencesSourceCodeLabel => _translate('preferencesSourceCodeLabel');
  // About Permissions
  // About BDD
  // About Library Third
  // Countries


  // No translatable    Don't translate!
  static const String appName = 'Watashi QR';
  static const String appVersion = '1.0.0';
  static const String appVersionCode = '1.0.pre_25.04.08';
  static const String pngLabel = 'PNG';
  static const String jpgLabel = 'JPG';
  static const String svgLabel = 'SVG';
  // Animations
  // Default font
  // External Services Label
  static const String googleLabel = 'Google';
  static const String bingLabel = 'Bing';
  static const String wikipediaLabel = 'Wikipedia';
  // Preferences Settings Keys
  // Preferences Entry Values
  // About Library Third
  static const String gnuGeneralPublicLicenseV3 = 'GNU General Public License v3.0';
  static const String gnuGeneralPublicLicenseV3Url = 'https://www.gnu.org/licenses/gpl-3.0.html';
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
  static const String sourceCodeLink = 'https://github.com/oniyukai/watashi_qr';
  // Local Language text
  static const String localeLanguageEn = 'English';
  static const String localeLanguageJa = '日本語';
  static const String localeLanguageZh = '简体中文';
  static const String localeLanguageZhTw = '繁體中文';
}