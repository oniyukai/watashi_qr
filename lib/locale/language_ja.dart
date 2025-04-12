import 'language.dart';
import 'language_en.dart'; // 必要に応じて英語をフォールバックとして使用

class LanguageJa extends Language {
  LanguageJa() : super(
    fallbackLanguage: LanguageEn(), const { // フォールバック言語を英語に設定
    // Permission Denied
    'cameraPermissionDenied': 'カメラへのアクセスが許可されるのを待っています。',
    // AlertDialog
    'closeDialogLabel': '閉じる',
    'yesLabel': 'はい',
    'noLabel': 'いいえ',
    'goToDialogLabel': 'ウェブサイトへ移動',
    'error': 'エラー',
    // ImageView Description
    'imageViewDescriptionFlag': 'フラグ',
    'imageViewDescriptionLogo': 'ロゴ',
    'imageViewDescriptionTypeIcon': 'タイプ',
    'imageViewDescriptionBarCode': 'バーコード',
    'imageViewDescriptionIcon': 'アイコン',
    'imageViewDescriptionProductFront': '製品画像',
    'imageViewDescriptionNutriscore': '栄養スコア',
    'imageViewDescriptionNovaGroup': 'NOVAグループ',
    'imageViewDescriptionEcoScore': 'ECOスコア',
    'imageViewDescriptionBackground': '背景',
    'imageViewDescriptionImage': '画像',
    'sliderDescriptionZoom': 'ズーム',
    // Menu Item
    'titleScan': 'スキャン',
    'titleHistory': '履歴',
    'titleGenerate': '生成',
    'titleSettings': '設定',
    'titleQrCodeCreator': 'QRコードを作成',
    'titleBarCodeCreator': 'バーコードを作成',
    'createQrFromClipboard': 'クリップボードからQRコードを作成',
    'informationLabel': '情報',
    'barcodeLabel': 'バーコード',
    'downloadFromApiLabel': 'APIからダウンロード',
    'shareToThisAppLabel': '他のアプリからこのアプリへ共有することもできます。',
    'menuMore': 'その他',
    // Barcode Type
    'barcodeQrCodeLabel': 'QRコード',
    'barcodeDataMatrixLabel': 'データマトリックス',
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
    'qrCodeTypeNameText': 'テキスト',
    'qrCodeTypeNameWebSite': 'ウェブサイト',
    'qrCodeTypeNameContact': '連絡先',
    'qrCodeTypeNameMail': 'メール',
    'qrCodeTypeNameSms': 'SMS',
    'qrCodeTypeNamePhone': '電話番号',
    'qrCodeTypeNameGeographicCoordinates': '地理座標',
    'qrCodeTypeNameAgenda': '予定',
    'qrCodeTypeNameWifi': 'Wi-Fi',
    'qrCodeTypeNameApps': 'アプリ',
    // Product Type
    'barCodeTypeProduct': '製品コード',
    'barCodeTypeIndustrial': '工業コード',
    'barCodeTypeNameUnknown': '不明',
    // Error Correction Level
    'qrCodeErrorCorrectionLevelLabel': '誤り訂正レベル',
    'qrCodeErrorCorrectionLevelSettingsLabel': '誤り訂正レベル (QRコード)',
    'qrCodeErrorCorrectionLevelNameLow': '低 (~7%)',
    'qrCodeErrorCorrectionLevelNameMedium': '中 (~15%)',
    'qrCodeErrorCorrectionLevelNameQuartile': '四分位 (~25%)',
    'qrCodeErrorCorrectionLevelNameHigh': '高 (~30%)',
    // History
    'labelHistoryEmpty': '履歴はありません…',
    'snackBarMessageItemDeleted': '製品を履歴から削除しました。',
    'snackBarMessageItemsDeleted': '履歴からアイテムを削除しました。',
    'popupMessageConfirmationDeleteHistory': 'すべての履歴を削除しますか？',
    'popupMessageConfirmationDeleteSelectedItemsHistory': '選択したアイテムを削除しますか？',
    'menuItemHistoryDelete': '履歴を削除',
    'menuItemHistoryDeleteFromHistory': '履歴から削除',
    'menuItemHistoryRemovedFromHistory': '履歴から削除しました！',
    'menuItemHistoryAddInHistory': '履歴に追加',
    'menuItemHistoryAddedInHistory': '履歴に追加しました！',
    'menuItemHistoryAddFavorite': 'お気に入りに追加',
    'menuItemHistoryRemoveFavorite': 'お気に入りから削除',
    'deleteLabel': '削除',
    'cancelLabel': 'キャンセル',
    'recordLabel': '保存',
    // Export File
    'exportLabel': 'エクスポート',
    'exportJsonLabel': 'JSONとしてエクスポート',
    'importJsonLabel': 'インポート (JSON)',
    'snackBarMessageFileExportSuccess': 'ファイルを保存しました！',
    'snackBarMessageFileExportError': 'エラーが発生しました！ファイルを保存できませんでした。',
    'snackBarMessageFileImportSuccess': 'ファイルをインポートしました！',
    'snackBarMessageFileImportError': 'エラーが発生しました！ファイルをインポートできませんでした。',
    // CaptureActivity
    // BarcodeAnalysisActivity
    'barcodeInformationSearchLabel': '検索中…',
    'scanErrorLabel': 'スキャン中にエラーが発生しました！',
    'scanErrorShortInformationLabel': '情報の検索中にエラーが発生しました！',
    'barcodeScannedLabel': '%1s をスキャンしました！',
    'barcodeFoundOnLabel': '%1s で見つかりました！',
    'barcodeNotFoundOnApiLabel': '%1s に関する情報は見つかりませんでした。',
    'noInternetPermission': 'インターネットへのアクセスが許可されていません。',
    'aboutBarcodeInformationLabel': 'バーコード情報',
    'aboutBarcodeLabel': 'バーコードについて',
    'aboutBarcodeFormatLabel': '形式: ',
    'aboutBarcodeContentLabel': 'バーコード: ',
    'aboutBarcodeOriginLabel': 'ソース: ',
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
    'barCodeContentLabel': 'バーコードの内容',
    'barCodeAnalysisLabel': 'バーコード分析',
    // Matrix Barcode Contact Analysis
    'matrixContactNameLabel': '名前',
    'matrixContactOrganisationLabel': '組織',
    'matrixContactJobTitleLabel': '役職',
    'matrixContactPhoneLabel': '電話',
    'matrixContactMailLabel': 'メール',
    'matrixContactAddressLabel': '住所',
    'matrixContactNotesLabel': '備考',
    // Matrix Barcode Agenda Analysis
    'matrixAgendaNameEventLabel': 'イベント名',
    'matrixAgendaStartDateEventLabel': '開始',
    'matrixAgendaEndDateEventLabel': '終了',
    'matrixAgendaPlaceEventLabel': '場所',
    'matrixAgendaDescriptionEventLabel': '説明',
    // Matrix Barcode Phone Analysis
    'matrixPhoneTelNumberLabel': '電話',
    // Matrix Barcode Email Analysis
    'matrixEmailRecipientLabel': '受信者',
    'matrixEmailCcLabel': 'CC',
    'matrixEmailBccLabel': 'BCC',
    'matrixSubjectLabel': '件名',
    'matrixBodyLabel': 'メッセージ',
    // Matrix Barcode Wi-Fi Analysis
    'matrixWifiSsidLabel': 'SSID',
    'matrixWifiPasswordLabel': 'パスワード',
    'matrixWifiEncryptionLabel': '暗号化',
    'matrixWifiIsHiddenLabel': '非表示',
    'matrixWifiAnonymousIdentityLabel': '匿名ID',
    'matrixWifiIdentityLabel': 'ID',
    'matrixWifiEapMethodLabel': 'Eap方式',
    'matrixWifiPhase2MethodLabel': 'Phase 2 方式',
    // Matrix Barcode URL Analysis
    'matrixUriUrlLabel': 'URL',
    'matrixUriMaliciousLabel': 'URLは悪意のある可能性があります…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    'matrixLocalisationLatitudeLabel': '緯度',
    'matrixLocalisationLongitudeLabel': '経度',
    'matrixLocalisationAltitudeLabel': '高度',
    'matrixLocalisationQueryLabel': 'クエリ',
    'matrixLocalisationButtonFindLocation': '現在地から生成',
    'matrixLocalisationSearchCurrentPositionLabel': '現在地を検索中…',
    'matrixLocalisationLocationDisabledLabel': 'デバイスの位置情報が有効になっていないようです。',
    // Barcode Description
    'barcodeIndustrialDescriptionLabel': 'このタイプのバーコードは、多くの場合、業界で使用されます。',
    'barcodeCode39DescriptionLabel': 'Code 39は、繊維のマーキングや薬局の薬で使用されるバーコードです。 軍事部門や自動車産業でも使用されています。',
    'barcodeCode93DescriptionLabel': 'Code 93は、軍事部門や自動車産業で使用されるバーコードであり、「Postes Canada」が特別な配達情報をエンコードするためにも使用しています。',
    'barcodeCode128DescriptionLabel': 'Code 128は、業界でよく使用されるバーコードです。 輸送業界やサプライチェーンの製品識別に使用されています。 自動車業界や薬局の製品マーキングにも使用できます。 Code 128は広く使用されており、他の多くの用途にも使用できます。',
    'barcodeItfDescriptionLabel': 'Code ITF（Interleaved 2 of 5）は、主に商品の出荷に使用されるバーコードです。',
    'barcodeCodabarDescriptionLabel': 'Code Codabarは、ドットマトリックスプリンターで読み取るように設計されたバーコードです。 現在、Codabarは他のバーコードタイプの利点のためにほとんど使用されていませんが、図書館などの一部の組織ではまだ使用されています。',
    'barcodeUpcADescriptionLabel': 'Code UPC-A（Universal Product Code）は、米国とカナダで広く使用されているバーコードで、店舗やショップで販売されている製品を識別するために使用されます。 12桁で構成されています。',
    'barcodeUpcEDescriptionLabel': 'Code UPC-E（Universal Product Code）は、主に米国とカナダで店舗やショップで販売されている製品を識別するために使用される、Code UPC-Aの凝縮されたバーコードです。 UPC-Aコードを受け取るには小さすぎるパッケージで使用されます。',
    'barcodeEan13DescriptionLabel': 'Code EAN-13（European Article Numbering 13）は、ヨーロッパおよび世界のほぼすべての地域で店舗やショップで販売されている製品を識別するために広く使用されているバーコードです。 13桁で構成されています。',
    'barcodeEan8DescriptionLabel': 'Code EAN-8（European Article Numbering 8）は、ヨーロッパおよび世界のほぼすべての地域で店舗やショップで販売されている製品を識別するために使用される、Code EAN-13の凝縮されたバーコードです。 EAN-13コードを受け取るには小さすぎるパッケージで使用されます。',
    // Barcode Composition
    'barcodeTextCompositionLabel': 'テキスト',
    'barcodeTextNoSpecialCompositionLabel': '特殊文字なしのテキスト',
    'barcodeTextUpperNoSpecialCompositionLabel': '特殊文字なしの大文字テキスト',
    'barcodeDigitsCompositionLabel': '数字',
    'barcodeEvenDigitsCompositionLabel': '偶数',
    'barcode7Digits1CheckCompositionLabel': '7桁 + 1チェック',
    'barcode11Digits1CheckCompositionLabel': '11桁 + 1チェック',
    'barcode12Digits1CheckCompositionLabel': '12桁 + 1チェック',
    // Snackbar Feddbacks
    'snackBarMessagePermissionRefused': 'この機能を使用するには、許可を受け入れる必要があります。',
    'snackBarMessageSaveBitmapOk': '画像を保存しました',
    'snackBarMessageSaveBitmapError': '画像を保存できませんでした…\nメモリ不足ですか？',
    'snackBarMessageShareBitmapError': '共有構成中にエラーが発生しました。',
    // Actions
    'actionsLabel': 'アクション',
    'intentChooserShareTitle': '共有…',
    'intentChooserMailTitle': 'メールを送信…',
    'copyBarcodeLabel': 'バーコードをコピー',
    'copyLabel': 'コピー',
    'barcodeCopiedLabel': 'バーコードをコピーしました',
    'barcodeSearchErrorLabel': 'サポートされていないURL',
    'barcodeSearchErrorNoCompatibleApplicationFound': '互換性のあるアプリケーションが見つかりません',
    'searchLabel': '検索',
    'actionTitleDialogLabel': '何をしたいですか？',
    'actionGoToUrlLabel': 'URLへ移動',
    'actionWebSearchLabel': 'ウェブで検索',
    'actionProductSearchLabel': '検索',
    'actionSendMailLabel': 'メールを送信',
    'actionSendSmsLabel': 'SMSを送信',
    'actionCallPhoneLabel': '電話番号をかける',
    'actionAddToCalendar': 'カレンダーに追加',
    'actionAddToContacts': '連絡先に追加',
    'actionShareVcfFile': 'VCFとして共有',
    'actionShowLocation': '場所を表示',
    'actionOpenLink': 'リンクを開く',
    'actionModifyBarcode': 'バーコードを修正',
    'actionModifyNotes': 'メモを修正',
    'apply': '適用',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    'errorBarcodeNoneCharacterMessage': '入力フィールドに正しい値を入力する必要があります。',
    'errorBarcodeNotANumberMessage': 'バーコードは数字のみで構成されている必要があります。',
    'errorBarcodeWrongLengthMessage': 'バーコードに必要な桁数: ',
    'errorBarcodeWrongKeyMessage': '最後の桁（チェックディジット）は次のようである必要があります: ',
    'errorBarcodeEncodingIso88591ErrorMessage': 'このバーコードタイプでは特殊文字はサポートされていません。',
    'errorBarcodeEncodingUsAsciiErrorMessage': 'このバーコードタイプでは特殊文字はサポートされていません。',
    'errorBarcode93RegexErrorMessage': '"Code 93"バーコードタイプは、26の大文字、10桁（0〜9）、および8つの特殊文字« -, ., space, *, \$, /, +, % »をコード化できます。 小文字およびその他の特殊文字は、このバーコードタイプではコード化できません。',
    'errorBarcode39RegexErrorMessage': '"Code 39"バーコードタイプは、26の大文字、10桁（0〜9）、および7つの特殊文字« -, ., space, \$, /, +, % »をコード化できます。 小文字およびその他の特殊文字は、このバーコードタイプではコード化できません。',
    'errorBarcodeCodabarRegexErrorMessage': '"Codabar"バーコードタイプは、10桁（0〜9）と6つの特殊文字« -, \$, :, /, ., + »をコード化できます。 文字列の始まりと終わりを指定するために、最初と最後のバーコード文字として文字A、B、C、またはDを含めることもできます。',
    'errorBarcodeItfErrorMessage': '"ITF"バーコードタイプには、偶数の文字が含まれている必要があります。',
    'errorBarcodeUpcENotStartWith0ErrorMessage': '"UPC-E"バーコードタイプは0で始まる必要があります。',
    'errorBarcodeQrUrlFormatMessage': 'ウェブアドレスは「http://」または「https://」で始まる必要があります',
    'errorBarcodeQrPhoneNumberMissingMessage': '電話番号を入力する必要があります',
    'errorBarcodeQrEmailMissingMessage': '少なくとも1つの入力フィールドを入力する必要があります',
    'errorBarcodeQrLocalisationMissingMessage': '緯度と経度を入力する必要があります',
    // Action Barcode Generated
    'barcodeCreatorConfirmTextLabel': '生成',
    'saveLabel': '保存',
    'shareLabel': '共有',
    'shareImageLabel': '画像を共有',
    'shareTextLabel': 'テキストを共有',
    'popupMessageConfirmationSaveImage': '画像を保存しますか？',
    'clipboardEmpty': 'クリップボードは空です。',
    // Barcode Image Editor
    // Form
    'qrCodeTextGeneratorHintTextInputEditText': 'テキストを入力…',
    'qrCodeTextGeneratorHintPhoneInputEditText': '電話番号を入力…',
    'qrCodeTextGeneratorHintUrlInputEditText': 'ウェブアドレスを入力…',
    'qrCodeTextInputEditTextHintMessage': 'メッセージ...',
    // Contact Creator
    'qrCodeTypeNameGenerateFromContact': '連絡先から生成',
    'qrCodeImportContactFromVcard': 'vCardから生成',
    'qrCodeTextRadioButtonLabelM': '様',
    'qrCodeTextRadioButtonLabelMrs': '様',
    'qrCodeTextRadioButtonLabelMiss': '様',
    'qrCodeTextRadioButtonLabelNone': 'なし',
    'qrCodeTextInputEditTextHintName': '名前',
    'qrCodeTextInputEditTextHintFirstName': '名',
    'qrCodeTextInputEditTextHintWebSite': 'ウェブサイト',
    'qrCodeTextInputEditTextHintMail1': 'メールアドレス 1',
    'qrCodeTextInputEditTextHintMail2': 'メールアドレス 2',
    'qrCodeTextInputEditTextHintMail3': 'メールアドレス 3',
    'qrCodeTextInputEditTextHintPhone1': '電話番号 1',
    'qrCodeTextInputEditTextHintPhone2': '電話番号 2',
    'qrCodeTextInputEditTextHintPhone3': '電話番号 3',
    'qrCodeTextInputEditTextHintStreetAddress': '住所',
    'qrCodeTextInputEditTextHintPostalCode': '郵便番号',
    'qrCodeTextInputEditTextHintCity': '市区町村',
    'qrCodeTextInputEditTextHintCountry': '国',
    'qrCodeTextInputEditTextHintRegion': '都道府県',
    'qrCodeTextInputEditTextHintNotes': '備考',
    'qrCodeSpinnerPromptNone': 'なし',
    'spinnerTypeMobile': '携帯',
    'spinnerTypeFax': 'FAX',
    'spinnerTypeHome': '自宅',
    'spinnerTypeWork': '職場',
    'spinnerTypeOther': 'その他',
    // EPC Creator
    'qrCodeTextInputEditTextHintEpcServiceTag': 'サービス・タグ',
    'qrCodeTextInputEditTextHintEpcVersion': 'バージョン',
    'qrCodeTextInputEditTextHintEpcCharacterSet': '文字セット',
    'qrCodeTextInputEditTextHintEpcIdentification': '識別',
    'qrCodeTextInputEditTextHintEpcBic': 'BIC',
    'qrCodeTextInputEditTextHintEpcName': '名前',
    'qrCodeTextInputEditTextHintEpcIban': 'IBAN',
    'qrCodeTextInputEditTextHintEpcAmount': '金額',
    'qrCodeTextInputEditTextHintEpcPurpose': '目的',
    'qrCodeTextInputEditTextHintEpcRemittanceRef': '送金（参照）',
    'qrCodeTextInputEditTextHintEpcRemittanceText': '送金（メッセージ）',
    'qrCodeTextInputEditTextHintEpcInformation': '情報',
    'qrCodeTextInputEditTextEpcNameError': '「名前」フィールドは必須です',
    'qrCodeTextInputEditTextEpcIbanError': 'IBANが正しくありません',
    'listBankEmptyMessage': 'アイテムはありません…\nEPC QRコードをまだ生成していません。',
    // Mail Creator
    'qrCodeTextInputEditTextHintEmail': 'メール',
    'qrCodeTextInputEditTextHintEmailSubject': '件名',
    // Geo Localisation Creator
    'qrCodeTextInputEditTextHintLocalisationLatitude': '緯度',
    'qrCodeTextInputEditTextHintLocalisationLongitude': '経度',
    'qrCodeTextInputEditTextHintLocalisationHeight': '高度',
    'qrCodeTextInputEditTextHintLocalisationRequest': 'クエリ',
    // Wifi Creator
    'qrCodeTextInputEditTextHintWifiSsid': 'SSID / ネットワーク名',
    'qrCodeTextInputEditTextHintWifiPassword': 'パスワード',
    'qrCodeTextInputEditTextHintWifiHide': '非表示',
    'spinnerWifiEncryptionWep': 'WEP',
    'spinnerWifiEncryptionWpa': 'WPA/WPA2',
    'spinnerWifiEncryptionSae': 'WPA3',
    'spinnerWifiEncryptionNone': 'パスワードなし',
    // Event Creator
    'qrCodeTextInputEditTextHintAgendaEventName': 'イベント名',
    'qrCodeTextInputEditTextHintAgendaPlace': '場所',
    'qrCodeTextInputEditTextHintAgendaDescription': '説明',
    'checkBoxEventAllOfDay': '終日',
    'beginLabel': '開始',
    'endLabel': '終了',

    // URL
    // Custom search URL
    'customSearchUrls': 'カスタム検索URL',
    'customUrls': 'カスタムURL',
    'customSearchUrlsAddUrl': 'URLを追加',
    'customSearchUrlsModifyUrl': 'URLを修正',
    'customSearchUrlsList': 'URLリスト',
    'customSearchUrlsListIsEmptyMessage': 'アイテムはありません…\nカスタムURLをまだ生成していません。',
    'popupMessageConfirmationDeletedAllCustomUrls': 'すべてのカスタムURLを削除しますか？',
    'customUrlDeleted': 'カスタムURLを削除しました！',
    'customUrlAdded': 'カスタムURLを追加しました！',
    'customUrlUpdated': 'カスタムURLを更新しました！',
    'customSearchUrlsAddInfo': 'URLで「{code}」という用語を使用します。 この用語は、検索中にバーコードの内容に置き換えられます。',
    'examples': '例：',
    'customSearchUrlsErrorUrl': 'URLに「{code}」という用語が含まれている必要があります。',
    'errorEmptyFields': '入力フィールドは空にできません。',
    'customSearchUrlsisDuplicated': '名前が重複しています。別の名前を入力してください。',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    'preferencesDefault': 'デフォルト',
    // Appearance Settings
    'preferencesAppearanceTitle': '外観',
    'preferencesThemeLabel': 'テーマ',
    'preferencesSwitchSystemThemeLabel': 'システムに従う',
    'preferencesSwitchLightThemeLabel': 'ライト',
    'preferencesSwitchDarkThemeLabel': 'ダーク',
    'preferencesColor': 'メインカラー',
    'preferencesColorMaterialYou': 'システム (Material You)',
    'preferencesColorBlue': '青',
    'preferencesColorOrange': 'オレンジ',
    'preferencesColorGreen': '緑',
    'preferencesColorRed': '赤',
    'preferencesColorPurple': '紫',
    // Languages Settings
    'preferencesLanguagesTitle': '言語',
    'preferencesLanguagesChange': '言語を変更',
    // Remote API
    // About Remote API
    // Scan Settings
    'preferencesScanTitle': 'スキャン',
    'preferencesSwitchScanAutoOpenWebsiteLabel': '自動的にウェブサイトを開く',
    'preferencesSwitchScanContinuousScanLabel': '連続スキャン',
    'preferencesSwitchScanVibrateLabel': 'スキャン時に振動',
    'preferencesSwitchScanBipLabel': 'スキャン時に音を出す',
    'preferencesSwitchScanScreenRotationLabel': 'スキャン中の画面回転を無効にする',
    'preferencesSwitchScanBarcodeCopiedLabel': 'スキャンしたバーコードをコピー',
    'preferencesSwitchScanUseFrontcameraLabel': 'フロントカメラを使用',
    // Barcode Generation Settings
    'preferencesBarcodeGenerationTitle': 'バーコード生成',
    // History settings-->
    'preferencesSwitchScanAddBarcodeToTheHistoryLabel': 'スキャンしたバーコードを追加',
    'preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel': '生成されたバーコードを追加',
    'preferencesSwitchHistorySaveDuplicatesLabel': '重複を追加',
    // Search Engine Settings
    'preferencesSearchTitle': '検索',
    'preferencesSearchEngine': '検索エンジン',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    'preferencesAboutTitle': '情報',
    'preferencesAboutOpenSourceLibrariesLabel': 'オープンソースライセンス',
    'preferencesApplicationVersionLabel': 'アプリのバージョン',
    'preferencesSourceCodeLabel': 'ソースコード',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}