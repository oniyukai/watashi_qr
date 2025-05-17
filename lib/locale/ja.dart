import 'package:watashi_qr/locale/language_key.dart';
import 'language.dart';
import 'en.dart';

typedef K = LanguageKey;

class Ja extends Language {
  Ja() : super(
    fallback: En(), const {
    // Permission Denied
    K.cameraPermissionDenied: 'カメラへのアクセスが許可されるのを待っています。',
    // AlertDialog
    K.closeDialogLabel: '閉じる',
    K.yesLabel: 'はい',
    K.noLabel: 'いいえ',
    K.goToDialogLabel: 'ウェブサイトへ移動',
    K.error: 'エラー',
    // ImageView Description
    K.imageViewDescriptionFlag: 'フラグ',
    K.imageViewDescriptionLogo: 'ロゴ',
    K.imageViewDescriptionTypeIcon: 'タイプ',
    K.imageViewDescriptionBarCode: 'バーコード',
    K.imageViewDescriptionIcon: 'アイコン',
    K.imageViewDescriptionProductFront: '製品画像',
    K.imageViewDescriptionNutriscore: '栄養スコア',
    K.imageViewDescriptionNovaGroup: 'NOVAグループ',
    K.imageViewDescriptionEcoScore: 'ECOスコア',
    K.imageViewDescriptionBackground: '背景',
    K.imageViewDescriptionImage: '画像',
    K.sliderDescriptionZoom: 'ズーム',
    // Menu Item
    K.titleScan: 'スキャン',
    K.titleHistory: '履歴',
    K.titleGenerate: '生成',
    K.titleSettings: '設定',
    K.titleQrCodeCreator: 'QRコードを作成',
    K.titleBarCodeCreator: 'バーコードを作成',
    K.createQrFromClipboard: 'クリップボードからQRコードを作成',
    K.informationLabel: '情報',
    K.barcodeLabel: 'バーコード',
    K.downloadFromApiLabel: 'APIからダウンロード',
    K.shareToThisAppLabel: '他のアプリからこのアプリへ共有することもできます。',
    K.menuMore: 'その他',
    // Barcode Type
    K.barcodeQrCodeLabel: 'QRコード',
    K.barcodeDataMatrixLabel: 'データマトリックス',
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
    K.qrCodeTypeNameText: 'テキスト',
    K.qrCodeTypeNameWebSite: 'ウェブサイト',
    K.qrCodeTypeNameContact: '連絡先',
    K.qrCodeTypeNameMail: 'メール',
    K.qrCodeTypeNameSms: 'SMS',
    K.qrCodeTypeNamePhone: '電話番号',
    K.qrCodeTypeNameLocation: '地理座標',
    K.qrCodeTypeNameEvent: '予定',
    K.qrCodeTypeNameWifi: 'Wi-Fi',
    K.qrCodeTypeNameApps: 'アプリ',
    // Product Type
    K.barCodeTypeProduct: '製品コード',
    K.barCodeTypeIndustrial: '工業コード',
    K.barCodeTypeNameUnknown: '不明',
    // Error Correction Level
    K.qrCodeErrorCorrectionLevelLabel: '誤り訂正レベル',
    K.qrCodeErrorCorrectionLevelSettingsLabel: '誤り訂正レベル (QRコード)',
    K.qrCodeErrorCorrectionLevelNameLow: '低 (~7%)',
    K.qrCodeErrorCorrectionLevelNameMedium: '中 (~15%)',
    K.qrCodeErrorCorrectionLevelNameQuartile: '四分位 (~25%)',
    K.qrCodeErrorCorrectionLevelNameHigh: '高 (~30%)',
    // History
    K.labelHistoryEmpty: '履歴はありません…',
    K.snackBarMessageItemDeleted: '製品を履歴から削除しました。',
    K.snackBarMessageItemsDeleted: '履歴からアイテムを削除しました。',
    K.popupMessageConfirmationDeleteHistory: 'すべての履歴を削除しますか？',
    K.popupMessageConfirmationDeleteSelectedItemsHistory: '選択したアイテムを削除しますか？',
    K.menuItemHistoryDelete: '履歴を削除',
    K.menuItemHistoryDeleteFromHistory: '履歴から削除',
    K.menuItemHistoryRemovedFromHistory: '履歴から削除しました！',
    K.menuItemHistoryAddInHistory: '履歴に追加',
    K.menuItemHistoryAddedInHistory: '履歴に追加しました！',
    K.menuItemHistoryAddFavorite: 'お気に入りに追加',
    K.menuItemHistoryRemoveFavorite: 'お気に入りから削除',
    K.deleteLabel: '削除',
    K.cancelLabel: 'キャンセル',
    K.recordLabel: '保存',
    // Export File
    K.exportLabel: 'エクスポート',
    K.exportJsonLabel: 'JSONとしてエクスポート',
    K.importJsonLabel: 'インポート (JSON)',
    K.shareJsonLabel: 'JOSNを共有する',
    K.snackBarMessageFileExportSuccess: 'ファイルを保存しました！',
    K.snackBarMessageFileExportError: 'エラーが発生しました！ファイルを保存できませんでした。',
    K.snackBarMessageFileImportSuccess: 'ファイルをインポートしました！',
    K.snackBarMessageFileImportError: 'エラーが発生しました！ファイルをインポートできませんでした。',
    // CaptureActivity
    // BarcodeAnalysisActivity
    K.barcodeInformationSearchLabel: '検索中…',
    K.scanErrorLabel: 'スキャン中にエラーが発生しました！',
    K.scanErrorShortInformationLabel: '情報の検索中にエラーが発生しました！',
    K.barcodeScannedLabel: '%1s をスキャンしました！',
    K.barcodeFoundOnLabel: '%1s で見つかりました！',
    K.barcodeNotFoundOnApiLabel: '%1s に関する情報は見つかりませんでした。',
    K.noInternetPermission: 'インターネットへのアクセスが許可されていません。',
    K.aboutBarcodeInformationLabel: 'バーコード情報',
    K.aboutBarcodeLabel: 'バーコードについて',
    K.aboutBarcodeFormatLabel: '形式: ',
    K.aboutBarcodeContentLabel: 'バーコード: ',
    K.aboutBarcodeOriginLabel: 'ソース: ',
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
    K.barCodeContentLabel: 'バーコードの内容',
    K.barCodeAnalysisLabel: 'バーコード分析',
    // Matrix Barcode Contact Analysis
    K.matrixContactNameLabel: '名前',
    K.matrixContactOrganisationLabel: '組織',
    K.matrixContactJobTitleLabel: '役職',
    K.matrixContactPhoneLabel: '電話',
    K.matrixContactMailLabel: 'メール',
    K.matrixContactAddressLabel: '住所',
    K.matrixContactNotesLabel: '備考',
    // Matrix Barcode Agenda Analysis
    K.matrixAgendaNameEventLabel: 'イベント名',
    K.matrixAgendaStartDateEventLabel: '開始',
    K.matrixAgendaEndDateEventLabel: '終了',
    K.matrixAgendaPlaceEventLabel: '場所',
    K.matrixAgendaDescriptionEventLabel: '説明',
    // Matrix Barcode Phone Analysis
    K.matrixPhoneTelNumberLabel: '電話',
    // Matrix Barcode Email Analysis
    K.matrixEmailRecipientLabel: '受信者',
    K.matrixEmailCcLabel: 'CC',
    K.matrixEmailBccLabel: 'BCC',
    K.matrixSubjectLabel: '件名',
    K.matrixBodyLabel: 'メッセージ',
    // Matrix Barcode Wi-Fi Analysis
    K.matrixWifiSsidLabel: 'SSID',
    K.matrixWifiPasswordLabel: 'パスワード',
    K.matrixWifiEncryptionLabel: '暗号化',
    K.matrixWifiIsHiddenLabel: '非表示',
    K.matrixWifiAnonymousIdentityLabel: '匿名ID',
    K.matrixWifiIdentityLabel: 'ID',
    K.matrixWifiEapMethodLabel: 'Eap方式',
    K.matrixWifiPhase2MethodLabel: 'Phase 2 方式',
    // Matrix Barcode URL Analysis
    K.matrixUriUrlLabel: 'URL',
    K.matrixUriMaliciousLabel: 'URLは悪意のある可能性があります…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    K.matrixLocalisationLatitudeLabel: '緯度',
    K.matrixLocalisationLongitudeLabel: '経度',
    K.matrixLocalisationAltitudeLabel: '高度',
    K.matrixLocalisationQueryLabel: 'クエリ',
    K.matrixLocalisationButtonFindLocation: '現在地から生成',
    K.matrixLocalisationSearchCurrentPositionLabel: '現在地を検索中…',
    K.matrixLocalisationLocationDisabledLabel: 'デバイスの位置情報が有効になっていないようです。',
    // Barcode Description
    K.barcodeIndustrialDescriptionLabel: 'このタイプのバーコードは、多くの場合、業界で使用されます。',
    K.barcodeCode39DescriptionLabel: 'Code 39は、繊維のマーキングや薬局の薬で使用されるバーコードです。 軍事部門や自動車産業でも使用されています。',
    K.barcodeCode93DescriptionLabel: 'Code 93は、軍事部門や自動車産業で使用されるバーコードであり、「Postes Canada」が特別な配達情報をエンコードするためにも使用しています。',
    K.barcodeCode128DescriptionLabel: 'Code 128は、業界でよく使用されるバーコードです。 輸送業界やサプライチェーンの製品識別に使用されています。 自動車業界や薬局の製品マーキングにも使用できます。 Code 128は広く使用されており、他の多く の用途にも使用できます。',
    K.barcodeItfDescriptionLabel: 'Code ITF（Interleaved 2 of 5）は、主に商品の出荷に使用されるバーコードです。',
    K.barcodeCodabarDescriptionLabel: 'Code Codabarは、ドットマトリックスプリンターで読み取るように設計されたバーコードです。 現在、Codabarは他のバーコードタイプの利点のためにほとんど使用されていませんが、図書館などの一部の組織ではまだ使用されています。',
    K.barcodeUpcADescriptionLabel: 'Code UPC-A（Universal Product Code）は、米国とカナダで広く使用されているバーコードで、店舗やショップで販売されている製品を識別するために使用されます。 12桁で構成されています。',
    K.barcodeUpcEDescriptionLabel: 'Code UPC-E（Universal Product Code）は、主に米国とカナダで店舗やショップで販売されている製品を識別するために使用される、Code UPC-Aの凝縮されたバーコードです。 UPC-Aコードを受け取るには小さすぎるパッ ケージで使用されます。',
    K.barcodeEan13DescriptionLabel: 'Code EAN-13（European Article Numbering 13）は、ヨーロッパおよび世界のほぼすべての地域で店舗やショップで販売されている製品を識別するために広く使用されているバーコードです。 13桁で構成されています。',
    K.barcodeEan8DescriptionLabel: 'Code EAN-8（European Article Numbering 8）は、ヨーロッパおよび世界のほぼすべての地域で店舗やショップで販売されている製品を識別するために使用される、Code EAN-13の凝縮されたバーコードです。 EAN-13コー ドを受け取るには小さすぎるパッケージで使用されます。',
    // Barcode Composition
    K.barcodeTextCompositionLabel: 'テキスト',
    K.barcodeTextNoSpecialCompositionLabel: '特殊文字なしのテキスト',
    K.barcodeTextUpperNoSpecialCompositionLabel: '特殊文字なしの大文字テキスト',
    K.barcodeDigitsCompositionLabel: '数字',
    K.barcodeEvenDigitsCompositionLabel: '偶数',
    K.barcode7Digits1CheckCompositionLabel: '7桁 + 1チェック',
    K.barcode11Digits1CheckCompositionLabel: '11桁 + 1チェック',
    K.barcode12Digits1CheckCompositionLabel: '12桁 + 1チェック',
    // Snackbar Feddbacks
    K.snackBarMessagePermissionRefused: 'この機能を使用するには、許可を受け入れる必要があります。',
    K.snackBarMessageSaveBitmapOk: '画像を保存しました',
    K.snackBarMessageSaveBitmapError: '画像を保存できませんでした…',
    K.snackBarMessageShareBitmapError: '共有構成中にエラーが発生しました。',
    // Actions
    K.actionsLabel: 'アクション',
    K.intentChooserShareTitle: '共有…',
    K.intentChooserMailTitle: 'メールを送信…',
    K.copyBarcodeLabel: 'バーコードをコピー',
    K.copyLabel: 'コピー',
    K.barcodeCopiedLabel: 'バーコードをコピーしました',
    K.barcodeSearchErrorLabel: 'サポートされていないURL',
    K.barcodeSearchErrorNoCompatibleApplicationFound: '互換性のあるアプリケーションが見つかりません',
    K.searchLabel: '検索',
    K.actionTitleDialogLabel: '何をしたいですか？',
    K.actionGoToUrlLabel: 'URLへ移動',
    K.actionWebSearchLabel: 'ウェブで検索',
    K.actionProductSearchLabel: '検索',
    K.actionSendMailLabel: 'メールを送信',
    K.actionSendSmsLabel: 'SMSを送信',
    K.actionCallPhoneLabel: '電話番号をかける',
    K.actionAddToCalendar: 'カレンダーに追加',
    K.actionAddToContacts: '連絡先に追加',
    K.actionShareVcfFile: 'VCFとして共有',
    K.actionShowLocation: '場所を表示',
    K.actionOpenLink: 'リンクを開く',
    K.actionModifyBarcode: 'バーコードを修正',
    K.actionModifyNotes: 'メモを修正',
    K.apply: '適用',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    K.errorBarcodeNoneCharacterMessage: '入力フィールドに正しい値を入力する必要があります。',
    K.errorBarcodeNotANumberMessage: 'バーコードは数字のみで構成されている必要があります。',
    K.errorBarcodeWrongLengthMessage: 'バーコードに必要な桁数: ',
    K.errorBarcodeWrongKeyMessage: '最後の桁（チェックディジット）は次のようである必要があります: ',
    K.errorBarcodeEncodingIso88591ErrorMessage: 'このバーコードタイプでは特殊文字はサポートされていません。',
    K.errorBarcodeEncodingUsAsciiErrorMessage: 'このバーコードタイプでは特殊文字はサポートされていません。',
    K.errorBarcode93RegexErrorMessage: '"Code 93"バーコードタイプは、26の大文字、10桁（0〜9）、および7つの特殊文字« -, ., space, \$, /, +, % »をコード化できます。 小文字およびその他の特殊文字は、このバーコードタイプではコード化できません。',
    K.errorBarcode39RegexErrorMessage: '"Code 39"バーコードタイプは、26の大文字、10桁（0〜9）、および7つの特殊文字« -, ., space, \$, /, +, % »をコード化できます。 小文字およびその他の特殊文字は、このバーコードタイプではコード化できません。',
    K.errorBarcodeCodabarRegexErrorMessage: '"Codabar"バーコードタイプは、10桁（0〜9）と6つの特殊文字« -, \$, :, /, ., + »をコード化できます。 文字列の始まりと終わりを指定するために、最初と最後のバーコード文字として文字A、B、C、またはD を含めることもできます。',
    K.errorBarcodeItfErrorMessage: '"ITF"バーコードタイプには、偶数の文字が含まれている必要があります。',
    K.errorBarcodeUpcENotStartWith0ErrorMessage: '"UPC-E"バーコードタイプは0で始まる必要があります。',
    K.errorBarcodeQrUrlFormatMessage: 'ウェブアドレスは「http://」または「https://」で始まる必要があります',
    K.errorBarcodeQrPhoneNumberMissingMessage: '電話番号を入力する必要があります',
    K.errorBarcodeQrEmailMissingMessage: '少なくとも1つの入力フィールドを入力する必要があります',
    K.errorBarcodeQrLocalisationMissingMessage: '緯度と経度を入力する必要があります',
    // Action Barcode Generated
    K.barcodeCreatorConfirmTextLabel: '生成',
    K.saveLabel: '保存',
    K.shareLabel: '共有',
    K.shareImageLabel: '画像を共有',
    K.shareTextLabel: 'テキストを共有',
    K.popupMessageConfirmationSaveImage: '画像を保存しますか？',
    K.clipboardEmpty: 'クリップボードは空です。',
    // Barcode Image Editor
    // Form
    K.qrCodeTextGeneratorHintTextInputEditText: 'テキストを入力…',
    K.qrCodeTextGeneratorHintPhoneInputEditText: '電話番号を入力…',
    K.qrCodeTextGeneratorHintUrlInputEditText: 'ウェブアドレスを入力…',
    K.qrCodeTextInputEditTextHintMessage: 'メッセージ...',
    // Contact Creator
    K.qrCodeTypeNameGenerateFromContact: '連絡先から生成',
    K.qrCodeImportContactFromVcard: 'vCardから生成',
    K.qrCodeTextRadioButtonLabelM: '様',
    K.qrCodeTextRadioButtonLabelMrs: '様',
    K.qrCodeTextRadioButtonLabelMiss: '様',
    K.qrCodeTextRadioButtonLabelNone: 'なし',
    K.qrCodeTextInputEditTextHintName: '名前',
    K.qrCodeTextInputEditTextHintFirstName: '名',
    K.qrCodeTextInputEditTextHintWebSite: 'ウェブサイト',
    K.qrCodeTextInputEditTextHintMail1: 'メールアドレス 1',
    K.qrCodeTextInputEditTextHintMail2: 'メールアドレス 2',
    K.qrCodeTextInputEditTextHintMail3: 'メールアドレス 3',
    K.qrCodeTextInputEditTextHintPhone1: '電話番号 1',
    K.qrCodeTextInputEditTextHintPhone2: '電話番号 2',
    K.qrCodeTextInputEditTextHintPhone3: '電話番号 3',
    K.qrCodeTextInputEditTextHintStreetAddress: '住所',
    K.qrCodeTextInputEditTextHintPostalCode: '郵便番号',
    K.qrCodeTextInputEditTextHintCity: '市区町村',
    K.qrCodeTextInputEditTextHintCountry: '国',
    K.qrCodeTextInputEditTextHintRegion: '都道府県',
    K.qrCodeTextInputEditTextHintNotes: '備考',
    K.qrCodeSpinnerPromptNone: 'なし',
    K.spinnerTypeMobile: '携帯',
    K.spinnerTypeFax: 'FAX',
    K.spinnerTypeHome: '自宅',
    K.spinnerTypeWork: '職場',
    K.spinnerTypeOther: 'その他',
    // EPC Creator
    // Mail Creator
    K.qrCodeTextInputEditTextHintEmail: 'メール',
    K.qrCodeTextInputEditTextHintEmailSubject: '件名',
    // Geo Localisation Creator
    K.qrCodeTextInputEditTextHintLocalisationLatitude: '緯度',
    K.qrCodeTextInputEditTextHintLocalisationLongitude: '経度',
    K.qrCodeTextInputEditTextHintLocalisationHeight: '高度',
    K.qrCodeTextInputEditTextHintLocalisationRequest: 'クエリ',
    // Wifi Creator
    K.qrCodeTextInputEditTextHintWifiSsid: 'SSID / ネットワーク名',
    K.qrCodeTextInputEditTextHintWifiPassword: 'パスワード',
    K.qrCodeTextInputEditTextHintWifiHide: '非表示',
    K.spinnerWifiEncryptionWep: 'WEP',
    K.spinnerWifiEncryptionWpa: 'WPA/WPA2',
    K.spinnerWifiEncryptionSae: 'WPA3',
    K.spinnerWifiEncryptionNone: 'パスワードなし',
    // Event Creator
    K.qrCodeTextInputEditTextHintAgendaEventName: 'イベント名',
    K.qrCodeTextInputEditTextHintAgendaPlace: '場所',
    K.qrCodeTextInputEditTextHintAgendaDescription: '説明',
    K.checkBoxEventAllOfDay: '終日',
    K.beginLabel: '開始',
    K.endLabel: '終了',

    // URL
    // Custom search URL
    K.customSearchUrls: 'カスタム検索URL',
    K.customUrls: 'カスタムURL',
    K.customSearchUrlsAddUrl: 'URLを追加',
    K.customSearchUrlsModifyUrl: 'URLを修正',
    K.customSearchUrlsList: 'URLリスト',
    K.customSearchUrlsListIsEmptyMessage: 'アイテムはありません…\nカスタムURLをまだ生成していません。',
    K.popupMessageConfirmationDeletedAllCustomUrls: 'すべてのカスタムURLを削除しますか？',
    K.customUrlDeleted: 'カスタムURLを削除しました！',
    K.customUrlAdded: 'カスタムURLを追加しました！',
    K.customUrlUpdated: 'カスタムURLを更新しました！',
    K.customSearchUrlsAddInfo: 'URLで「{code}」という用語を使用します。 この用語は、検索中にバーコードの内容に置き換えられます。',
    K.examples: '例：',
    K.customSearchUrlsErrorUrl: 'URLに「{code}」という用語が含まれている必要があります。',
    K.errorEmptyFields: '入力フィールドは空にできません。',
    K.customSearchUrlsisDuplicated: '名前が重複しています。別の名前を入力してください。',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    K.preferencesDefault: 'デフォルト',
    // Appearance Settings
    K.preferencesAppearanceTitle: '外観',
    K.preferencesThemeLabel: 'テーマ',
    K.preferencesSwitchSystemThemeLabel: 'システムに従う',
    K.preferencesSwitchLightThemeLabel: 'ライト',
    K.preferencesSwitchDarkThemeLabel: 'ダーク',
    K.preferencesColor: 'メインカラー',
    K.preferencesColorMaterialYou: 'システム (Material You)',
    K.preferencesColorBlue: '青',
    K.preferencesColorOrange: 'オレンジ',
    K.preferencesColorGreen: '緑',
    K.preferencesColorRed: '赤',
    K.preferencesColorPurple: '紫',
    // Languages Settings
    K.preferencesLanguagesTitle: '言語',
    K.preferencesLanguagesChange: '言語を変更',
    // Remote API
    // About Remote API
    // Scan Settings
    K.preferencesScanTitle: 'スキャン',
    K.preferencesSwitchScanAutoOpenWebsiteLabel: '自動的にウェブサイトを開く',
    K.preferencesSwitchScanContinuousScanLabel: '連続スキャン',
    K.preferencesSwitchScanVibrateLabel: 'スキャン時に振動',
    K.preferencesSwitchScanBipLabel: 'スキャン時に音を出す',
    K.preferencesSwitchScanScreenRotationLabel: 'スキャン中の画面回転を無効にする',
    K.preferencesSwitchScanBarcodeCopiedLabel: 'スキャンしたバーコードをコピー',
    K.preferencesSwitchScanUseFrontcameraLabel: 'フロントカメラを使用',
    // Barcode Generation Settings
    K.preferencesBarcodeGenerationTitle: 'バーコード生成',
    // History settings-->
    K.preferencesSwitchScanAddBarcodeToTheHistoryLabel: 'スキャンしたバーコードを追加',
    K.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel: '生成されたバーコードを追加',
    K.preferencesSwitchHistorySaveDuplicatesLabel: '重複を追加',
    // Search Engine Settings
    K.preferencesSearchTitle: '検索',
    K.preferencesSearchEngine: '検索エンジン',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    K.preferencesAboutTitle: '情報',
    K.preferencesAboutOpenSourceLibrariesLabel: 'オープンソースライセンス',
    K.preferencesApplicationVersionLabel: 'アプリのバージョン',
    K.preferencesSourceCodeLabel: 'ソースコード',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}