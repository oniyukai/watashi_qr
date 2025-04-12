import 'language.dart';
import 'language_en.dart';

class LanguageZhTw extends Language {
  LanguageZhTw() : super(
    fallbackLanguage: LanguageEn(), const {
    // Permission Denied
    'cameraPermissionDenied': '等待授權存取相機。',
    // AlertDialog
    'closeDialogLabel': '關閉',
    'yesLabel': '是',
    'noLabel': '否',
    'goToDialogLabel': '進入網站',
    'error': '錯誤',
    // ImageView Description
    'imageViewDescriptionFlag': '標誌',
    'imageViewDescriptionLogo': '標示',
    'imageViewDescriptionTypeIcon': '類型',
    'imageViewDescriptionBarCode': '條碼',
    'imageViewDescriptionIcon': '圖示',
    'imageViewDescriptionProductFront': '產品圖片',
    'imageViewDescriptionNutriscore': '營養分數',
    'imageViewDescriptionNovaGroup': 'NOVA GROUP',
    'imageViewDescriptionEcoScore': 'ECO SCORE',
    'imageViewDescriptionBackground': '背景',
    'imageViewDescriptionImage': '圖片',
    'sliderDescriptionZoom': '縮放',
    // Menu Item
    'titleScan': '掃描',
    'titleHistory': '歷史紀錄',
    'titleGenerate': '創建',
    'titleSettings': '設定',
    'titleQrCodeCreator': '創建 QR 圖碼',
    'titleBarCodeCreator': '創建條碼',
    'createQrFromClipboard': '從剪貼簿創建 QR 圖碼',
    'informationLabel': '資訊',
    'barcodeLabel': '條碼',
    'downloadFromApiLabel': '從 API 下載',
    'shareToThisAppLabel': '也可以在其他應用中分享到此程式。',
    'menuMore': '更多',
    // Barcode Type
    'barcodeQrCodeLabel': 'QR 圖碼',
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
    'qrCodeTypeNameText': '文字',
    'qrCodeTypeNameWebSite': '網站',
    'qrCodeTypeNameContact': '聯絡人',
    'qrCodeTypeNameMail': '郵件',
    'qrCodeTypeNameSms': '簡訊',
    'qrCodeTypeNamePhone': '電話號碼',
    'qrCodeTypeNameGeographicCoordinates': '地理座標',
    'qrCodeTypeNameAgenda': '日程',
    'qrCodeTypeNameWifi': 'Wi-Fi',
    'qrCodeTypeNameApps': '應用程式',
    // Product Type
    'barCodeTypeProduct': '產品代碼',
    'barCodeTypeIndustrial': '工業代碼',
    'barCodeTypeNameUnknown': '不詳',
    // Error Correction Level
    'qrCodeErrorCorrectionLevelLabel': '錯誤修正等級',
    'qrCodeErrorCorrectionLevelSettingsLabel': '錯誤修正等級（QR 圖碼）',
    'qrCodeErrorCorrectionLevelNameLow': '低（~7%）',
    'qrCodeErrorCorrectionLevelNameMedium': '中（~15%）',
    'qrCodeErrorCorrectionLevelNameQuartile': '四分位數（~25%）',
    'qrCodeErrorCorrectionLevelNameHigh': '高（~30%）',
    // History
    'labelHistoryEmpty': '沒有歷史紀錄…',
    'snackBarMessageItemDeleted': '產品已從歷史紀錄中刪除。',
    'snackBarMessageItemsDeleted': '已從歷史記錄中刪除項目。',
    'popupMessageConfirmationDeleteHistory': '刪除所有歷史紀錄？',
    'popupMessageConfirmationDeleteSelectedItemsHistory': '刪除選取的項目？',
    'menuItemHistoryDelete': '刪除歷史紀錄',
    'menuItemHistoryDeleteFromHistory': '從歷史紀錄中刪除',
    'menuItemHistoryRemovedFromHistory': '已從歷史紀錄中移除！',
    'menuItemHistoryAddInHistory': '加入至歷史紀錄',
    'menuItemHistoryAddedInHistory': '已加入至歷史紀錄！',
    'menuItemHistoryAddFavorite': '添加到收藏夾',
    'menuItemHistoryRemoveFavorite': '收藏夾中移出',
    'deleteLabel': '刪除',
    'cancelLabel': '取消',
    'recordLabel': '儲存',
    // Export File
    'exportLabel': '匯出',
    'exportJsonLabel': '匯出為 JSON',
    'importJsonLabel': '匯入 (JSON)',
    'snackBarMessageFileExportSuccess': '檔案已儲存！',
    'snackBarMessageFileExportError': '發生了錯誤！檔案未儲存。',
    'snackBarMessageFileImportSuccess': '檔案已匯入！',
    'snackBarMessageFileImportError': '發生了錯誤！檔案未匯入。',
    // CaptureActivity
    // BarcodeAnalysisActivity
    'barcodeInformationSearchLabel': '搜尋中…',
    'scanErrorLabel': '掃描時發生錯誤！',
    'scanErrorShortInformationLabel': '搜尋資訊時發生錯誤！',
    'barcodeScannedLabel': '%1s 已掃描！',
    'barcodeFoundOnLabel': '發現 %1s！',
    'barcodeNotFoundOnApiLabel': '沒有發現資訊 %1s。',
    'noInternetPermission': '你沒有允許存取網路。',
    'aboutBarcodeInformationLabel': '條碼資訊',
    'aboutBarcodeLabel': '關於條碼',
    'aboutBarcodeFormatLabel': '格式: ',
    'aboutBarcodeContentLabel': '條碼: ',
    'aboutBarcodeOriginLabel': '來源: ',
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
    'barCodeContentLabel': '條碼內容',
    'barCodeAnalysisLabel': '條碼分析',
    // Matrix Barcode Contact Analysis
    'matrixContactNameLabel': '名稱',
    'matrixContactOrganisationLabel': '公司',
    'matrixContactJobTitleLabel': '職位名稱',
    'matrixContactPhoneLabel': '電話',
    'matrixContactMailLabel': '電子郵件',
    'matrixContactAddressLabel': '地址',
    'matrixContactNotesLabel': '備註',
    // Matrix Barcode Agenda Analysis
    'matrixAgendaNameEventLabel': '事件名稱',
    'matrixAgendaStartDateEventLabel': '開始',
    'matrixAgendaEndDateEventLabel': '結束',
    'matrixAgendaPlaceEventLabel': '地點',
    'matrixAgendaDescriptionEventLabel': '描述',
    // Matrix Barcode Phone Analysis
    'matrixPhoneTelNumberLabel': '電話',
    // Matrix Barcode Email Analysis
    'matrixEmailRecipientLabel': '收件人',
    'matrixEmailCcLabel': '副本',
    'matrixEmailBccLabel': '密件副本',
    'matrixSubjectLabel': '主旨',
    'matrixBodyLabel': '訊息',
    // Matrix Barcode Wi-Fi Analysis
    'matrixWifiSsidLabel': 'SSID',
    'matrixWifiPasswordLabel': '密碼',
    'matrixWifiEncryptionLabel': '加密',
    'matrixWifiIsHiddenLabel': '隱藏',
    'matrixWifiAnonymousIdentityLabel': '匿名身分',
    'matrixWifiIdentityLabel': '身分',
    'matrixWifiEapMethodLabel': 'Eap 方法',
    'matrixWifiPhase2MethodLabel': 'Phase 2 方法',
    // Matrix Barcode URL Analysis
    'matrixUriUrlLabel': 'URL',
    'matrixUriMaliciousLabel': '可能是惡意 URL…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    'matrixLocalisationLatitudeLabel': '緯度',
    'matrixLocalisationLongitudeLabel': '經度',
    'matrixLocalisationAltitudeLabel': '高度',
    'matrixLocalisationQueryLabel': '查詢',
    'matrixLocalisationButtonFindLocation': '從你的位置產生',
    'matrixLocalisationSearchCurrentPositionLabel': '搜尋目前位置…',
    'matrixLocalisationLocationDisabledLabel': '你的裝置定位似乎沒有被啟用。',
    // Barcode Description
    'barcodeIndustrialDescriptionLabel': '此條碼類型經常被使用於工業。',
    'barcodeCode39DescriptionLabel': 'Code 39 是一種用於紡織記號與西藥房藥品的條碼。它也用於軍事行業與汽車工業。',
    'barcodeCode93DescriptionLabel': 'Code 93 是一種用於軍事與汽車產業的條碼，也被 "Postes Canada" 用於編碼特殊交貨訊息。',
    'barcodeCode128DescriptionLabel': 'Code 128 是一種產業經常使用的條碼。它用於運輸產業和供應鏈中的產品識別。它也可用於汽車產業或西藥房的產品標示。Code 128 使用廣泛，也可以用在很多其他結尾。',
    'barcodeItfDescriptionLabel': 'Code ITF (Interleaved 2 of 5) 是一種主要用於貨物運輸的條碼。',
    'barcodeCodabarDescriptionLabel': 'Code Codabar 是設計用於點陣印表機讀取的條碼。現今，是很少用於其他營利的條碼類型，但仍被一些組織使用如圖書館。',
    'barcodeUpcADescriptionLabel': 'Code UPC-A (通用產品代碼) 是在美國與加拿大廣泛使用的條碼，用於辨認商店與商店中銷售的商品。它由 12 位數字所組成。',
    'barcodeUpcEDescriptionLabel': 'Code UPC-E (通用產品代碼) 是 UPC-A 代碼的壓縮條碼，主要用於美國和加拿大辨認商店與商店中銷售的商品。它用於太小而無法使用 UPC-A 的包裝。',
    'barcodeEan13DescriptionLabel': 'Code EAN-13 (歐洲商品條碼 13) 是一種廣泛用於辨識銷售在歐洲與世界上幾乎所有地方的產品的條碼。它由 13 位數字組成。',
    'barcodeEan8DescriptionLabel': 'Code EAN-8 (歐洲商品條碼 8) 是 EAN-13 代碼的壓縮條碼，用於辨識銷售在歐洲與世界上幾乎所有地方的產品的條碼。它用於太小而無法使用 EAN-13 的包裝。',
    // Barcode Composition
    'barcodeTextCompositionLabel': '文本',
    'barcodeTextNoSpecialCompositionLabel': '沒有特殊字符的文本',
    'barcodeTextUpperNoSpecialCompositionLabel': '沒有特殊字符的大寫文本',
    'barcodeDigitsCompositionLabel': '數字',
    'barcodeEvenDigitsCompositionLabel': '偶位數字',
    'barcode7Digits1CheckCompositionLabel': '7位數字 + 1位校驗',
    'barcode11Digits1CheckCompositionLabel': '11位數字 + 1位校驗',
    'barcode12Digits1CheckCompositionLabel': '12位數字 + 1位校驗',
    // Snackbar Feddbacks
    'snackBarMessagePermissionRefused': '你必須接受許可以使用此功能。',
    'snackBarMessageSaveBitmapOk': '圖片已儲存',
    'snackBarMessageSaveBitmapError': '圖片未被儲存… \n可能是儲存空間不足？',
    'snackBarMessageShareBitmapError': '分享組態時發生錯誤。',
    // Actions
    'actionsLabel': '功能',
    'intentChooserShareTitle': '分享…',
    'intentChooserMailTitle': '發送郵件…',
    'copyBarcodeLabel': '複製條碼',
    'copyLabel': '複製',
    'barcodeCopiedLabel': '條碼已複製',
    'barcodeSearchErrorLabel': 'URL 不支援',
    'barcodeSearchErrorNoCompatibleApplicationFound': '找不到相容的應用程式',
    'searchLabel': '搜尋',
    'actionTitleDialogLabel': '你想做什麼？',
    'actionGoToUrlLabel': '前往 URL',
    'actionWebSearchLabel': '在網路上搜尋',
    'actionProductSearchLabel': '搜尋',
    'actionSendMailLabel': '發送電子郵件',
    'actionSendSmsLabel': '發送簡訊',
    'actionCallPhoneLabel': '播打電話號碼',
    'actionAddToCalendar': '加入到行事曆',
    'actionAddToContacts': '加入到通訊綠',
    'actionShareVcfFile': '分享為 VCF',
    'actionShowLocation': '顯示位置',
    'actionOpenLink': '開啟連結',
    'actionModifyBarcode': '修改條碼',
    'actionModifyNotes': '修改備註',
    'apply': '應用',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    'errorBarcodeNoneCharacterMessage': '你必須在欄位中輸入正確的值。',
    'errorBarcodeNotANumberMessage': '條碼只能由數字組成。',
    'errorBarcodeWrongLengthMessage': '條碼要求的數字長度: ',
    'errorBarcodeWrongKeyMessage': '最後一位數 (驗證鍵) 應該是: ',
    'errorBarcodeEncodingIso88591ErrorMessage': '此條碼類型不支援特殊字元。',
    'errorBarcodeEncodingUsAsciiErrorMessage': '此條碼類型不支援特殊字元。',
    'errorBarcode93RegexErrorMessage': '"Code 93" 條碼類型可編碼 26 個大寫字母，10 個數字 (0–9) 以及8個特殊字元 « -, ., space, *, \$, /, +, % »。此條碼類型不能編碼小寫字母與其他特殊字元。',
    'errorBarcode39RegexErrorMessage': '"Code 39" 條碼類型可編碼 26 大寫字母，10 個數字 (0–9) 以及7個特殊字元 « -, ., space, \$, /, +, % »。此條碼類型不能編碼小寫字母與其他特殊字元。',
    'errorBarcodeCodabarRegexErrorMessage': '"Codabar" 條碼類型可編碼10個數字 (0–9) 以及6個特殊字元 « -, \$, :, /, ., + »。它也可包含字元 A, B, C 或 D 作為第一個與最後一個條碼字元，以指定字串的開頭和結尾。',
    'errorBarcodeItfErrorMessage': '"ITF" 條碼類型必須包含偶數個字元。',
    'errorBarcodeUpcENotStartWith0ErrorMessage': '"UPC-E" 條碼類型開頭必須是 0。',
    'errorBarcodeQrUrlFormatMessage': '網址的開頭必須是 "http://" 或 "https://"',
    'errorBarcodeQrPhoneNumberMissingMessage': '你必須輸入一個電話號碼',
    'errorBarcodeQrEmailMissingMessage': '你必須至少輸入一個欄位',
    'errorBarcodeQrLocalisationMissingMessage': '你必須告知經度和緯度',
    // Action Barcode Generated
    'barcodeCreatorConfirmTextLabel': '產生',
    'saveLabel': '儲存',
    'shareLabel': '分享',
    'shareImageLabel': '分享圖片',
    'shareTextLabel': '分享文字',
    'popupMessageConfirmationSaveImage': '儲存圖片？',
    'clipboardEmpty': '剪貼簿是空的。',
    // Barcode Image Editor
    // Form
    'qrCodeTextGeneratorHintTextInputEditText': '輸入文字…',
    'qrCodeTextGeneratorHintPhoneInputEditText': '輸入電話號碼…',
    'qrCodeTextGeneratorHintUrlInputEditText': '輸入網址…',
    'qrCodeTextInputEditTextHintMessage': '訊息...',
    // Contact Creator
    'qrCodeTypeNameGenerateFromContact': '從通訊錄產生',
    'qrCodeImportContactFromVcard': '從vCard產生',
    'qrCodeTextRadioButtonLabelM': '先生',
    'qrCodeTextRadioButtonLabelMrs': '女士',
    'qrCodeTextRadioButtonLabelMiss': '小姐',
    'qrCodeTextRadioButtonLabelNone': '無',
    'qrCodeTextInputEditTextHintName': '名稱',
    'qrCodeTextInputEditTextHintFirstName': '姓氏',
    'qrCodeTextInputEditTextHintWebSite': '網站',
    'qrCodeTextInputEditTextHintMail1': '郵件地址 1',
    'qrCodeTextInputEditTextHintMail2': '郵件地址 2',
    'qrCodeTextInputEditTextHintMail3': '郵件地址 3',
    'qrCodeTextInputEditTextHintPhone1': '電話號碼 1',
    'qrCodeTextInputEditTextHintPhone2': '電話號碼 2',
    'qrCodeTextInputEditTextHintPhone3': '電話號碼 3',
    'qrCodeTextInputEditTextHintStreetAddress': '街道地址',
    'qrCodeTextInputEditTextHintPostalCode': '郵遞區號',
    'qrCodeTextInputEditTextHintCity': '城市',
    'qrCodeTextInputEditTextHintCountry': '國家',
    'qrCodeTextInputEditTextHintRegion': '地區',
    'qrCodeTextInputEditTextHintNotes': '備註',
    'qrCodeSpinnerPromptNone': '無',
    'spinnerTypeMobile': '手機',
    'spinnerTypeFax': '傳真',
    'spinnerTypeHome': '住家',
    'spinnerTypeWork': '工作',
    'spinnerTypeOther': '其他',
    // EPC Creator
    'qrCodeTextInputEditTextHintEpcServiceTag': '服務標籤',
    'qrCodeTextInputEditTextHintEpcVersion': '版本',
    'qrCodeTextInputEditTextHintEpcCharacterSet': '字元集',
    'qrCodeTextInputEditTextHintEpcIdentification': '識別',
    'qrCodeTextInputEditTextHintEpcBic': 'BIC',
    'qrCodeTextInputEditTextHintEpcName': '名稱',
    'qrCodeTextInputEditTextHintEpcIban': 'IBAN',
    'qrCodeTextInputEditTextHintEpcAmount': '金額',
    'qrCodeTextInputEditTextHintEpcPurpose': '目的',
    'qrCodeTextInputEditTextHintEpcRemittanceRef': '匯款（參考）',
    'qrCodeTextInputEditTextHintEpcRemittanceText': '匯款（訊息）',
    'qrCodeTextInputEditTextHintEpcInformation': '資訊',
    'qrCodeTextInputEditTextEpcNameError': '「名稱」欄位是必須的',
    'qrCodeTextInputEditTextEpcIbanError': 'IBAN 不正確',
    'listBankEmptyMessage': '沒有項目…\n你還沒有產生一個 EPC QR Code。',
    // Mail Creator
    'qrCodeTextInputEditTextHintEmail': '電子郵件',
    'qrCodeTextInputEditTextHintEmailSubject': '主旨',
    // Geo Localisation Creator
    'qrCodeTextInputEditTextHintLocalisationLatitude': '緯度',
    'qrCodeTextInputEditTextHintLocalisationLongitude': '經度',
    'qrCodeTextInputEditTextHintLocalisationHeight': '高度',
    'qrCodeTextInputEditTextHintLocalisationRequest': '查詢',
    // Wifi Creator
    'qrCodeTextInputEditTextHintWifiSsid': 'SSID / 網路名稱',
    'qrCodeTextInputEditTextHintWifiPassword': '密碼',
    'qrCodeTextInputEditTextHintWifiHide': '隱藏',
    'spinnerWifiEncryptionWep': 'WEP',
    'spinnerWifiEncryptionWpa': 'WPA/WPA2',
    'spinnerWifiEncryptionSae': 'WPA3',
    'spinnerWifiEncryptionNone': '無密碼',
    // Event Creator
    'qrCodeTextInputEditTextHintAgendaEventName': '事件名稱',
    'qrCodeTextInputEditTextHintAgendaPlace': '地點',
    'qrCodeTextInputEditTextHintAgendaDescription': '描述',
    'checkBoxEventAllOfDay': '整日',
    'beginLabel': '開始',
    'endLabel': '結束',

    // URL
    // Custom search URL
    'customSearchUrls': '自訂搜尋網址',
    'customUrls': '自訂網址',
    'customSearchUrlsAddUrl': '新增網址',
    'customSearchUrlsModifyUrl': '修改網址',
    'customSearchUrlsList': '網址列表',
    'customSearchUrlsListIsEmptyMessage': '沒有項目…\n你尚未產生自訂網址。',
    'popupMessageConfirmationDeletedAllCustomUrls': '你想刪除所有自訂網址嗎？',
    'customUrlDeleted': '已刪除自訂網址！',
    'customUrlAdded': '已增加自訂網址！',
    'customUrlUpdated': '已更新自訂網址！',
    'customSearchUrlsAddInfo': '在網址中使用術語"{code}"。該術語將會在搜尋過程中被條碼的內容取代。',
    'examples': '例子: ',
    'customSearchUrlsErrorUrl': '網址中必須包含術語: {code}',
    'errorEmptyFields': '輸入欄位不得為空白。',
    'customSearchUrlsisDuplicated': '名稱已重複，請輸入其他名稱。',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    'preferencesDefault': '預設',
    // Appearance Settings
    'preferencesAppearanceTitle': '外觀',
    'preferencesThemeLabel': '背景顏色',
    'preferencesSwitchSystemThemeLabel': '系統背景',
    'preferencesSwitchLightThemeLabel': '淺色',
    'preferencesSwitchDarkThemeLabel': '深色',
    'preferencesColor': '主題顏色',
    'preferencesColorMaterialYou': '系統 Material You',
    'preferencesColorBlue': '藍色',
    'preferencesColorOrange': '橘色',
    'preferencesColorGreen': '綠色',
    'preferencesColorRed': '紅色',
    'preferencesColorPurple': '紫色',
    // Languages Settings
    'preferencesLanguagesTitle': '語言',
    'preferencesLanguagesChange': '變更語言',
    // Remote API
    // About Remote API
    // Scan Settings
    'preferencesScanTitle': '掃描',
    'preferencesSwitchScanAutoOpenWebsiteLabel': '自動打開網站',
    'preferencesSwitchScanContinuousScanLabel': '連續掃描',
    'preferencesSwitchScanVibrateLabel': '掃描震動',
    'preferencesSwitchScanBipLabel': '播放聲音',
    'preferencesSwitchScanScreenRotationLabel': '掃描期間禁用螢幕旋轉',
    'preferencesSwitchScanBarcodeCopiedLabel': '複製到剪貼簿',
    'preferencesSwitchScanUseFrontcameraLabel': '使用前鏡頭',
    // Barcode Generation Settings
    'preferencesBarcodeGenerationTitle': '條碼創建',
    // History settings-->
    'preferencesSwitchScanAddBarcodeToTheHistoryLabel': '加入掃描的條碼至歷史紀錄',
    'preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel': '加入創建的條碼至歷史紀錄',
    'preferencesSwitchHistorySaveDuplicatesLabel': '掃描或創建時保留重複項',
    // Search Engine Settings
    'preferencesSearchTitle': '搜尋',
    'preferencesSearchEngine': '搜尋引擎',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    'preferencesAboutTitle': '關於',
    'preferencesAboutOpenSourceLibrariesLabel': '開源許可證',
    'preferencesApplicationVersionLabel': '應用版本',
    'preferencesSourceCodeLabel': '原始碼',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}