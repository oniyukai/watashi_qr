import 'package:watashi_qr/locale/language_key.dart';
import 'language.dart';

typedef K = LanguageKey;

class LanguageEn extends Language {
  LanguageEn() : super(
    fallback: null, const { // 英文沒有替代語言
    // Permission Denied
    K.cameraPermissionDenied: 'Waiting for Authorized Access to the Camera.',
    // AlertDialog
    K.closeDialogLabel: 'Close',
    K.yesLabel: 'Yes',
    K.noLabel: 'No',
    K.goToDialogLabel: 'Enter website',
    K.error: 'Error',
    // ImageView Description
    K.imageViewDescriptionFlag: 'Flag',
    K.imageViewDescriptionLogo: 'Logo',
    K.imageViewDescriptionTypeIcon: 'Type',
    K.imageViewDescriptionBarCode: 'Barcode',
    K.imageViewDescriptionIcon: 'Icon',
    K.imageViewDescriptionProductFront: 'Product picture',
    K.imageViewDescriptionNutriscore: 'NUTRI-SCORE',
    K.imageViewDescriptionNovaGroup: 'NOVA GROUP',
    K.imageViewDescriptionEcoScore: 'ECO SCORE',
    K.imageViewDescriptionBackground: 'Background',
    K.imageViewDescriptionImage: 'Image',
    K.sliderDescriptionZoom: 'Zoom',
    // Menu Item
    K.titleScan: 'Scan',
    K.titleHistory: 'History',
    K.titleGenerate: 'Generate',
    K.titleSettings: 'Settings',
    K.titleQrCodeCreator: 'Generate a QR Code',
    K.titleBarCodeCreator: 'Generate a barcode',
    K.createQrFromClipboard: 'Generate from the clipboard',
    K.informationLabel: 'Information',
    K.barcodeLabel: 'Barcode',
    K.downloadFromApiLabel: 'Download from APIs',
    K.shareToThisAppLabel: 'Can also share to this program from other applications.',
    K.menuMore: 'More',
    // Barcode Type
    K.barcodeQrCodeLabel: 'QR Code',
    K.barcodeDataMatrixLabel: 'Data Matrix',
    K.barcodePdf417Label: 'PDF 417',
    K.barcodeAztecLabel: 'AZTEC',
    K.barcodeEan13Label: 'EAN 13',
    K.barcodeEan8Label: 'EAN 8',
    K.barcodeUpcALabel: 'UPC A',
    K.barcodeUpcELabel: 'UPC E',
    K.barcodeCode128Label: 'Code 128',
    K.barcodeCode93Label: 'Code 93',
    K.barcodeCode39Label: 'Code 39',
    K.barcodeCodabarLabel: 'Codabar',
    K.barcodeItfLabel: 'ITF',
    // QR Type
    K.qrCodeTypeNameText: 'Text',
    K.qrCodeTypeNameWebSite: 'Website',
    K.qrCodeTypeNameContact: 'Contact',
    K.qrCodeTypeNameMail: 'Mail',
    K.qrCodeTypeNameSms: 'SMS',
    K.qrCodeTypeNamePhone: 'Phone number',
    K.qrCodeTypeNameGeographicCoordinates: 'Geographic coordinates',
    K.qrCodeTypeNameAgenda: 'Agenda',
    K.qrCodeTypeNameWifi: 'Wi-Fi',
    K.qrCodeTypeNameApps: 'Application',
    // Product Type
    K.barCodeTypeProduct: 'Product',
    K.barCodeTypeIndustrial: 'Industrial Code',
    K.barCodeTypeNameUnknown: 'Unknown',
    // Error Correction Level
    K.qrCodeErrorCorrectionLevelLabel: 'Error correction level',
    K.qrCodeErrorCorrectionLevelSettingsLabel: 'Error correction level (QR Code)',
    K.qrCodeErrorCorrectionLevelNameLow: 'Low (~7%)',
    K.qrCodeErrorCorrectionLevelNameMedium: 'Medium (~15%)',
    K.qrCodeErrorCorrectionLevelNameQuartile: 'Quartile (~25%)',
    K.qrCodeErrorCorrectionLevelNameHigh: 'High (~30%)',
    // History
    K.labelHistoryEmpty: 'No elements scanned…',
    K.snackBarMessageItemDeleted: 'The product has been deleted from history.',
    K.snackBarMessageItemsDeleted: 'Items deleted from history.',
    K.popupMessageConfirmationDeleteHistory: 'Delete all history?',
    K.popupMessageConfirmationDeleteSelectedItemsHistory: 'Delete selected items?',
    K.menuItemHistoryDelete: 'Delete history',
    K.menuItemHistoryDeleteFromHistory: 'Delete from history',
    K.menuItemHistoryRemovedFromHistory: 'Removed from history!',
    K.menuItemHistoryAddInHistory: 'Add in the history',
    K.menuItemHistoryAddedInHistory: 'Added in the history!',
    K.menuItemHistoryAddFavorite: 'Add to Favorites',
    K.menuItemHistoryRemoveFavorite: 'Delete from Favorites',
    K.deleteLabel: 'Delete',
    K.cancelLabel: 'Cancel',
    K.recordLabel: 'Save',
    // Export File
    K.exportLabel: 'Export',
    K.exportJsonLabel: 'Export as JSON',
    K.importJsonLabel: 'Import (JSON)',
    K.copyJsonLabel: 'Copy JSON Text',
    K.snackBarMessageFileExportSuccess: 'File saved!',
    K.snackBarMessageFileExportError: 'An error has occurred! File not saved.',
    K.snackBarMessageFileImportSuccess: 'File imported!',
    K.snackBarMessageFileImportError: 'An error has occurred! File not imported.',
    // CaptureActivity
    // BarcodeAnalysisActivity
    K.barcodeInformationSearchLabel: 'Searching…',
    K.scanErrorLabel: 'Error during scanning!',
    K.scanErrorShortInformationLabel: 'An error occurred while searching for information!',
    K.barcodeScannedLabel: '%1s scanned!',
    K.barcodeFoundOnLabel: 'Found on %1s!',
    K.barcodeNotFoundOnApiLabel: 'No information found on %1s.',
    K.noInternetPermission: "You don't have permission to access the Internet.",
    K.aboutBarcodeInformationLabel: 'Information on barcode',
    K.aboutBarcodeLabel: 'About barcode',
    K.aboutBarcodeFormatLabel: 'Format: ',
    K.aboutBarcodeContentLabel: 'Barcode: ',
    K.aboutBarcodeOriginLabel: 'Origin: ',
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
    K.barCodeContentLabel: 'Barcode content',
    K.barCodeAnalysisLabel: 'Barcode analysis',
    // Matrix Barcode Contact Analysis
    K.matrixContactNameLabel: 'Name',
    K.matrixContactOrganisationLabel: 'Organisation',
    K.matrixContactJobTitleLabel: 'Job title',
    K.matrixContactPhoneLabel: 'Phone',
    K.matrixContactMailLabel: 'Email',
    K.matrixContactAddressLabel: 'Address',
    K.matrixContactNotesLabel: 'Notes',
    // Matrix Barcode Agenda Analysis
    K.matrixAgendaNameEventLabel: 'Event name',
    K.matrixAgendaStartDateEventLabel: 'Start',
    K.matrixAgendaEndDateEventLabel: 'End',
    K.matrixAgendaPlaceEventLabel: 'Place',
    K.matrixAgendaDescriptionEventLabel: 'Description',
    // Matrix Barcode Phone Analysis
    K.matrixPhoneTelNumberLabel: 'Phone',
    // Matrix Barcode Email Analysis
    K.matrixEmailRecipientLabel: 'Recipient',
    K.matrixEmailCcLabel: 'CC',
    K.matrixEmailBccLabel: 'BCC',
    K.matrixSubjectLabel: 'Subject',
    K.matrixBodyLabel: 'Message',
    // Matrix Barcode Wi-Fi Analysis
    K.matrixWifiSsidLabel: 'SSID',
    K.matrixWifiPasswordLabel: 'Password',
    K.matrixWifiEncryptionLabel: 'Encryption',
    K.matrixWifiIsHiddenLabel: 'Hidden',
    K.matrixWifiAnonymousIdentityLabel: 'Anonymous Identity',
    K.matrixWifiIdentityLabel: 'Identity',
    K.matrixWifiEapMethodLabel: 'Eap Method',
    K.matrixWifiPhase2MethodLabel: 'Phase 2 Method',
    // Matrix Barcode URL Analysis
    K.matrixUriUrlLabel: 'URL',
    K.matrixUriMaliciousLabel: 'URL may be malicious…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    K.matrixLocalisationLatitudeLabel: 'Latitude',
    K.matrixLocalisationLongitudeLabel: 'Longitude',
    K.matrixLocalisationAltitudeLabel: 'Altitude',
    K.matrixLocalisationQueryLabel: 'Query',
    K.matrixLocalisationButtonFindLocation: 'Generate from your position',
    K.matrixLocalisationSearchCurrentPositionLabel: 'Search for the current position…',
    K.matrixLocalisationLocationDisabledLabel: 'The location on your device does not seem to be activated.',
    // Barcode Description
    K.barcodeIndustrialDescriptionLabel: 'This type of barcode is often used in the industry.',
    K.barcodeCode39DescriptionLabel: 'Code 39 is a barcode used in textile marking and drugs in pharmacies. It is also used in military sector and automotive industry.',
    K.barcodeCode93DescriptionLabel: 'Code 93 is a barcode used in army and automotive sectors, as well as by "Postes Canada" to encode special deliveries information.',
    K.barcodeCode128DescriptionLabel: 'Code 128 is a barcode often used in the industry. It is used in transport industry and for product identification in supply chains. It can also be used in automotive sector or for product marking in pharmacies. Code 128 is widely used and can also be used in many other endings.',
    K.barcodeItfDescriptionLabel: 'Code ITF (Interleaved 2 of 5) is a barcode mainly used for goods shipments.',
    K.barcodeCodabarDescriptionLabel: 'Code Codabar is a barcode designed to be read by dot matrix printers. Today, Codabar is little used for the benefit of other barcodes types, but is still used by some organisations like libraries.',
    K.barcodeUpcADescriptionLabel: 'Code UPC-A (Universal Product Code) is a barcode widely used in USA and Canada to identify products sold in stores and shops. It is composed of 12 digits.',
    K.barcodeUpcEDescriptionLabel: 'Code UPC-E (Universal Product Code) is a condensed barcode of code UPC-A mainly used in USA and Canada to identify products sold in stores and shops. It is used on packaging too small to receive code UPC-A.',
    K.barcodeEan13DescriptionLabel: 'Code EAN-13 (European Article Numbering 13) is a barcode widely used to identify products sold in stores and shops in Europe and pretty much everywhere in the world. It is composed of 13 digits.',
    K.barcodeEan8DescriptionLabel: 'Code EAN-8 (European Article Numbering 8) is a condensed barcode of code EAN-13 used to identify products sold in stores and shops in Europe and pretty much everywhere in the world. It is used on packaging too small to receive code EAN-13.',
    // Barcode Composition
    K.barcodeTextCompositionLabel: 'Text',
    K.barcodeTextNoSpecialCompositionLabel: 'Text without special chars',
    K.barcodeTextUpperNoSpecialCompositionLabel: 'Uppercase without special chars',
    K.barcodeDigitsCompositionLabel: 'Digits',
    K.barcodeEvenDigitsCompositionLabel: 'Even digits',
    K.barcode7Digits1CheckCompositionLabel: '7 digits + 1 check',
    K.barcode11Digits1CheckCompositionLabel: '11 digits + 1 check',
    K.barcode12Digits1CheckCompositionLabel: '12 digits + 1 check',
    // Snackbar Feddbacks
    K.snackBarMessagePermissionRefused: 'You must accept permission to use this functionality.',
    K.snackBarMessageSaveBitmapOk: 'Image has been saved',
    K.snackBarMessageSaveBitmapError: 'Image has not been saved…\nInsufficient memory?',
    K.snackBarMessageShareBitmapError: 'An error occurred during share configuration.',
    // Actions
    K.actionsLabel: 'Actions',
    K.intentChooserShareTitle: 'Share with…',
    K.intentChooserMailTitle: 'Send email…',
    K.copyBarcodeLabel: 'Copy barcode',
    K.copyLabel: 'Copy',
    K.barcodeCopiedLabel: 'Barcode copied',
    K.barcodeSearchErrorLabel: 'Url not supported',
    K.barcodeSearchErrorNoCompatibleApplicationFound: 'No compatible application found',
    K.searchLabel: 'Search',
    K.actionTitleDialogLabel: 'What do you want to do?',
    K.actionGoToUrlLabel: 'Go to URL',
    K.actionWebSearchLabel: 'Search on the web',
    K.actionProductSearchLabel: 'Search on',
    K.actionSendMailLabel: 'Send Email',
    K.actionSendSmsLabel: 'Send SMS',
    K.actionCallPhoneLabel: 'Call phone number',
    K.actionAddToCalendar: 'Add to calendar',
    K.actionAddToContacts: 'Add to contacts',
    K.actionShareVcfFile: 'Share as VCF',
    K.actionShowLocation: 'Show location',
    K.actionOpenLink: 'Open link',
    K.actionModifyBarcode: 'Modify barcode',
    K.actionModifyNotes: 'Modify Notes',
    K.apply: 'Apply',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    K.errorBarcodeNoneCharacterMessage: 'You must enter a correct value in the input field.',
    K.errorBarcodeNotANumberMessage: 'Barcode must be composed of digits only.',
    K.errorBarcodeWrongLengthMessage: 'Required digit length for barcode: ',
    K.errorBarcodeWrongKeyMessage: 'Last Digit (check digit) should be: ',
    K.errorBarcodeEncodingIso88591ErrorMessage: 'Special characters are not supported for this barcode type.',
    K.errorBarcodeEncodingUsAsciiErrorMessage: 'Special characters are not supported for this barcode type.',
    K.errorBarcode93RegexErrorMessage: '"Code 93" barcode type can codify the 26 uppercase letters, the 10 digits (0 to 9) as well as the 8 special characters « -, ., space, *, \$, /, +, % ». Lowercase letters and other special characters can not be codify by this barcode type.',
    K.errorBarcode39RegexErrorMessage: '"Code 39" barcode type can codify the 26 uppercase letters, the 10 digits (0 to 9) as well as the 7 special characters « -, ., space, \$, /, +, % ». Lowercase letters and other special characters can not be codify by this barcode type.',
    K.errorBarcodeCodabarRegexErrorMessage: '"Codabar" barcode type can codify the 10 digits (0 to 9) as well as the 6 special characters « -, \$, :, /, ., + ». It can also contain characters A, B, C or D for the first and the last barcode character to specify the beginning and the end of the string.',
    K.errorBarcodeItfErrorMessage: '"ITF" barcode type must contain an even number of characters.',
    K.errorBarcodeUpcENotStartWith0ErrorMessage: '"UPC-E" barcode type must begin with 0.',
    K.errorBarcodeQrUrlFormatMessage: 'A web address must begin with "http://" or "https://"',
    K.errorBarcodeQrPhoneNumberMissingMessage: 'You must enter a phone number',
    K.errorBarcodeQrEmailMissingMessage: 'You must inform at least one of the input fields',
    K.errorBarcodeQrLocalisationMissingMessage: 'You must inform latitude and longitude',
    // Action Barcode Generated
    K.barcodeCreatorConfirmTextLabel: 'Generate',
    K.saveLabel: 'Save',
    K.shareLabel: 'Share',
    K.shareImageLabel: 'Share image',
    K.shareTextLabel: 'Share text',
    K.popupMessageConfirmationSaveImage: 'Save image?',
    K.clipboardEmpty: 'The clipboard is empty.',
    // Barcode Image Editor
    // Form
    K.qrCodeTextGeneratorHintTextInputEditText: 'Enter text…',
    K.qrCodeTextGeneratorHintPhoneInputEditText: 'Enter phone number…',
    K.qrCodeTextGeneratorHintUrlInputEditText: 'Enter web address…',
    K.qrCodeTextInputEditTextHintMessage: 'Message',
    // Contact Creator
    K.qrCodeTypeNameGenerateFromContact: 'Generate from contact',
    K.qrCodeImportContactFromVcard: 'Generate from vCard',
    K.qrCodeTextRadioButtonLabelM: 'M',
    K.qrCodeTextRadioButtonLabelMrs: 'Mrs',
    K.qrCodeTextRadioButtonLabelMiss: 'Miss',
    K.qrCodeTextRadioButtonLabelNone: 'None',
    K.qrCodeTextInputEditTextHintName: 'Name',
    K.qrCodeTextInputEditTextHintFirstName: 'First name',
    K.qrCodeTextInputEditTextHintWebSite: 'Web Site',
    K.qrCodeTextInputEditTextHintMail1: 'Mail address 1',
    K.qrCodeTextInputEditTextHintMail2: 'Mail address 2',
    K.qrCodeTextInputEditTextHintMail3: 'Mail address 3',
    K.qrCodeTextInputEditTextHintPhone1: 'Phone number 1',
    K.qrCodeTextInputEditTextHintPhone2: 'Phone number 2',
    K.qrCodeTextInputEditTextHintPhone3: 'Phone number 3',
    K.qrCodeTextInputEditTextHintStreetAddress: 'Street Address',
    K.qrCodeTextInputEditTextHintPostalCode: 'Postal code',
    K.qrCodeTextInputEditTextHintCity: 'City',
    K.qrCodeTextInputEditTextHintCountry: 'Country',
    K.qrCodeTextInputEditTextHintRegion: 'Region',
    K.qrCodeTextInputEditTextHintNotes: 'Notes',
    K.qrCodeSpinnerPromptNone: 'None',
    K.spinnerTypeMobile: 'Mobile',
    K.spinnerTypeFax: 'Fax',
    K.spinnerTypeHome: 'Home',
    K.spinnerTypeWork: 'Work',
    K.spinnerTypeOther: 'Other',
    // EPC Creator
    // Mail Creator
    K.qrCodeTextInputEditTextHintEmail: 'Email',
    K.qrCodeTextInputEditTextHintEmailSubject: 'Subject',
    // Geo Localisation Creator
    K.qrCodeTextInputEditTextHintLocalisationLatitude: 'Latitude',
    K.qrCodeTextInputEditTextHintLocalisationLongitude: 'Longitude',
    K.qrCodeTextInputEditTextHintLocalisationHeight: 'Height',
    K.qrCodeTextInputEditTextHintLocalisationRequest: 'Request',
    // Wifi Creator
    K.qrCodeTextInputEditTextHintWifiSsid: 'SSID / Network name',
    K.qrCodeTextInputEditTextHintWifiPassword: 'Password',
    K.qrCodeTextInputEditTextHintWifiHide: 'Hidden',
    K.spinnerWifiEncryptionWep: 'WEP',
    K.spinnerWifiEncryptionWpa: 'WPA/WPA2',
    K.spinnerWifiEncryptionSae: 'WPA3',
    K.spinnerWifiEncryptionNone: 'No password',
    // Event Creator
    K.qrCodeTextInputEditTextHintAgendaEventName: 'Event name',
    K.qrCodeTextInputEditTextHintAgendaPlace: 'Place',
    K.qrCodeTextInputEditTextHintAgendaDescription: 'Description',
    K.checkBoxEventAllOfDay: 'All day',
    K.beginLabel: 'Begin',
    K.endLabel: 'End',

    // URL
    // Custom search URL
    K.customSearchUrls: 'Custom search URLs',
    K.customUrls: 'Custom URLs',
    K.customSearchUrlsAddUrl: 'Add a URL',
    K.customSearchUrlsModifyUrl: 'Modify the URL',
    K.customSearchUrlsList: 'URLs list',
    K.customSearchUrlsListIsEmptyMessage: 'No item…\nYou have not generated a custom URL yet.',
    K.popupMessageConfirmationDeletedAllCustomUrls: 'Do you want to delete all custom URLs?',
    K.customUrlDeleted: 'Custom URL deleted!',
    K.customUrlAdded: 'Custom URL added!',
    K.customUrlUpdated: 'Custom URL updated!',
    K.customSearchUrlsAddInfo: 'Use the term "{code}" in the URL. This term will be replaced by the content of the barcode during the search.',
    K.examples: 'Examples:',
    K.customSearchUrlsErrorUrl: 'The term "{code}" must be present in the URL.',
    K.errorEmptyFields: 'Input fields must not be empty.',
    K.customSearchUrlsisDuplicated: 'The name has been duplicated, please enter another name.',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    K.preferencesDefault: 'Default',
    // Appearance Settings
    K.preferencesAppearanceTitle: 'Appearance',
    K.preferencesThemeLabel: 'Theme',
    K.preferencesSwitchSystemThemeLabel: 'Follow System',
    K.preferencesSwitchLightThemeLabel: 'Light',
    K.preferencesSwitchDarkThemeLabel: 'Dark',
    K.preferencesColor: 'Main Color',
    K.preferencesColorMaterialYou: 'System (Material You)',
    K.preferencesColorBlue: 'Blue',
    K.preferencesColorOrange: 'Orange',
    K.preferencesColorGreen: 'Green',
    K.preferencesColorRed: 'Red',
    K.preferencesColorPurple: 'Purple',
    // Languages Settings
    K.preferencesLanguagesTitle: 'Languages',
    K.preferencesLanguagesChange: 'Change the language',
    // Remote API
    // About Remote API
    // Scan Settings
    K.preferencesScanTitle: 'Scan',
    K.preferencesSwitchScanAutoOpenWebsiteLabel: 'Automatically open website',
    K.preferencesSwitchScanContinuousScanLabel: 'Continuous Scanning',
    K.preferencesSwitchScanVibrateLabel: 'Vibrate when scan',
    K.preferencesSwitchScanBipLabel: 'Play sound when scan',
    K.preferencesSwitchScanScreenRotationLabel: 'Disable rotation in scaning',
    K.preferencesSwitchScanBarcodeCopiedLabel: 'Copy scanned barcodes',
    K.preferencesSwitchScanUseFrontcameraLabel: 'Use front camera',
    // Barcode Generation Settings
    K.preferencesBarcodeGenerationTitle: 'Barcode generation',
    // History settings-->
    K.preferencesSwitchScanAddBarcodeToTheHistoryLabel: 'Add scanned barcodes',
    K.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel: 'Add generated barcodes',
    K.preferencesSwitchHistorySaveDuplicatesLabel: 'Add duplicates',
    // Search Engine Settings
    K.preferencesSearchTitle: 'Search',
    K.preferencesSearchEngine: 'Search engine',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    K.preferencesAboutTitle: 'About',
    K.preferencesAboutOpenSourceLibrariesLabel: 'Open Source Licenses',
    K.preferencesApplicationVersionLabel: 'App Version',
    K.preferencesSourceCodeLabel: 'Source code',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}