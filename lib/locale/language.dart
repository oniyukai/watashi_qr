import 'package:flutter/material.dart';
import 'package:watashi_qr/locale/language_key.dart';

typedef K = LanguageKey;

abstract class Language {
  final Map<K, String?> _translations;
  final Language? _fallback;

  Language(this._translations, {Language? fallback}) : _fallback = fallback;

  static Language of(BuildContext context) => Localizations.of<Language>(context, Language)!;

  String _translate(K key) => _translations[key]
      ?? _fallback?._translate(key)
      ?? 'Warning: Translation key "${key.name}" not found.';

  // Permission Denied
  String get cameraPermissionDenied => _translate(K.cameraPermissionDenied);
  // AlertDialog
  String get closeDialogLabel => _translate(K.closeDialogLabel);
  String get yesLabel => _translate(K.yesLabel);
  String get noLabel => _translate(K.noLabel);
  String get goToDialogLabel => _translate(K.goToDialogLabel);
  String get error => _translate(K.error);
  // ImageView Description
  String get imageViewDescriptionFlag => _translate(K.imageViewDescriptionFlag);
  String get imageViewDescriptionLogo => _translate(K.imageViewDescriptionLogo);
  String get imageViewDescriptionTypeIcon => _translate(K.imageViewDescriptionTypeIcon);
  String get imageViewDescriptionBarCode => _translate(K.imageViewDescriptionBarCode);
  String get imageViewDescriptionIcon => _translate(K.imageViewDescriptionIcon);
  String get imageViewDescriptionProductFront => _translate(K.imageViewDescriptionProductFront);
  String get imageViewDescriptionNutriscore => _translate(K.imageViewDescriptionNutriscore);
  String get imageViewDescriptionNovaGroup => _translate(K.imageViewDescriptionNovaGroup);
  String get imageViewDescriptionEcoScore => _translate(K.imageViewDescriptionEcoScore);
  String get imageViewDescriptionBackground => _translate(K.imageViewDescriptionBackground);
  String get imageViewDescriptionImage => _translate(K.imageViewDescriptionImage);
  String get sliderDescriptionZoom => _translate(K.sliderDescriptionZoom);
  // Menu Item
  String get titleScan => _translate(K.titleScan);
  String get titleHistory => _translate(K.titleHistory);
  String get titleGenerate => _translate(K.titleGenerate);
  String get titleSettings => _translate(K.titleSettings);
  String get titleQrCodeCreator => _translate(K.titleQrCodeCreator);
  String get titleBarCodeCreator => _translate(K.titleBarCodeCreator);
  String get createQrFromClipboard => _translate(K.createQrFromClipboard);
  String get informationLabel => _translate(K.informationLabel);
  String get barcodeLabel => _translate(K.barcodeLabel);
  String get downloadFromApiLabel => _translate(K.downloadFromApiLabel);
  String get shareToThisAppLabel => _translate(K.shareToThisAppLabel);
  String get menuMore => _translate(K.menuMore);
  // Barcode Type
  String get barcodeQrCodeLabel => _translate(K.barcodeQrCodeLabel);
  String get barcodeDataMatrixLabel => _translate(K.barcodeDataMatrixLabel);
  String get barcodePdf417Label => _translate(K.barcodePdf417Label);
  String get barcodeAztecLabel => _translate(K.barcodeAztecLabel);
  String get barcodeEan13Label => _translate(K.barcodeEan13Label);
  String get barcodeEan8Label => _translate(K.barcodeEan8Label);
  String get barcodeUpcALabel => _translate(K.barcodeUpcALabel);
  String get barcodeUpcELabel => _translate(K.barcodeUpcELabel);
  String get barcodeCode128Label => _translate(K.barcodeCode128Label);
  String get barcodeCode93Label => _translate(K.barcodeCode93Label);
  String get barcodeCode39Label => _translate(K.barcodeCode39Label);
  String get barcodeCodabarLabel => _translate(K.barcodeCodabarLabel);
  String get barcodeItfLabel => _translate(K.barcodeItfLabel);
  // QR Type
  String get qrCodeTypeNameText => _translate(K.qrCodeTypeNameText);
  String get qrCodeTypeNameWebSite => _translate(K.qrCodeTypeNameWebSite);
  String get qrCodeTypeNameContact => _translate(K.qrCodeTypeNameContact);
  String get qrCodeTypeNameMail => _translate(K.qrCodeTypeNameMail);
  String get qrCodeTypeNameSms => _translate(K.qrCodeTypeNameSms);
  String get qrCodeTypeNamePhone => _translate(K.qrCodeTypeNamePhone);
  String get qrCodeTypeNameLocation => _translate(K.qrCodeTypeNameLocation);
  String get qrCodeTypeNameEvent => _translate(K.qrCodeTypeNameEvent);
  String get qrCodeTypeNameWifi => _translate(K.qrCodeTypeNameWifi);
  String get qrCodeTypeNameApps => _translate(K.qrCodeTypeNameApps);
  // Product Type
  String get barCodeTypeProduct => _translate(K.barCodeTypeProduct);
  String get barCodeTypeIndustrial => _translate(K.barCodeTypeIndustrial);
  String get barCodeTypeNameUnknown => _translate(K.barCodeTypeNameUnknown);
  // Error Correction Level
  String get qrCodeErrorCorrectionLevelLabel => _translate(K.qrCodeErrorCorrectionLevelLabel);
  String get qrCodeErrorCorrectionLevelSettingsLabel => _translate(K.qrCodeErrorCorrectionLevelSettingsLabel);
  String get qrCodeErrorCorrectionLevelNameLow => _translate(K.qrCodeErrorCorrectionLevelNameLow);
  String get qrCodeErrorCorrectionLevelNameMedium => _translate(K.qrCodeErrorCorrectionLevelNameMedium);
  String get qrCodeErrorCorrectionLevelNameQuartile => _translate(K.qrCodeErrorCorrectionLevelNameQuartile);
  String get qrCodeErrorCorrectionLevelNameHigh => _translate(K.qrCodeErrorCorrectionLevelNameHigh);
  // History
  String get labelHistoryEmpty => _translate(K.labelHistoryEmpty);
  String get snackBarMessageItemDeleted => _translate(K.snackBarMessageItemDeleted);
  String get snackBarMessageItemsDeleted => _translate(K.snackBarMessageItemsDeleted);
  String get popupMessageConfirmationDeleteHistory => _translate(K.popupMessageConfirmationDeleteHistory);
  String get popupMessageConfirmationDeleteSelectedItemsHistory => _translate(K.popupMessageConfirmationDeleteSelectedItemsHistory);
  String get menuItemHistoryDelete => _translate(K.menuItemHistoryDelete);
  String get menuItemHistoryDeleteFromHistory => _translate(K.menuItemHistoryDeleteFromHistory);
  String get menuItemHistoryRemovedFromHistory => _translate(K.menuItemHistoryRemovedFromHistory);
  String get menuItemHistoryAddInHistory => _translate(K.menuItemHistoryAddInHistory);
  String get menuItemHistoryAddedInHistory => _translate(K.menuItemHistoryAddedInHistory);
  String get menuItemHistoryAddFavorite => _translate(K.menuItemHistoryAddFavorite);
  String get menuItemHistoryRemoveFavorite => _translate(K.menuItemHistoryRemoveFavorite);
  String get deleteLabel => _translate(K.deleteLabel);
  String get cancelLabel => _translate(K.cancelLabel);
  String get recordLabel => _translate(K.recordLabel);
  // Export File
  String get exportLabel => _translate(K.exportLabel);
  String get exportJsonLabel => _translate(K.exportJsonLabel);
  String get importJsonLabel => _translate(K.importJsonLabel);
  String get shareJsonLabel => _translate(K.shareJsonLabel);
  String get snackBarMessageFileExportSuccess => _translate(K.snackBarMessageFileExportSuccess);
  String get snackBarMessageFileExportError => _translate(K.snackBarMessageFileExportError);
  String get snackBarMessageFileImportSuccess => _translate(K.snackBarMessageFileImportSuccess);
  String get snackBarMessageFileImportError => _translate(K.snackBarMessageFileImportError);
  // CaptureActivity
  // BarcodeAnalysisActivity
  String get barcodeInformationSearchLabel => _translate(K.barcodeInformationSearchLabel);
  String get scanErrorLabel => _translate(K.scanErrorLabel);
  String get scanErrorShortInformationLabel => _translate(K.scanErrorShortInformationLabel);
  String get barcodeScannedLabel => _translate(K.barcodeScannedLabel);
  String get barcodeFoundOnLabel => _translate(K.barcodeFoundOnLabel);
  String get barcodeNotFoundOnApiLabel => _translate(K.barcodeNotFoundOnApiLabel);
  String get noInternetPermission => _translate(K.noInternetPermission);
  String get aboutBarcodeInformationLabel => _translate(K.aboutBarcodeInformationLabel);
  String get aboutBarcodeLabel => _translate(K.aboutBarcodeLabel);
  String get aboutBarcodeFormatLabel => _translate(K.aboutBarcodeFormatLabel);
  String get aboutBarcodeContentLabel => _translate(K.aboutBarcodeContentLabel);
  String get aboutBarcodeOriginLabel => _translate(K.aboutBarcodeOriginLabel);
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
  String get barCodeContentLabel => _translate(K.barCodeContentLabel);
  String get barCodeAnalysisLabel => _translate(K.barCodeAnalysisLabel);
  // Matrix Barcode Contact Analysis
  String get matrixContactNameLabel => _translate(K.matrixContactNameLabel);
  String get matrixContactOrganisationLabel => _translate(K.matrixContactOrganisationLabel);
  String get matrixContactJobTitleLabel => _translate(K.matrixContactJobTitleLabel);
  String get matrixContactPhoneLabel => _translate(K.matrixContactPhoneLabel);
  String get matrixContactMailLabel => _translate(K.matrixContactMailLabel);
  String get matrixContactAddressLabel => _translate(K.matrixContactAddressLabel);
  String get matrixContactNotesLabel => _translate(K.matrixContactNotesLabel);
  // Matrix Barcode Agenda Analysis
  String get matrixAgendaNameEventLabel => _translate(K.matrixAgendaNameEventLabel);
  String get matrixAgendaStartDateEventLabel => _translate(K.matrixAgendaStartDateEventLabel);
  String get matrixAgendaEndDateEventLabel => _translate(K.matrixAgendaEndDateEventLabel);
  String get matrixAgendaPlaceEventLabel => _translate(K.matrixAgendaPlaceEventLabel);
  String get matrixAgendaDescriptionEventLabel => _translate(K.matrixAgendaDescriptionEventLabel);
  // Matrix Barcode Phone Analysis
  String get matrixPhoneTelNumberLabel => _translate(K.matrixPhoneTelNumberLabel);
  // Matrix Barcode Email Analysis
  String get matrixEmailRecipientLabel => _translate(K.matrixEmailRecipientLabel);
  String get matrixEmailCcLabel => _translate(K.matrixEmailCcLabel);
  String get matrixEmailBccLabel => _translate(K.matrixEmailBccLabel);
  String get matrixSubjectLabel => _translate(K.matrixSubjectLabel);
  String get matrixBodyLabel => _translate(K.matrixBodyLabel);
  // Matrix Barcode Wi-Fi Analysis
  String get matrixWifiSsidLabel => _translate(K.matrixWifiSsidLabel);
  String get matrixWifiPasswordLabel => _translate(K.matrixWifiPasswordLabel);
  String get matrixWifiEncryptionLabel => _translate(K.matrixWifiEncryptionLabel);
  String get matrixWifiIsHiddenLabel => _translate(K.matrixWifiIsHiddenLabel);
  String get matrixWifiAnonymousIdentityLabel => _translate(K.matrixWifiAnonymousIdentityLabel);
  String get matrixWifiIdentityLabel => _translate(K.matrixWifiIdentityLabel);
  String get matrixWifiEapMethodLabel => _translate(K.matrixWifiEapMethodLabel);
  String get matrixWifiPhase2MethodLabel => _translate(K.matrixWifiPhase2MethodLabel);
  // Matrix Barcode URL Analysis
  String get matrixUriUrlLabel => _translate(K.matrixUriUrlLabel);
  String get matrixUriMaliciousLabel => _translate(K.matrixUriMaliciousLabel);
  // Matrix Barcode URI UPI Analysis
  // Matrix Barcode URL Localisation Analysis
  String get matrixLocalisationLatitudeLabel => _translate(K.matrixLocalisationLatitudeLabel);
  String get matrixLocalisationLongitudeLabel => _translate(K.matrixLocalisationLongitudeLabel);
  String get matrixLocalisationAltitudeLabel => _translate(K.matrixLocalisationAltitudeLabel);
  String get matrixLocalisationQueryLabel => _translate(K.matrixLocalisationQueryLabel);
  String get matrixLocalisationButtonFindLocation => _translate(K.matrixLocalisationButtonFindLocation);
  String get matrixLocalisationSearchCurrentPositionLabel => _translate(K.matrixLocalisationSearchCurrentPositionLabel);
  String get matrixLocalisationLocationDisabledLabel => _translate(K.matrixLocalisationLocationDisabledLabel);
  // Barcode Description
  String get barcodeIndustrialDescriptionLabel => _translate(K.barcodeIndustrialDescriptionLabel);
  String get barcodeCode39DescriptionLabel => _translate(K.barcodeCode39DescriptionLabel);
  String get barcodeCode93DescriptionLabel => _translate(K.barcodeCode93DescriptionLabel);
  String get barcodeCode128DescriptionLabel => _translate(K.barcodeCode128DescriptionLabel);
  String get barcodeItfDescriptionLabel => _translate(K.barcodeItfDescriptionLabel);
  String get barcodeCodabarDescriptionLabel => _translate(K.barcodeCodabarDescriptionLabel);
  String get barcodeUpcADescriptionLabel => _translate(K.barcodeUpcADescriptionLabel);
  String get barcodeUpcEDescriptionLabel => _translate(K.barcodeUpcEDescriptionLabel);
  String get barcodeEan13DescriptionLabel => _translate(K.barcodeEan13DescriptionLabel);
  String get barcodeEan8DescriptionLabel => _translate(K.barcodeEan8DescriptionLabel);
  // Barcode Composition
  String get barcodeTextCompositionLabel => _translate(K.barcodeTextCompositionLabel);
  String get barcodeTextNoSpecialCompositionLabel => _translate(K.barcodeTextNoSpecialCompositionLabel);
  String get barcodeTextUpperNoSpecialCompositionLabel => _translate(K.barcodeTextUpperNoSpecialCompositionLabel);
  String get barcodeDigitsCompositionLabel => _translate(K.barcodeDigitsCompositionLabel);
  String get barcodeEvenDigitsCompositionLabel => _translate(K.barcodeEvenDigitsCompositionLabel);
  String get barcode7Digits1CheckCompositionLabel => _translate(K.barcode7Digits1CheckCompositionLabel);
  String get barcode11Digits1CheckCompositionLabel => _translate(K.barcode11Digits1CheckCompositionLabel);
  String get barcode12Digits1CheckCompositionLabel => _translate(K.barcode12Digits1CheckCompositionLabel);
  // Snackbar Feddbacks
  String get snackBarMessagePermissionRefused => _translate(K.snackBarMessagePermissionRefused);
  String get snackBarMessageSaveBitmapOk => _translate(K.snackBarMessageSaveBitmapOk);
  String get snackBarMessageSaveBitmapError => _translate(K.snackBarMessageSaveBitmapError);
  String get snackBarMessageShareBitmapError => _translate(K.snackBarMessageShareBitmapError);
  // Actions
  String get actionsLabel => _translate(K.actionsLabel);
  String get intentChooserShareTitle => _translate(K.intentChooserShareTitle);
  String get intentChooserMailTitle => _translate(K.intentChooserMailTitle);
  String get copyBarcodeLabel => _translate(K.copyBarcodeLabel);
  String get copyLabel => _translate(K.copyLabel);
  String get barcodeCopiedLabel => _translate(K.barcodeCopiedLabel);
  String get barcodeSearchErrorLabel => _translate(K.barcodeSearchErrorLabel);
  String get barcodeSearchErrorNoCompatibleApplicationFound => _translate(K.barcodeSearchErrorNoCompatibleApplicationFound);
  String get searchLabel => _translate(K.searchLabel);
  String get actionTitleDialogLabel => _translate(K.actionTitleDialogLabel);
  String get actionGoToUrlLabel => _translate(K.actionGoToUrlLabel);
  String get actionWebSearchLabel => _translate(K.actionWebSearchLabel);
  String get actionProductSearchLabel => _translate(K.actionProductSearchLabel);
  String get actionSendMailLabel => _translate(K.actionSendMailLabel);
  String get actionSendSmsLabel => _translate(K.actionSendSmsLabel);
  String get actionCallPhoneLabel => _translate(K.actionCallPhoneLabel);
  String get actionAddToCalendar => _translate(K.actionAddToCalendar);
  String get actionAddToContacts => _translate(K.actionAddToContacts);
  String get actionShareVcfFile => _translate(K.actionShareVcfFile);
  String get actionShowLocation => _translate(K.actionShowLocation);
  String get actionOpenLink => _translate(K.actionOpenLink);
  String get actionModifyBarcode => _translate(K.actionModifyBarcode);
  String get actionModifyNotes => _translate(K.actionModifyNotes);
  String get apply => _translate(K.apply);
  // Wi-Fi Connection
  // QR Code Generator
  // Barcode Generator Errors
  String get errorBarcodeNoneCharacterMessage => _translate(K.errorBarcodeNoneCharacterMessage);
  String get errorBarcodeNotANumberMessage => _translate(K.errorBarcodeNotANumberMessage);
  String get errorBarcodeWrongLengthMessage => _translate(K.errorBarcodeWrongLengthMessage);
  String get errorBarcodeWrongKeyMessage => _translate(K.errorBarcodeWrongKeyMessage);
  String get errorBarcodeEncodingIso88591ErrorMessage => _translate(K.errorBarcodeEncodingIso88591ErrorMessage);
  String get errorBarcodeEncodingUsAsciiErrorMessage => _translate(K.errorBarcodeEncodingUsAsciiErrorMessage);
  String get errorBarcode93RegexErrorMessage => _translate(K.errorBarcode93RegexErrorMessage);
  String get errorBarcode39RegexErrorMessage => _translate(K.errorBarcode39RegexErrorMessage);
  String get errorBarcodeCodabarRegexErrorMessage => _translate(K.errorBarcodeCodabarRegexErrorMessage);
  String get errorBarcodeItfErrorMessage => _translate(K.errorBarcodeItfErrorMessage);
  String get errorBarcodeUpcENotStartWith0ErrorMessage => _translate(K.errorBarcodeUpcENotStartWith0ErrorMessage);
  String get errorBarcodeQrUrlFormatMessage => _translate(K.errorBarcodeQrUrlFormatMessage);
  String get errorBarcodeQrPhoneNumberMissingMessage => _translate(K.errorBarcodeQrPhoneNumberMissingMessage);
  String get errorBarcodeQrEmailMissingMessage => _translate(K.errorBarcodeQrEmailMissingMessage);
  String get errorBarcodeQrLocalisationMissingMessage => _translate(K.errorBarcodeQrLocalisationMissingMessage);
  // Action Barcode Generated
  String get barcodeCreatorConfirmTextLabel => _translate(K.barcodeCreatorConfirmTextLabel);
  String get saveLabel => _translate(K.saveLabel);
  String get shareLabel => _translate(K.shareLabel);
  String get shareImageLabel => _translate(K.shareImageLabel);
  String get shareTextLabel => _translate(K.shareTextLabel);
  String get popupMessageConfirmationSaveImage => _translate(K.popupMessageConfirmationSaveImage);
  String get clipboardEmpty => _translate(K.clipboardEmpty);
  // Barcode Image Editor
  // Form
  String get qrCodeTextGeneratorHintTextInputEditText => _translate(K.qrCodeTextGeneratorHintTextInputEditText);
  String get qrCodeTextGeneratorHintPhoneInputEditText => _translate(K.qrCodeTextGeneratorHintPhoneInputEditText);
  String get qrCodeTextGeneratorHintUrlInputEditText => _translate(K.qrCodeTextGeneratorHintUrlInputEditText);
  String get qrCodeTextInputEditTextHintMessage => _translate(K.qrCodeTextInputEditTextHintMessage);
  // Contact Creator
  String get qrCodeTypeNameGenerateFromContact => _translate(K.qrCodeTypeNameGenerateFromContact);
  String get qrCodeImportContactFromVcard => _translate(K.qrCodeImportContactFromVcard);
  String get qrCodeTextRadioButtonLabelM => _translate(K.qrCodeTextRadioButtonLabelM);
  String get qrCodeTextRadioButtonLabelMrs => _translate(K.qrCodeTextRadioButtonLabelMrs);
  String get qrCodeTextRadioButtonLabelMiss => _translate(K.qrCodeTextRadioButtonLabelMiss);
  String get qrCodeTextRadioButtonLabelNone => _translate(K.qrCodeTextRadioButtonLabelNone);
  String get qrCodeTextInputEditTextHintName => _translate(K.qrCodeTextInputEditTextHintName);
  String get qrCodeTextInputEditTextHintFirstName => _translate(K.qrCodeTextInputEditTextHintFirstName);
  String get qrCodeTextInputEditTextHintWebSite => _translate(K.qrCodeTextInputEditTextHintWebSite);
  String get qrCodeTextInputEditTextHintMail1 => _translate(K.qrCodeTextInputEditTextHintMail1);
  String get qrCodeTextInputEditTextHintMail2 => _translate(K.qrCodeTextInputEditTextHintMail2);
  String get qrCodeTextInputEditTextHintMail3 => _translate(K.qrCodeTextInputEditTextHintMail3);
  String get qrCodeTextInputEditTextHintPhone1 => _translate(K.qrCodeTextInputEditTextHintPhone1);
  String get qrCodeTextInputEditTextHintPhone2 => _translate(K.qrCodeTextInputEditTextHintPhone2);
  String get qrCodeTextInputEditTextHintPhone3 => _translate(K.qrCodeTextInputEditTextHintPhone3);
  String get qrCodeTextInputEditTextHintStreetAddress => _translate(K.qrCodeTextInputEditTextHintStreetAddress);
  String get qrCodeTextInputEditTextHintPostalCode => _translate(K.qrCodeTextInputEditTextHintPostalCode);
  String get qrCodeTextInputEditTextHintCity => _translate(K.qrCodeTextInputEditTextHintCity);
  String get qrCodeTextInputEditTextHintCountry => _translate(K.qrCodeTextInputEditTextHintCountry);
  String get qrCodeTextInputEditTextHintRegion => _translate(K.qrCodeTextInputEditTextHintRegion);
  String get qrCodeTextInputEditTextHintNotes => _translate(K.qrCodeTextInputEditTextHintNotes);
  String get qrCodeSpinnerPromptNone => _translate(K.qrCodeSpinnerPromptNone);
  String get spinnerTypeMobile => _translate(K.spinnerTypeMobile);
  String get spinnerTypeFax => _translate(K.spinnerTypeFax);
  String get spinnerTypeHome => _translate(K.spinnerTypeHome);
  String get spinnerTypeWork => _translate(K.spinnerTypeWork);
  String get spinnerTypeOther => _translate(K.spinnerTypeOther);
  // EPC Creator
  String get qrCodeTextInputEditTextHintEpcServiceTag => _translate(K.qrCodeTextInputEditTextHintEpcServiceTag);
  String get qrCodeTextInputEditTextHintEpcVersion => _translate(K.qrCodeTextInputEditTextHintEpcVersion);
  String get qrCodeTextInputEditTextHintEpcCharacterSet => _translate(K.qrCodeTextInputEditTextHintEpcCharacterSet);
  String get qrCodeTextInputEditTextHintEpcIdentification => _translate(K.qrCodeTextInputEditTextHintEpcIdentification);
  String get qrCodeTextInputEditTextHintEpcBic => _translate(K.qrCodeTextInputEditTextHintEpcBic);
  String get qrCodeTextInputEditTextHintEpcName => _translate(K.qrCodeTextInputEditTextHintEpcName);
  String get qrCodeTextInputEditTextHintEpcIban => _translate(K.qrCodeTextInputEditTextHintEpcIban);
  String get qrCodeTextInputEditTextHintEpcAmount => _translate(K.qrCodeTextInputEditTextHintEpcAmount);
  String get qrCodeTextInputEditTextHintEpcPurpose => _translate(K.qrCodeTextInputEditTextHintEpcPurpose);
  String get qrCodeTextInputEditTextHintEpcRemittanceRef => _translate(K.qrCodeTextInputEditTextHintEpcRemittanceRef);
  String get qrCodeTextInputEditTextHintEpcRemittanceText => _translate(K.qrCodeTextInputEditTextHintEpcRemittanceText);
  String get qrCodeTextInputEditTextHintEpcInformation => _translate(K.qrCodeTextInputEditTextHintEpcInformation);
  String get qrCodeTextInputEditTextEpcNameError => _translate(K.qrCodeTextInputEditTextEpcNameError);
  String get qrCodeTextInputEditTextEpcIbanError => _translate(K.qrCodeTextInputEditTextEpcIbanError);
  String get listBankEmptyMessage => _translate(K.listBankEmptyMessage);
  // Mail Creator
  String get qrCodeTextInputEditTextHintEmail => _translate(K.qrCodeTextInputEditTextHintEmail);
  String get qrCodeTextInputEditTextHintEmailSubject => _translate(K.qrCodeTextInputEditTextHintEmailSubject);
  // Geo Localisation Creator
  String get qrCodeTextInputEditTextHintLocalisationLatitude => _translate(K.qrCodeTextInputEditTextHintLocalisationLatitude);
  String get qrCodeTextInputEditTextHintLocalisationLongitude => _translate(K.qrCodeTextInputEditTextHintLocalisationLongitude);
  String get qrCodeTextInputEditTextHintLocalisationHeight => _translate(K.qrCodeTextInputEditTextHintLocalisationHeight);
  String get qrCodeTextInputEditTextHintLocalisationRequest => _translate(K.qrCodeTextInputEditTextHintLocalisationRequest);
  // Wifi Creator
  String get qrCodeTextInputEditTextHintWifiSsid => _translate(K.qrCodeTextInputEditTextHintWifiSsid);
  String get qrCodeTextInputEditTextHintWifiPassword => _translate(K.qrCodeTextInputEditTextHintWifiPassword);
  String get qrCodeTextInputEditTextHintWifiHide => _translate(K.qrCodeTextInputEditTextHintWifiHide);
  String get spinnerWifiEncryptionWep => _translate(K.spinnerWifiEncryptionWep);
  String get spinnerWifiEncryptionWpa => _translate(K.spinnerWifiEncryptionWpa);
  String get spinnerWifiEncryptionSae => _translate(K.spinnerWifiEncryptionSae);
  String get spinnerWifiEncryptionNone => _translate(K.spinnerWifiEncryptionNone);
  // Event Creator
  String get qrCodeTextInputEditTextHintAgendaEventName => _translate(K.qrCodeTextInputEditTextHintAgendaEventName);
  String get qrCodeTextInputEditTextHintAgendaPlace => _translate(K.qrCodeTextInputEditTextHintAgendaPlace);
  String get qrCodeTextInputEditTextHintAgendaDescription => _translate(K.qrCodeTextInputEditTextHintAgendaDescription);
  String get checkBoxEventAllOfDay => _translate(K.checkBoxEventAllOfDay);
  String get beginLabel => _translate(K.beginLabel);
  String get endLabel => _translate(K.endLabel);
  // URL
  // Custom search URL
  String get customSearchUrls => _translate(K.customSearchUrls);
  String get customUrls => _translate(K.customUrls);
  String get customSearchUrlsAddUrl => _translate(K.customSearchUrlsAddUrl);
  String get customSearchUrlsModifyUrl => _translate(K.customSearchUrlsModifyUrl);
  String get customSearchUrlsList => _translate(K.customSearchUrlsList);
  String get customSearchUrlsListIsEmptyMessage => _translate(K.customSearchUrlsListIsEmptyMessage);
  String get popupMessageConfirmationDeletedAllCustomUrls => _translate(K.popupMessageConfirmationDeletedAllCustomUrls);
  String get customUrlDeleted => _translate(K.customUrlDeleted);
  String get customUrlAdded => _translate(K.customUrlAdded);
  String get customUrlUpdated => _translate(K.customUrlUpdated);
  String get customSearchUrlsAddInfo => _translate(K.customSearchUrlsAddInfo);
  String get examples => _translate(K.examples);
  String get customSearchUrlsErrorUrl => _translate(K.customSearchUrlsErrorUrl);
  String get errorEmptyFields => _translate(K.errorEmptyFields);
  String get customSearchUrlsisDuplicated => _translate(K.customSearchUrlsisDuplicated);
  // API Base URL
  // URL Engines
  // E-Commerce Engines
  // API Product Engines
  // API Sources Links
  // API Sources Description
  // Preferences
  String get preferencesDefault => _translate(K.preferencesDefault);
  // Appearance Settings
  String get preferencesAppearanceTitle => _translate(K.preferencesAppearanceTitle);
  String get preferencesThemeLabel => _translate(K.preferencesThemeLabel);
  String get preferencesSwitchSystemThemeLabel => _translate(K.preferencesSwitchSystemThemeLabel);
  String get preferencesSwitchLightThemeLabel => _translate(K.preferencesSwitchLightThemeLabel);
  String get preferencesSwitchDarkThemeLabel => _translate(K.preferencesSwitchDarkThemeLabel);
  String get preferencesColor => _translate(K.preferencesColor);
  String get preferencesColorMaterialYou => _translate(K.preferencesColorMaterialYou);
  String get preferencesColorBlue => _translate(K.preferencesColorBlue);
  String get preferencesColorOrange => _translate(K.preferencesColorOrange);
  String get preferencesColorGreen => _translate(K.preferencesColorGreen);
  String get preferencesColorRed => _translate(K.preferencesColorRed);
  String get preferencesColorPurple => _translate(K.preferencesColorPurple);
  // Languages Settings
  String get preferencesLanguagesTitle => _translate(K.preferencesLanguagesTitle);
  String get preferencesLanguagesChange => _translate(K.preferencesLanguagesChange);
  // Remote API
  // About Remote API
  // Scan Settings
  String get preferencesScanTitle => _translate(K.preferencesScanTitle);
  String get preferencesSwitchScanAutoOpenWebsiteLabel => _translate(K.preferencesSwitchScanAutoOpenWebsiteLabel);
  String get preferencesSwitchScanContinuousScanLabel => _translate(K.preferencesSwitchScanContinuousScanLabel);
  String get preferencesSwitchScanVibrateLabel => _translate(K.preferencesSwitchScanVibrateLabel);
  String get preferencesSwitchScanBipLabel => _translate(K.preferencesSwitchScanBipLabel);
  String get preferencesSwitchScanScreenRotationLabel => _translate(K.preferencesSwitchScanScreenRotationLabel);
  String get preferencesSwitchScanBarcodeCopiedLabel => _translate(K.preferencesSwitchScanBarcodeCopiedLabel);
  String get preferencesSwitchScanUseFrontcameraLabel => _translate(K.preferencesSwitchScanUseFrontcameraLabel);
  // Barcode Generation Settings
  String get preferencesBarcodeGenerationTitle => _translate(K.preferencesBarcodeGenerationTitle);
  // History settings-->
  String get preferencesSwitchScanAddBarcodeToTheHistoryLabel => _translate(K.preferencesSwitchScanAddBarcodeToTheHistoryLabel);
  String get preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel => _translate(K.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel);
  String get preferencesSwitchHistorySaveDuplicatesLabel => _translate(K.preferencesSwitchHistorySaveDuplicatesLabel);
  // Search Engine Settings
  String get preferencesSearchTitle => _translate(K.preferencesSearchTitle);
  String get preferencesSearchEngine => _translate(K.preferencesSearchEngine);
  // Settings: Additional options
  // Shortcuts
  // About Settings
  String get preferencesAboutTitle => _translate(K.preferencesAboutTitle);
  String get preferencesAboutOpenSourceLibrariesLabel => _translate(K.preferencesAboutOpenSourceLibrariesLabel);
  String get preferencesApplicationVersionLabel => _translate(K.preferencesApplicationVersionLabel);
  String get preferencesSourceCodeLabel => _translate(K.preferencesSourceCodeLabel);
  // About Permissions
  // About BDD
  // About Library Third
  // Countries


  // No translatable    Don't translate!
  static const String
      appName = 'Watashi QR',
      appVersion = '1.1.3',
      appVersionTag = 'v1.0_25.07.04',
      pngLabel = 'PNG',
      jpgLabel = 'JPG',
      svgLabel = 'SVG',
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
      separationObject = '<Separation.Object>',
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