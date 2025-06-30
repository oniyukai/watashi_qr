import 'package:watashi_qr/locale/en.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:watashi_qr/locale/language_key.dart';

typedef K = LanguageKey;

class ZhHant extends Language {
  ZhHant() : super(
    fallback: En(), const {
    // Permission Denied
    K.cameraPermissionDenied: '等待授權存取相機。',
    // AlertDialog
    K.closeDialogLabel: '關閉',
    K.yesLabel: '是',
    K.noLabel: '否',
    K.goToDialogLabel: '進入網站',
    K.error: '錯誤',
    // ImageView Description
    K.imageViewDescriptionFlag: '標誌',
    K.imageViewDescriptionLogo: '標示',
    K.imageViewDescriptionTypeIcon: '類型',
    K.imageViewDescriptionBarCode: '條碼',
    K.imageViewDescriptionIcon: '圖示',
    K.imageViewDescriptionProductFront: '產品圖片',
    K.imageViewDescriptionNutriscore: '營養分數',
    K.imageViewDescriptionNovaGroup: 'NOVA GROUP',
    K.imageViewDescriptionEcoScore: 'ECO SCORE',
    K.imageViewDescriptionBackground: '背景',
    K.imageViewDescriptionImage: '圖片',
    K.sliderDescriptionZoom: '縮放',
    // Menu Item
    K.titleScan: '掃描',
    K.titleHistory: '歷史紀錄',
    K.titleGenerate: '創建',
    K.titleSettings: '設定',
    K.titleQrCodeCreator: '創建 QR 圖碼',
    K.titleBarCodeCreator: '創建條碼',
    K.createQrFromClipboard: '從剪貼簿創建 QR 圖碼',
    K.informationLabel: '資訊',
    K.barcodeLabel: '條碼',
    K.downloadFromApiLabel: '從 API 下載',
    K.shareToThisAppLabel: '也可以在其他應用中分享到此程式。',
    K.menuMore: '更多',
    // Barcode Type
    K.barcodeQrCodeLabel: 'QR 圖碼',
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
    K.qrCodeTypeNameText: '文字',
    K.qrCodeTypeNameWebSite: '網站',
    K.qrCodeTypeNameContact: '聯絡人',
    K.qrCodeTypeNameMail: '郵件',
    K.qrCodeTypeNameSms: '簡訊',
    K.qrCodeTypeNamePhone: '電話號碼',
    K.qrCodeTypeNameLocation: '地理座標',
    K.qrCodeTypeNameEvent: '日程',
    K.qrCodeTypeNameWifi: 'Wi-Fi',
    K.qrCodeTypeNameApps: '應用程式',
    // Product Type
    K.barCodeTypeProduct: '產品代碼',
    K.barCodeTypeIndustrial: '工業代碼',
    K.barCodeTypeNameUnknown: '不詳',
    // Error Correction Level
    K.qrCodeErrorCorrectionLevelLabel: '錯誤修正等級',
    K.qrCodeErrorCorrectionLevelSettingsLabel: '錯誤修正等級（QR 圖碼）',
    K.qrCodeErrorCorrectionLevelNameLow: '低（~7%）',
    K.qrCodeErrorCorrectionLevelNameMedium: '中（~15%）',
    K.qrCodeErrorCorrectionLevelNameQuartile: '四分位數（~25%）',
    K.qrCodeErrorCorrectionLevelNameHigh: '高（~30%）',
    // History
    K.labelHistoryEmpty: '沒有歷史紀錄…',
    K.snackBarMessageItemDeleted: '產品已從歷史紀錄中刪除。',
    K.snackBarMessageItemsDeleted: '已從歷史記錄中刪除項目。',
    K.popupMessageConfirmationDeleteHistory: '刪除所有歷史紀錄？',
    K.popupMessageConfirmationDeleteSelectedItemsHistory: '刪除選取的項目？',
    K.menuItemHistoryDelete: '刪除歷史紀錄',
    K.menuItemHistoryDeleteFromHistory: '從歷史紀錄中刪除',
    K.menuItemHistoryRemovedFromHistory: '已從歷史紀錄中移除！',
    K.menuItemHistoryAddInHistory: '加入至歷史紀錄',
    K.menuItemHistoryAddedInHistory: '已加入至歷史紀錄！',
    K.menuItemHistoryAddFavorite: '添加到收藏夾',
    K.menuItemHistoryRemoveFavorite: '收藏夾中移出',
    K.deleteLabel: '刪除',
    K.cancelLabel: '取消',
    K.recordLabel: '儲存',
    // Export File
    K.exportLabel: '匯出',
    K.exportJsonLabel: '匯出為 JSON',
    K.importJsonLabel: '匯入 (JSON)',
    K.shareJsonLabel: '分享為 JSON',
    K.snackBarMessageFileExportSuccess: '檔案已儲存！',
    K.snackBarMessageFileExportError: '發生了錯誤！檔案未儲存。',
    K.snackBarMessageFileImportSuccess: '檔案已匯入！',
    K.snackBarMessageFileImportError: '發生了錯誤！檔案未匯入。',
    // CaptureActivity
    // BarcodeAnalysisActivity
    K.barcodeInformationSearchLabel: '搜尋中…',
    K.scanErrorLabel: '掃描時發生錯誤！',
    K.scanErrorShortInformationLabel: '搜尋資訊時發生錯誤！',
    K.barcodeScannedLabel: '%1s 已掃描！',
    K.barcodeFoundOnLabel: '發現 %1s！',
    K.barcodeNotFoundOnApiLabel: '沒有發現資訊 %1s。',
    K.noInternetPermission: '你沒有允許存取網路。',
    K.aboutBarcodeInformationLabel: '條碼資訊',
    K.aboutBarcodeLabel: '關於條碼',
    K.aboutBarcodeFormatLabel: '格式: ',
    K.aboutBarcodeContentLabel: '條碼: ',
    K.aboutBarcodeOriginLabel: '來源: ',
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
    K.barCodeContentLabel: '條碼內容',
    K.barCodeAnalysisLabel: '條碼分析',
    // Matrix Barcode Contact Analysis
    K.matrixContactNameLabel: '名稱',
    K.matrixContactOrganisationLabel: '公司',
    K.matrixContactJobTitleLabel: '職位名稱',
    K.matrixContactPhoneLabel: '電話',
    K.matrixContactMailLabel: '電子郵件',
    K.matrixContactAddressLabel: '地址',
    K.matrixContactNotesLabel: '備註',
    // Matrix Barcode Agenda Analysis
    K.matrixAgendaNameEventLabel: '事件名稱',
    K.matrixAgendaStartDateEventLabel: '開始',
    K.matrixAgendaEndDateEventLabel: '結束',
    K.matrixAgendaPlaceEventLabel: '地點',
    K.matrixAgendaDescriptionEventLabel: '描述',
    // Matrix Barcode Phone Analysis
    K.matrixPhoneTelNumberLabel: '電話',
    // Matrix Barcode Email Analysis
    K.matrixEmailRecipientLabel: '收件人',
    K.matrixEmailCcLabel: '副本',
    K.matrixEmailBccLabel: '密件副本',
    K.matrixSubjectLabel: '主旨',
    K.matrixBodyLabel: '訊息',
    // Matrix Barcode Wi-Fi Analysis
    K.matrixWifiSsidLabel: 'SSID',
    K.matrixWifiPasswordLabel: '密碼',
    K.matrixWifiEncryptionLabel: '加密',
    K.matrixWifiIsHiddenLabel: '隱藏',
    K.matrixWifiAnonymousIdentityLabel: '匿名身分',
    K.matrixWifiIdentityLabel: '身分',
    K.matrixWifiEapMethodLabel: 'Eap 方法',
    K.matrixWifiPhase2MethodLabel: 'Phase 2 方法',
    // Matrix Barcode URL Analysis
    K.matrixUriUrlLabel: 'URL',
    K.matrixUriMaliciousLabel: '可能是惡意 URL…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    K.matrixLocalisationLatitudeLabel: '緯度',
    K.matrixLocalisationLongitudeLabel: '經度',
    K.matrixLocalisationAltitudeLabel: '高度',
    K.matrixLocalisationQueryLabel: '查詢',
    K.matrixLocalisationButtonFindLocation: '從你的位置產生',
    K.matrixLocalisationSearchCurrentPositionLabel: '搜尋目前位置…',
    K.matrixLocalisationLocationDisabledLabel: '你的裝置定位似乎沒有被啟用。',
    // Barcode Description
    K.barcodeIndustrialDescriptionLabel: '此條碼類型經常被使用於工業。',
    K.barcodeCode39DescriptionLabel: 'Code 39 是一種用於紡織記號與西藥房藥品的條碼。它也用於軍事行業與汽車工業。',
    K.barcodeCode93DescriptionLabel: 'Code 93 是一種用於軍事與汽車產業的條碼，也被 "Postes Canada" 用於編碼特殊交貨訊息。',
    K.barcodeCode128DescriptionLabel: 'Code 128 是一種產業經常使用的條碼。它用於運輸產業和供應鏈中的產品識別。它也可用於汽車產業或西藥房的產品標示。Code 128 使用廣泛，也可以用在很多其他結尾。',
    K.barcodeItfDescriptionLabel: 'Code ITF (Interleaved 2 of 5) 是一種主要用於貨物運輸的條碼。',
    K.barcodeCodabarDescriptionLabel: 'Code Codabar 是設計用於點陣印表機讀取的條碼。現今，是很少用於其他營利的條碼類型，但仍被一些組織使用如圖書館。',
    K.barcodeUpcADescriptionLabel: 'Code UPC-A (通用產品代碼) 是在美國與加拿大廣泛使用的條碼，用於辨認商店與商店中銷售的商品。它由 12 位數字所組成。',
    K.barcodeUpcEDescriptionLabel: 'Code UPC-E (通用產品代碼) 是 UPC-A 代碼的壓縮條碼，主要用於美國和加拿大辨認商店與商店中銷售的商品。它用於太小而無法使用 UPC-A 的包裝。',
    K.barcodeEan13DescriptionLabel: 'Code EAN-13 (歐洲商品條碼 13) 是一種廣泛用於辨識銷售在歐洲與世界上幾乎所有地方的產品的條碼。它由 13 位數字組成。',
    K.barcodeEan8DescriptionLabel: 'Code EAN-8 (歐洲商品條碼 8) 是 EAN-13 代碼的壓縮條碼，用於辨識銷售在歐洲與世界上幾乎所有地方的產品的條碼。它用於太小而無法使用 EAN-13 的包裝。',
    // Barcode Composition
    K.barcodeTextCompositionLabel: '文本',
    K.barcodeTextNoSpecialCompositionLabel: '沒有特殊字符的文本',
    K.barcodeTextUpperNoSpecialCompositionLabel: '沒有特殊字符的大寫文本',
    K.barcodeDigitsCompositionLabel: '數字',
    K.barcodeEvenDigitsCompositionLabel: '偶位數字',
    K.barcode7Digits1CheckCompositionLabel: '7位數字 + 1位校驗',
    K.barcode11Digits1CheckCompositionLabel: '11位數字 + 1位校驗',
    K.barcode12Digits1CheckCompositionLabel: '12位數字 + 1位校驗',
    // Snackbar Feddbacks
    K.snackBarMessagePermissionRefused: '你必須接受許可以使用此功能。',
    K.snackBarMessageSaveBitmapOk: '圖片已儲存',
    K.snackBarMessageSaveBitmapError: '圖片未被儲存…',
    K.snackBarMessageShareBitmapError: '分享組態時發生錯誤。',
    // Actions
    K.actionsLabel: '功能',
    K.intentChooserShareTitle: '分享…',
    K.intentChooserMailTitle: '發送郵件…',
    K.copyBarcodeLabel: '複製條碼',
    K.copyLabel: '複製',
    K.barcodeCopiedLabel: '條碼已複製',
    K.barcodeSearchErrorLabel: 'URL 不支援',
    K.barcodeSearchErrorNoCompatibleApplicationFound: '找不到相容的應用程式',
    K.searchLabel: '搜尋',
    K.actionTitleDialogLabel: '你想做什麼？',
    K.actionGoToUrlLabel: '前往 URL',
    K.actionWebSearchLabel: '在網路上搜尋',
    K.actionProductSearchLabel: '搜尋',
    K.actionSendMailLabel: '發送電子郵件',
    K.actionSendSmsLabel: '發送簡訊',
    K.actionCallPhoneLabel: '播打電話號碼',
    K.actionAddToCalendar: '加入到行事曆',
    K.actionAddToContacts: '加入到通訊綠',
    K.actionShareVcfFile: '分享為 VCF',
    K.actionShowLocation: '顯示位置',
    K.actionOpenLink: '開啟連結',
    K.actionModifyBarcode: '修改條碼',
    K.actionModifyNotes: '修改備註',
    K.apply: '應用',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    K.errorBarcodeNoneCharacterMessage: '你必須在欄位中輸入正確的值。',
    K.errorBarcodeNotANumberMessage: '條碼只能由數字組成。',
    K.errorBarcodeWrongLengthMessage: '條碼要求的數字長度: ',
    K.errorBarcodeWrongKeyMessage: '最後一位數 (驗證鍵) 應該是: ',
    K.errorBarcodeEncodingIso88591ErrorMessage: '此條碼類型不支援特殊字元。',
    K.errorBarcodeEncodingUsAsciiErrorMessage: '此條碼類型不支援特殊字元。',
    K.errorBarcode93RegexErrorMessage: '"Code 93" 條碼類型可編碼 26 個大寫字母，10 個數字 (0–9) 以及7個特殊字元 « -, ., space, \$, /, +, % »。此條碼類型不能編碼小寫字母與其他特殊字元。',
    K.errorBarcode39RegexErrorMessage: '"Code 39" 條碼類型可編碼 26 個大寫字母，10 個數字 (0–9) 以及7個特殊字元 « -, ., space, \$, /, +, % »。此條碼類型不能編碼小寫字母與其他特殊字元。',
    K.errorBarcodeCodabarRegexErrorMessage: '"Codabar" 條碼類型可編碼10個數字 (0–9) 以及6個特殊字元 « -, \$, :, /, ., + »。它也可包含字元 A, B, C 或 D 作為第一個與最後一個條碼字元，以指定字串的開頭和結尾。',
    K.errorBarcodeItfErrorMessage: '"ITF" 條碼類型必須包含偶數個字元。',
    K.errorBarcodeUpcENotStartWith0ErrorMessage: '"UPC-E" 條碼類型開頭必須是 0。',
    K.errorBarcodeQrUrlFormatMessage: '網址的開頭必須是 "http://" 或 "https://"',
    K.errorBarcodeQrPhoneNumberMissingMessage: '你必須輸入一個電話號碼',
    K.errorBarcodeQrEmailMissingMessage: '你必須至少輸入一個欄位',
    K.errorBarcodeQrLocalisationMissingMessage: '你必須告知經度和緯度',
    // Action Barcode Generated
    K.barcodeCreatorConfirmTextLabel: '產生',
    K.saveLabel: '儲存',
    K.shareLabel: '分享',
    K.shareImageLabel: '分享圖片',
    K.shareTextLabel: '分享文字',
    K.popupMessageConfirmationSaveImage: '儲存圖片？',
    K.clipboardEmpty: '剪貼簿是空的。',
    // Barcode Image Editor
    // Form
    K.qrCodeTextGeneratorHintTextInputEditText: '輸入文字…',
    K.qrCodeTextGeneratorHintPhoneInputEditText: '輸入電話號碼…',
    K.qrCodeTextGeneratorHintUrlInputEditText: '輸入網址…',
    K.qrCodeTextInputEditTextHintMessage: '訊息...',
    // Contact Creator
    K.qrCodeTypeNameGenerateFromContact: '從通訊錄產生',
    K.qrCodeImportContactFromVcard: '從vCard產生',
    K.qrCodeTextRadioButtonLabelM: '先生',
    K.qrCodeTextRadioButtonLabelMrs: '女士',
    K.qrCodeTextRadioButtonLabelMiss: '小姐',
    K.qrCodeTextRadioButtonLabelNone: '無',
    K.qrCodeTextInputEditTextHintName: '名稱',
    K.qrCodeTextInputEditTextHintFirstName: '姓氏',
    K.qrCodeTextInputEditTextHintWebSite: '網站',
    K.qrCodeTextInputEditTextHintMail1: '郵件地址 1',
    K.qrCodeTextInputEditTextHintMail2: '郵件地址 2',
    K.qrCodeTextInputEditTextHintMail3: '郵件地址 3',
    K.qrCodeTextInputEditTextHintPhone1: '電話號碼 1',
    K.qrCodeTextInputEditTextHintPhone2: '電話號碼 2',
    K.qrCodeTextInputEditTextHintPhone3: '電話號碼 3',
    K.qrCodeTextInputEditTextHintStreetAddress: '街道地址',
    K.qrCodeTextInputEditTextHintPostalCode: '郵遞區號',
    K.qrCodeTextInputEditTextHintCity: '城市',
    K.qrCodeTextInputEditTextHintCountry: '國家',
    K.qrCodeTextInputEditTextHintRegion: '地區',
    K.qrCodeTextInputEditTextHintNotes: '備註',
    K.qrCodeSpinnerPromptNone: '無',
    K.spinnerTypeMobile: '手機',
    K.spinnerTypeFax: '傳真',
    K.spinnerTypeHome: '住家',
    K.spinnerTypeWork: '工作',
    K.spinnerTypeOther: '其他',
    // EPC Creator
    // Mail Creator
    K.qrCodeTextInputEditTextHintEmail: '電子郵件',
    K.qrCodeTextInputEditTextHintEmailSubject: '主旨',
    // Geo Localisation Creator
    K.qrCodeTextInputEditTextHintLocalisationLatitude: '緯度',
    K.qrCodeTextInputEditTextHintLocalisationLongitude: '經度',
    K.qrCodeTextInputEditTextHintLocalisationHeight: '高度',
    K.qrCodeTextInputEditTextHintLocalisationRequest: '查詢',
    // Wifi Creator
    K.qrCodeTextInputEditTextHintWifiSsid: 'SSID / 網路名稱',
    K.qrCodeTextInputEditTextHintWifiPassword: '密碼',
    K.qrCodeTextInputEditTextHintWifiHide: '隱藏',
    K.spinnerWifiEncryptionWep: 'WEP',
    K.spinnerWifiEncryptionWpa: 'WPA/WPA2',
    K.spinnerWifiEncryptionSae: 'WPA3',
    K.spinnerWifiEncryptionNone: '無密碼',
    // Event Creator
    K.qrCodeTextInputEditTextHintAgendaEventName: '事件名稱',
    K.qrCodeTextInputEditTextHintAgendaPlace: '地點',
    K.qrCodeTextInputEditTextHintAgendaDescription: '描述',
    K.checkBoxEventAllOfDay: '整日',
    K.beginLabel: '開始',
    K.endLabel: '結束',
    // URL
    // Custom search URL
    K.customSearchUrls: '自訂搜尋網址',
    K.customUrls: '自訂網址',
    K.customSearchUrlsAddUrl: '新增網址',
    K.customSearchUrlsModifyUrl: '修改網址',
    K.customSearchUrlsList: '網址列表',
    K.customSearchUrlsListIsEmptyMessage: '沒有項目…\n你尚未產生自訂網址。',
    K.popupMessageConfirmationDeletedAllCustomUrls: '你想刪除所有自訂網址嗎？',
    K.customUrlDeleted: '已刪除自訂網址！',
    K.customUrlAdded: '已增加自訂網址！',
    K.customUrlUpdated: '已更新自訂網址！',
    K.customSearchUrlsAddInfo: '在網址中使用術語"{code}"。該術語將會在搜尋過程中被條碼的內容取代。',
    K.examples: '例子: ',
    K.customSearchUrlsErrorUrl: '網址中必須包含術語: {code}',
    K.errorEmptyFields: '輸入欄位不得為空白。',
    K.customSearchUrlsisDuplicated: '名稱已重複，請輸入其他名稱。',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    K.preferencesDefault: '預設',
    // Appearance Settings
    K.preferencesAppearanceTitle: '外觀',
    K.preferencesThemeLabel: '背景顏色',
    K.preferencesSwitchSystemThemeLabel: '系統背景',
    K.preferencesSwitchLightThemeLabel: '淺色',
    K.preferencesSwitchDarkThemeLabel: '深色',
    K.preferencesColor: '主題顏色',
    K.preferencesColorMaterialYou: '系統 Material You',
    K.preferencesColorBlue: '藍色',
    K.preferencesColorOrange: '橘色',
    K.preferencesColorGreen: '綠色',
    K.preferencesColorRed: '紅色',
    K.preferencesColorPurple: '紫色',
    // Languages Settings
    K.preferencesLanguagesTitle: '語言',
    K.preferencesLanguagesChange: '變更語言',
    // Remote API
    // About Remote API
    // Scan Settings
    K.preferencesScanTitle: '掃描',
    K.preferencesSwitchScanAutoOpenWebsiteLabel: '自動打開網站',
    K.preferencesSwitchScanContinuousScanLabel: '連續掃描',
    K.preferencesSwitchScanVibrateLabel: '掃描震動',
    K.preferencesSwitchScanBipLabel: '播放聲音',
    K.preferencesSwitchScanScreenRotationLabel: '掃描期間禁用螢幕旋轉',
    K.preferencesSwitchScanBarcodeCopiedLabel: '複製到剪貼簿',
    K.preferencesSwitchScanUseFrontcameraLabel: '使用前鏡頭',
    // Barcode Generation Settings
    K.preferencesBarcodeGenerationTitle: '條碼創建',
    // History settings-->
    K.preferencesSwitchScanAddBarcodeToTheHistoryLabel: '加入掃描的條碼至歷史紀錄',
    K.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel: '加入創建的條碼至歷史紀錄',
    K.preferencesSwitchHistorySaveDuplicatesLabel: '掃描或創建時保留重複項',
    // Search Engine Settings
    K.preferencesSearchTitle: '搜尋',
    K.preferencesSearchEngine: '搜尋引擎',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    K.preferencesAboutTitle: '關於',
    K.preferencesAboutOpenSourceLibrariesLabel: '開源許可證',
    K.preferencesApplicationVersionLabel: '應用版本',
    K.preferencesSourceCodeLabel: '原始碼',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}