import 'language.dart';


class LanguageEn extends Language {
  LanguageEn() : super(
    fallbackLanguage: null, const { // 英文沒有替代語言
    // Permission Denied
    'cameraPermissionDenied': 'Waiting for Authorized Access to the Camera.',
    // AlertDialog
    'closeDialogLabel': 'Close',
    'yesLabel': 'Yes',
    'noLabel': 'No',
    'goToDialogLabel': 'Enter website',
    'error': 'Error',
    // ImageView Description
    'imageViewDescriptionFlag': 'Flag',
    'imageViewDescriptionLogo': 'Logo',
    'imageViewDescriptionTypeIcon': 'Type',
    'imageViewDescriptionBarCode': 'Barcode',
    'imageViewDescriptionIcon': 'Icon',
    'imageViewDescriptionProductFront': 'Product picture',
    'imageViewDescriptionNutriscore': 'NUTRI-SCORE',
    'imageViewDescriptionNovaGroup': 'NOVA GROUP',
    'imageViewDescriptionEcoScore': 'ECO SCORE',
    'imageViewDescriptionBackground': 'Background',
    'imageViewDescriptionImage': 'Image',
    'sliderDescriptionZoom': 'Zoom',
    // Menu Item
    'titleScan': 'Scan',
    'titleHistory': 'History',
    'titleGenerate': 'Generate',
    'titleSettings': 'Settings',
    'titleQrCodeCreator': 'Generate a QR Code',
    'titleBarCodeCreator': 'Generate a barcode',
    'createQrFromClipboard': 'Generate from the clipboard',
    'informationLabel': 'Information',
    'barcodeLabel': 'Barcode',
    'downloadFromApiLabel': 'Download from APIs',
    'shareToThisAppLabel': 'Can also share to this program from other applications.',
    'menuMore': 'More',
    // Barcode Type
    'barcodeQrCodeLabel': 'QR Code',
    'barcodeDataMatrixLabel': 'Data Matrix',
    'barcodePdf417Label': 'PDF 417',
    'barcodeAztecLabel': 'AZTEC',
    'barcodeEan13Label': 'EAN 13',
    'barcodeEan8Label': 'EAN 8',
    'barcodeUpcALabel': 'UPC A',
    'barcodeUpcELabel': 'UPC E',
    'barcodeCode128Label': 'Code 128',
    'barcodeCode93Label': 'Code 93',
    'barcodeCode39Label': 'Code 39',
    'barcodeCodabarLabel': 'Codabar',
    'barcodeItfLabel': 'ITF',
    // QR Type
    'qrCodeTypeNameText': 'Text',
    'qrCodeTypeNameWebSite': 'Website',
    'qrCodeTypeNameContact': 'Contact',
    'qrCodeTypeNameMail': 'Mail',
    'qrCodeTypeNameSms': 'SMS',
    'qrCodeTypeNamePhone': 'Phone number',
    'qrCodeTypeNameGeographicCoordinates': 'Geographic coordinates',
    'qrCodeTypeNameAgenda': 'Agenda',
    'qrCodeTypeNameWifi': 'Wi-Fi',
    'qrCodeTypeNameApps': 'Application',
    // Product Type
    'barCodeTypeProduct': 'Product',
    'barCodeTypeIndustrial': 'Industrial Code',
    'barCodeTypeNameUnknown': 'Unknown',
    // Error Correction Level
    'qrCodeErrorCorrectionLevelLabel': 'Error correction level',
    'qrCodeErrorCorrectionLevelSettingsLabel': 'Error correction level (QR Code)',
    'qrCodeErrorCorrectionLevelNameLow': 'Low (~7%)',
    'qrCodeErrorCorrectionLevelNameMedium': 'Medium (~15%)',
    'qrCodeErrorCorrectionLevelNameQuartile': 'Quartile (~25%)',
    'qrCodeErrorCorrectionLevelNameHigh': 'High (~30%)',
    // History
    'labelHistoryEmpty': 'No elements scanned…',
    'snackBarMessageItemDeleted': 'The product has been deleted from history.',
    'snackBarMessageItemsDeleted': 'Items deleted from history.',
    'popupMessageConfirmationDeleteHistory': 'Delete all history?',
    'popupMessageConfirmationDeleteSelectedItemsHistory': 'Delete selected items?',
    'menuItemHistoryDelete': 'Delete history',
    'menuItemHistoryDeleteFromHistory': 'Delete from history',
    'menuItemHistoryRemovedFromHistory': 'Removed from history!',
    'menuItemHistoryAddInHistory': 'Add in the history',
    'menuItemHistoryAddedInHistory': 'Added in the history!',
    'menuItemHistoryAddFavorite': 'Add to Favorites',
    'menuItemHistoryRemoveFavorite': 'Delete from Favorites',
    'deleteLabel': 'Delete',
    'cancelLabel': 'Cancel',
    'recordLabel': 'Save',
    // Export File
    'exportLabel': 'Export',
    'exportJsonLabel': 'Export as JSON',
    'importJsonLabel': 'Import (JSON)',
    'snackBarMessageFileExportSuccess': 'File saved!',
    'snackBarMessageFileExportError': 'An error has occurred! File not saved.',
    'snackBarMessageFileImportSuccess': 'File imported!',
    'snackBarMessageFileImportError': 'An error has occurred! File not imported.',
    // CaptureActivity
    // BarcodeAnalysisActivity
    'barcodeInformationSearchLabel': 'Searching…',
    'scanErrorLabel': 'Error during scanning!',
    'scanErrorShortInformationLabel': 'An error occurred while searching for information!',
    'barcodeScannedLabel': '%1s scanned!',
    'barcodeFoundOnLabel': 'Found on %1s!',
    'barcodeNotFoundOnApiLabel': 'No information found on %1s.',
    'noInternetPermission': "You don't have permission to access the Internet.",
    'aboutBarcodeInformationLabel': 'Information on barcode',
    'aboutBarcodeLabel': 'About barcode',
    'aboutBarcodeFormatLabel': 'Format: ',
    'aboutBarcodeContentLabel': 'Barcode: ',
    'aboutBarcodeOriginLabel': 'Origin: ',
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
    'barCodeContentLabel': 'Barcode content',
    'barCodeAnalysisLabel': 'Barcode analysis',
    // Matrix Barcode Contact Analysis
    'matrixContactNameLabel': 'Name',
    'matrixContactOrganisationLabel': 'Organisation',
    'matrixContactJobTitleLabel': 'Job title',
    'matrixContactPhoneLabel': 'Phone',
    'matrixContactMailLabel': 'Email',
    'matrixContactAddressLabel': 'Address',
    'matrixContactNotesLabel': 'Notes',
    // Matrix Barcode Agenda Analysis
    'matrixAgendaNameEventLabel': 'Event name',
    'matrixAgendaStartDateEventLabel': 'Start',
    'matrixAgendaEndDateEventLabel': 'End',
    'matrixAgendaPlaceEventLabel': 'Place',
    'matrixAgendaDescriptionEventLabel': 'Description',
    // Matrix Barcode Phone Analysis
    'matrixPhoneTelNumberLabel': 'Phone',
    // Matrix Barcode Email Analysis
    'matrixEmailRecipientLabel': 'Recipient',
    'matrixEmailCcLabel': 'CC',
    'matrixEmailBccLabel': 'BCC',
    'matrixSubjectLabel': 'Subject',
    'matrixBodyLabel': 'Message',
    // Matrix Barcode Wi-Fi Analysis
    'matrixWifiSsidLabel': 'SSID',
    'matrixWifiPasswordLabel': 'Password',
    'matrixWifiEncryptionLabel': 'Encryption',
    'matrixWifiIsHiddenLabel': 'Hidden',
    'matrixWifiAnonymousIdentityLabel': 'Anonymous Identity',
    'matrixWifiIdentityLabel': 'Identity',
    'matrixWifiEapMethodLabel': 'Eap Method',
    'matrixWifiPhase2MethodLabel': 'Phase 2 Method',
    // Matrix Barcode URL Analysis
    'matrixUriUrlLabel': 'URL',
    'matrixUriMaliciousLabel': 'URL may be malicious…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    'matrixLocalisationLatitudeLabel': 'Latitude',
    'matrixLocalisationLongitudeLabel': 'Longitude',
    'matrixLocalisationAltitudeLabel': 'Altitude',
    'matrixLocalisationQueryLabel': 'Query',
    'matrixLocalisationButtonFindLocation': 'Generate from your position',
    'matrixLocalisationSearchCurrentPositionLabel': 'Search for the current position…',
    'matrixLocalisationLocationDisabledLabel': 'The location on your device does not seem to be activated.',
    // Barcode Description
    'barcodeIndustrialDescriptionLabel': 'This type of barcode is often used in the industry.',
    'barcodeCode39DescriptionLabel': 'Code 39 is a barcode used in textile marking and drugs in pharmacies. It is also used in military sector and automotive industry.',
    'barcodeCode93DescriptionLabel': 'Code 93 is a barcode used in army and automotive sectors, as well as by "Postes Canada" to encode special deliveries information.',
    'barcodeCode128DescriptionLabel': 'Code 128 is a barcode often used in the industry. It is used in transport industry and for product identification in supply chains. It can also be used in automotive sector or for product marking in pharmacies. Code 128 is widely used and can also be used in many other endings.',
    'barcodeItfDescriptionLabel': 'Code ITF (Interleaved 2 of 5) is a barcode mainly used for goods shipments.',
    'barcodeCodabarDescriptionLabel': 'Code Codabar is a barcode designed to be read by dot matrix printers. Today, Codabar is little used for the benefit of other barcodes types, but is still used by some organisations like libraries.',
    'barcodeUpcADescriptionLabel': 'Code UPC-A (Universal Product Code) is a barcode widely used in USA and Canada to identify products sold in stores and shops. It is composed of 12 digits.',
    'barcodeUpcEDescriptionLabel': 'Code UPC-E (Universal Product Code) is a condensed barcode of code UPC-A mainly used in USA and Canada to identify products sold in stores and shops. It is used on packaging too small to receive code UPC-A.',
    'barcodeEan13DescriptionLabel': 'Code EAN-13 (European Article Numbering 13) is a barcode widely used to identify products sold in stores and shops in Europe and pretty much everywhere in the world. It is composed of 13 digits.',
    'barcodeEan8DescriptionLabel': 'Code EAN-8 (European Article Numbering 8) is a condensed barcode of code EAN-13 used to identify products sold in stores and shops in Europe and pretty much everywhere in the world. It is used on packaging too small to receive code EAN-13.',
    // Barcode Composition
    'barcodeTextCompositionLabel': 'Text',
    'barcodeTextNoSpecialCompositionLabel': 'Text without special chars',
    'barcodeTextUpperNoSpecialCompositionLabel': 'Uppercase without special chars',
    'barcodeDigitsCompositionLabel': 'Digits',
    'barcodeEvenDigitsCompositionLabel': 'Even digits',
    'barcode7Digits1CheckCompositionLabel': '7 digits + 1 check',
    'barcode11Digits1CheckCompositionLabel': '11 digits + 1 check',
    'barcode12Digits1CheckCompositionLabel': '12 digits + 1 check',
    // Snackbar Feddbacks
    'snackBarMessagePermissionRefused': 'You must accept permission to use this functionality.',
    'snackBarMessageSaveBitmapOk': 'Image has been saved',
    'snackBarMessageSaveBitmapError': 'Image has not been saved… \nInsufficient memory?',
    'snackBarMessageShareBitmapError': 'An error occurred during share configuration.',
    // Actions
    'actionsLabel': 'Actions',
    'intentChooserShareTitle': 'Share with…',
    'intentChooserMailTitle': 'Send email…',
    'copyBarcodeLabel': 'Copy barcode',
    'copyLabel': 'Copy',
    'barcodeCopiedLabel': 'Barcode copied',
    'barcodeSearchErrorLabel': 'Url not supported',
    'barcodeSearchErrorNoCompatibleApplicationFound': 'No compatible application found',
    'searchLabel': 'Search',
    'actionTitleDialogLabel': 'What do you want to do?',
    'actionGoToUrlLabel': 'Go to URL',
    'actionWebSearchLabel': 'Search on the web',
    'actionProductSearchLabel': 'Search on',
    'actionSendMailLabel': 'Send Email',
    'actionSendSmsLabel': 'Send SMS',
    'actionCallPhoneLabel': 'Call phone number',
    'actionAddToCalendar': 'Add to calendar',
    'actionAddToContacts': 'Add to contacts',
    'actionShareVcfFile': 'Share as VCF',
    'actionShowLocation': 'Show location',
    'actionOpenLink': 'Open link',
    'actionModifyBarcode': 'Modify barcode',
    'actionModifyNotes': 'Modify Notes',
    'apply': 'Apply',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    'errorBarcodeNoneCharacterMessage': 'You must enter a correct value in the input field.',
    'errorBarcodeNotANumberMessage': 'Barcode must be composed of digits only.',
    'errorBarcodeWrongLengthMessage': 'Required digit length for barcode: ',
    'errorBarcodeWrongKeyMessage': 'Last Digit (check digit) should be: ',
    'errorBarcodeEncodingIso88591ErrorMessage': 'Special characters are not supported for this barcode type.',
    'errorBarcodeEncodingUsAsciiErrorMessage': 'Special characters are not supported for this barcode type.',
    'errorBarcode93RegexErrorMessage': '"Code 93" barcode type can codify the 26 uppercase letters, the 10 digits (0 to 9) as well as the 8 special characters « -, ., space, *, \$, /, +, % ». Lowercase letters and other special characters can not be codify by this barcode type.',
    'errorBarcode39RegexErrorMessage': '"Code 39" barcode type can codify the 26 uppercase letters, the 10 digits (0 to 9) as well as the 7 special characters « -, ., space, \$, /, +, % ». Lowercase letters and other special characters can not be codify by this barcode type.',
    'errorBarcodeCodabarRegexErrorMessage': '"Codabar" barcode type can codify the 10 digits (0 to 9) as well as the 6 special characters « -, \$, :, /, ., + ». It can also contain characters A, B, C or D for the first and the last barcode character to specify the beginning and the end of the string.',
    'errorBarcodeItfErrorMessage': '"ITF" barcode type must contain an even number of characters.',
    'errorBarcodeUpcENotStartWith0ErrorMessage': '"UPC-E" barcode type must begin with 0.',
    'errorBarcodeQrUrlFormatMessage': 'A web address must begin with "http://" or "https://"',
    'errorBarcodeQrPhoneNumberMissingMessage': 'You must enter a phone number',
    'errorBarcodeQrEmailMissingMessage': 'You must inform at least one of the input fields',
    'errorBarcodeQrLocalisationMissingMessage': 'You must inform latitude and longitude',
    // Action Barcode Generated
    'barcodeCreatorConfirmTextLabel': 'Generate',
    'saveLabel': 'Save',
    'shareLabel': 'Share',
    'shareImageLabel': 'Share image',
    'shareTextLabel': 'Share text',
    'popupMessageConfirmationSaveImage': 'Save image?',
    'clipboardEmpty': 'The clipboard is empty.',
    // Barcode Image Editor
    // Form
    'qrCodeTextGeneratorHintTextInputEditText': 'Enter text…',
    'qrCodeTextGeneratorHintPhoneInputEditText': 'Enter phone number…',
    'qrCodeTextGeneratorHintUrlInputEditText': 'Enter web address…',
    'qrCodeTextInputEditTextHintMessage': 'Message',
    // Contact Creator
    'qrCodeTypeNameGenerateFromContact': 'Generate from contact',
    'qrCodeImportContactFromVcard': 'Generate from vCard',
    'qrCodeTextRadioButtonLabelM': 'M',
    'qrCodeTextRadioButtonLabelMrs': 'Mrs',
    'qrCodeTextRadioButtonLabelMiss': 'Miss',
    'qrCodeTextRadioButtonLabelNone': 'None',
    'qrCodeTextInputEditTextHintName': 'Name',
    'qrCodeTextInputEditTextHintFirstName': 'First name',
    'qrCodeTextInputEditTextHintWebSite': 'Web Site',
    'qrCodeTextInputEditTextHintMail1': 'Mail address 1',
    'qrCodeTextInputEditTextHintMail2': 'Mail address 2',
    'qrCodeTextInputEditTextHintMail3': 'Mail address 3',
    'qrCodeTextInputEditTextHintPhone1': 'Phone number 1',
    'qrCodeTextInputEditTextHintPhone2': 'Phone number 2',
    'qrCodeTextInputEditTextHintPhone3': 'Phone number 3',
    'qrCodeTextInputEditTextHintStreetAddress': 'Street Address',
    'qrCodeTextInputEditTextHintPostalCode': 'Postal code',
    'qrCodeTextInputEditTextHintCity': 'City',
    'qrCodeTextInputEditTextHintCountry': 'Country',
    'qrCodeTextInputEditTextHintRegion': 'Region',
    'qrCodeTextInputEditTextHintNotes': 'Notes',
    'qrCodeSpinnerPromptNone': 'None',
    'spinnerTypeMobile': 'Mobile',
    'spinnerTypeFax': 'Fax',
    'spinnerTypeHome': 'Home',
    'spinnerTypeWork': 'Work',
    'spinnerTypeOther': 'Other',
    // EPC Creator
    'qrCodeTextInputEditTextHintEpcServiceTag': 'Service Tag',
    'qrCodeTextInputEditTextHintEpcVersion': 'Version',
    'qrCodeTextInputEditTextHintEpcCharacterSet': 'Character set',
    'qrCodeTextInputEditTextHintEpcIdentification': 'Identification',
    'qrCodeTextInputEditTextHintEpcBic': 'BIC',
    'qrCodeTextInputEditTextHintEpcName': 'Name',
    'qrCodeTextInputEditTextHintEpcIban': 'IBAN',
    'qrCodeTextInputEditTextHintEpcAmount': 'Amount',
    'qrCodeTextInputEditTextHintEpcPurpose': 'Purpose',
    'qrCodeTextInputEditTextHintEpcRemittanceRef': 'Remittance (Reference)',
    'qrCodeTextInputEditTextHintEpcRemittanceText': 'Remittance (Text)',
    'qrCodeTextInputEditTextHintEpcInformation': 'Information',
    'qrCodeTextInputEditTextEpcNameError': '"Name" field is mandatory',
    'qrCodeTextInputEditTextEpcIbanError': 'IBAN incorrect',
    'listBankEmptyMessage': 'No item…\nYou have not yet generated an EPC QR Code.',
    // Mail Creator
    'qrCodeTextInputEditTextHintEmail': 'Email',
    'qrCodeTextInputEditTextHintEmailSubject': 'Subject',
    // Geo Localisation Creator
    'qrCodeTextInputEditTextHintLocalisationLatitude': 'Latitude',
    'qrCodeTextInputEditTextHintLocalisationLongitude': 'Longitude',
    'qrCodeTextInputEditTextHintLocalisationHeight': 'Height',
    'qrCodeTextInputEditTextHintLocalisationRequest': 'Request',
    // Wifi Creator
    'qrCodeTextInputEditTextHintWifiSsid': 'SSID / Network name',
    'qrCodeTextInputEditTextHintWifiPassword': 'Password',
    'qrCodeTextInputEditTextHintWifiHide': 'Hidden',
    'spinnerWifiEncryptionWep': 'WEP',
    'spinnerWifiEncryptionWpa': 'WPA/WPA2',
    'spinnerWifiEncryptionSae': 'WPA3',
    'spinnerWifiEncryptionNone': 'No password',
    // Event Creator
    'qrCodeTextInputEditTextHintAgendaEventName': 'Event name',
    'qrCodeTextInputEditTextHintAgendaPlace': 'Place',
    'qrCodeTextInputEditTextHintAgendaDescription': 'Description',
    'checkBoxEventAllOfDay': 'All day',
    'beginLabel': 'Begin',
    'endLabel': 'End',

    // URL
    // Custom search URL
    'customSearchUrls': 'Custom search URLs',
    'customUrls': 'Custom URLs',
    'customSearchUrlsAddUrl': 'Add a URL',
    'customSearchUrlsModifyUrl': 'Modify the URL',
    'customSearchUrlsList': 'URLs list',
    'customSearchUrlsListIsEmptyMessage': 'No item…\nYou have not generated a custom URL yet.',
    'popupMessageConfirmationDeletedAllCustomUrls': 'Do you want to delete all custom URLs?',
    'customUrlDeleted': 'Custom URL deleted!',
    'customUrlAdded': 'Custom URL added!',
    'customUrlUpdated': 'Custom URL updated!',
    'customSearchUrlsAddInfo': 'Use the term "{code}" in the URL. This term will be replaced by the content of the barcode during the search.',
    'examples': 'Examples:',
    'customSearchUrlsErrorUrl': 'The term "{code}" must be present in the URL.',
    'errorEmptyFields': 'Input fields must not be empty.',
    'customSearchUrlsisDuplicated': 'The name has been duplicated, please enter another name.',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    'preferencesDefault': 'Default',
    // Appearance Settings
    'preferencesAppearanceTitle': 'Appearance',
    'preferencesThemeLabel': 'Theme',
    'preferencesSwitchSystemThemeLabel': 'Follow System',
    'preferencesSwitchLightThemeLabel': 'Light',
    'preferencesSwitchDarkThemeLabel': 'Dark',
    'preferencesColor': 'Main Color',
    'preferencesColorMaterialYou': 'System (Material You)',
    'preferencesColorBlue': 'Blue',
    'preferencesColorOrange': 'Orange',
    'preferencesColorGreen': 'Green',
    'preferencesColorRed': 'Red',
    'preferencesColorPurple': 'Purple',
    // Languages Settings
    'preferencesLanguagesTitle': 'Languages',
    'preferencesLanguagesChange': 'Change the language',
    // Remote API
    // About Remote API
    // Scan Settings
    'preferencesScanTitle': 'Scan',
    'preferencesSwitchScanAutoOpenWebsiteLabel': 'Automatically open website',
    'preferencesSwitchScanContinuousScanLabel': 'Continuous Scanning',
    'preferencesSwitchScanVibrateLabel': 'Vibrate when scan',
    'preferencesSwitchScanBipLabel': 'Play sound when scan',
    'preferencesSwitchScanScreenRotationLabel': 'Disable rotation in scaning',
    'preferencesSwitchScanBarcodeCopiedLabel': 'Copy scanned barcodes',
    'preferencesSwitchScanUseFrontcameraLabel': 'Use front camera',
    // Barcode Generation Settings
    'preferencesBarcodeGenerationTitle': 'Barcode generation',
    // History settings-->
    'preferencesSwitchScanAddBarcodeToTheHistoryLabel': 'Add scanned barcodes',
    'preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel': 'Add generated barcodes',
    'preferencesSwitchHistorySaveDuplicatesLabel': 'Add duplicates',
    // Search Engine Settings
    'preferencesSearchTitle': 'Search',
    'preferencesSearchEngine': 'Search engine',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    'preferencesAboutTitle': 'About',
    'preferencesAboutThirdPartyLibrariesLabel': 'Third-party libraries',
    'preferencesApplicationVersionLabel': 'App Version',
    'preferencesSourceCodeLabel': 'Source code',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}