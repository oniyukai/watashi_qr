import 'language.dart';
import 'en.dart';
import 'package:watashi_qr/locale/language_key.dart';

typedef K = LanguageKey;

class ZhHans extends Language {
  ZhHans() : super(
    fallback: En(), const {
    // Permission Denied
    K.cameraPermissionDenied: '等待授权访问相机。',
    // AlertDialog
    K.closeDialogLabel: '关闭',
    K.yesLabel: '是',
    K.noLabel: '否',
    K.goToDialogLabel: '进入网站',
    K.error: '错误',
    // ImageView Description
    K.imageViewDescriptionFlag: '标志',
    K.imageViewDescriptionLogo: '标识',
    K.imageViewDescriptionTypeIcon: '类型',
    K.imageViewDescriptionBarCode: '条码',
    K.imageViewDescriptionIcon: '图标',
    K.imageViewDescriptionProductFront: '产品图片',
    K.imageViewDescriptionNutriscore: '营养分数',
    K.imageViewDescriptionNovaGroup: 'NOVA GROUP',
    K.imageViewDescriptionEcoScore: 'ECO SCORE',
    K.imageViewDescriptionBackground: '背景',
    K.imageViewDescriptionImage: '图片',
    K.sliderDescriptionZoom: '缩放',
    // Menu Item
    K.titleScan: '扫描',
    K.titleHistory: '历史记录',
    K.titleGenerate: '创建',
    K.titleSettings: '设置',
    K.titleQrCodeCreator: '创建二维码',
    K.titleBarCodeCreator: '创建条形码',
    K.createQrFromClipboard: '从剪贴板创建二维码',
    K.informationLabel: '信息',
    K.barcodeLabel: '条码',
    K.downloadFromApiLabel: '从 API 下载',
    K.shareToThisAppLabel: '也可以在其他应用中分享到此程序。',
    K.menuMore: '更多',
    // Barcode Type
    K.barcodeQrCodeLabel: '二维码',
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
    K.qrCodeTypeNameText: '文本',
    K.qrCodeTypeNameWebSite: '网站',
    K.qrCodeTypeNameContact: '联系人',
    K.qrCodeTypeNameMail: '邮件',
    K.qrCodeTypeNameSms: '短信',
    K.qrCodeTypeNamePhone: '电话号码',
    K.qrCodeTypeNameGeographicCoordinates: '地理坐标',
    K.qrCodeTypeNameAgenda: '日程',
    K.qrCodeTypeNameWifi: 'Wi-Fi',
    K.qrCodeTypeNameApps: '应用程序',
    // Product Type
    K.barCodeTypeProduct: '产品代码',
    K.barCodeTypeIndustrial: '工业代码',
    K.barCodeTypeNameUnknown: '未知',
    // Error Correction Level
    K.qrCodeErrorCorrectionLevelLabel: '纠错等级',
    K.qrCodeErrorCorrectionLevelSettingsLabel: '纠错等级（二维码）',
    K.qrCodeErrorCorrectionLevelNameLow: '低（~7%）',
    K.qrCodeErrorCorrectionLevelNameMedium: '中（~15%）',
    K.qrCodeErrorCorrectionLevelNameQuartile: '四分位数（~25%）',
    K.qrCodeErrorCorrectionLevelNameHigh: '高（~30%）',
    // History
    K.labelHistoryEmpty: '没有历史记录…',
    K.snackBarMessageItemDeleted: '产品已从历史记录中删除。',
    K.snackBarMessageItemsDeleted: '已从历史记录中删除项目。',
    K.popupMessageConfirmationDeleteHistory: '删除所有历史记录？',
    K.popupMessageConfirmationDeleteSelectedItemsHistory: '删除选取的项目？',
    K.menuItemHistoryDelete: '删除历史记录',
    K.menuItemHistoryDeleteFromHistory: '从历史记录中删除',
    K.menuItemHistoryRemovedFromHistory: '已从历史记录中移除！',
    K.menuItemHistoryAddInHistory: '加入至历史记录',
    K.menuItemHistoryAddedInHistory: '已加入至历史记录！',
    K.menuItemHistoryAddFavorite: '添加到收藏夹',
    K.menuItemHistoryRemoveFavorite: '收藏夹中移出',
    K.deleteLabel: '删除',
    K.cancelLabel: '取消',
    K.recordLabel: '保存',
    // Export File
    K.exportLabel: '导出',
    K.exportJsonLabel: '导出为 JSON',
    K.importJsonLabel: '导入 (JSON)',
    K.shareJsonLabel: '分享为 JSON',
    K.snackBarMessageFileExportSuccess: '文件已保存！',
    K.snackBarMessageFileExportError: '发生了错误！文件未保存。',
    K.snackBarMessageFileImportSuccess: '文件已导入！',
    K.snackBarMessageFileImportError: '发生了错误！文件未导入。',
    // CaptureActivity
    // BarcodeAnalysisActivity
    K.barcodeInformationSearchLabel: '搜索中…',
    K.scanErrorLabel: '扫描时发生错误！',
    K.scanErrorShortInformationLabel: '搜索信息时发生错误！',
    K.barcodeScannedLabel: '%1s 已扫描！',
    K.barcodeFoundOnLabel: '发现 %1s！',
    K.barcodeNotFoundOnApiLabel: '没有发现信息 %1s。',
    K.noInternetPermission: '你没有允许访问网络。',
    K.aboutBarcodeInformationLabel: '条码信息',
    K.aboutBarcodeLabel: '关于条码',
    K.aboutBarcodeFormatLabel: '格式: ',
    K.aboutBarcodeContentLabel: '条码: ',
    K.aboutBarcodeOriginLabel: '来源: ',
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
    K.barCodeContentLabel: '条码内容',
    K.barCodeAnalysisLabel: '条码分析',
    // Matrix Barcode Contact Analysis
    K.matrixContactNameLabel: '名称',
    K.matrixContactOrganisationLabel: '公司',
    K.matrixContactJobTitleLabel: '职位名称',
    K.matrixContactPhoneLabel: '电话',
    K.matrixContactMailLabel: '电子邮件',
    K.matrixContactAddressLabel: '地址',
    K.matrixContactNotesLabel: '备注',
    // Matrix Barcode Agenda Analysis
    K.matrixAgendaNameEventLabel: '事件名称',
    K.matrixAgendaStartDateEventLabel: '开始',
    K.matrixAgendaEndDateEventLabel: '结束',
    K.matrixAgendaPlaceEventLabel: '地点',
    K.matrixAgendaDescriptionEventLabel: '描述',
    // Matrix Barcode Phone Analysis
    K.matrixPhoneTelNumberLabel: '电话',
    // Matrix Barcode Email Analysis
    K.matrixEmailRecipientLabel: '收件人',
    K.matrixEmailCcLabel: '抄送',
    K.matrixEmailBccLabel: '密送',
    K.matrixSubjectLabel: '主题',
    K.matrixBodyLabel: '信息',
    // Matrix Barcode Wi-Fi Analysis
    K.matrixWifiSsidLabel: 'SSID',
    K.matrixWifiPasswordLabel: '密码',
    K.matrixWifiEncryptionLabel: '加密',
    K.matrixWifiIsHiddenLabel: '隐藏',
    K.matrixWifiAnonymousIdentityLabel: '匿名身份',
    K.matrixWifiIdentityLabel: '身份',
    K.matrixWifiEapMethodLabel: 'Eap 方法',
    K.matrixWifiPhase2MethodLabel: 'Phase 2 方法',
    // Matrix Barcode URL Analysis
    K.matrixUriUrlLabel: 'URL',
    K.matrixUriMaliciousLabel: '可能是恶意 URL…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    K.matrixLocalisationLatitudeLabel: '纬度',
    K.matrixLocalisationLongitudeLabel: '经度',
    K.matrixLocalisationAltitudeLabel: '高度',
    K.matrixLocalisationQueryLabel: '查询',
    K.matrixLocalisationButtonFindLocation: '从你的位置产生',
    K.matrixLocalisationSearchCurrentPositionLabel: '搜索当前位置…',
    K.matrixLocalisationLocationDisabledLabel: '你的设备定位似乎没有被启用。',
    // Barcode Description
    K.barcodeIndustrialDescriptionLabel: '此条码类型经常被使用于工业。',
    K.barcodeCode39DescriptionLabel: 'Code 39 是一种用于纺织记号与西药房药品的条码。它也用于军事行业与汽车工业。',
    K.barcodeCode93DescriptionLabel: 'Code 93 是一种用于军事与汽车产业的条码，也被 "Postes Canada" 用于编码特殊交货信息。',
    K.barcodeCode128DescriptionLabel: 'Code 128 是一种产业经常使用的条码。它用于运输产业和供应链中的产品识别。它也可用用于汽车产业或西药房的产品标识。Code 128 使用广泛，也可以用在很多其他结尾。',
    K.barcodeItfDescriptionLabel: 'Code ITF (Interleaved 2 of 5) 是一种主要用于货物运输的条码。',
    K.barcodeCodabarDescriptionLabel: 'Code Codabar 是设计用于点阵打印机读取的条码。现今，是很少用于其他营利的条码类型，但仍被一些组织使用如图书馆。',
    K.barcodeUpcADescriptionLabel: 'Code UPC-A (通用产品代码) 是在美国与加拿大广泛使用的条码，用于辨认商店与商店中销售的商品。它由 12 位数字所组成。',
    K.barcodeUpcEDescriptionLabel: 'Code UPC-E (通用产品代码) 是 UPC-A 代码的压缩条码，主要用于美国和加拿大辨认商店与商店中销售的商品。它用于太小而无法使用 UPC-A 的包装。',
    K.barcodeEan13DescriptionLabel: 'Code EAN-13 (欧洲商品条码 13) 是一种广泛用于辨识销售在欧洲与世界上几乎所有地方的产品的条码。它由 13 位数字组成。',
    K.barcodeEan8DescriptionLabel: 'Code EAN-8 (欧洲商品条码 8) 是 EAN-13 代码的压缩条码，用于辨识销售在欧洲与世界上几乎所有地方的产品的条码。它用于太小而无法使用 EAN-13 的包装。',
    // Barcode Composition
    K.barcodeTextCompositionLabel: '文本',
    K.barcodeTextNoSpecialCompositionLabel: '没有特殊字符的文本',
    K.barcodeTextUpperNoSpecialCompositionLabel: '没有特殊字符的大写文本',
    K.barcodeDigitsCompositionLabel: '数字',
    K.barcodeEvenDigitsCompositionLabel: '偶位数字',
    K.barcode7Digits1CheckCompositionLabel: '7位数字 + 1位校验',
    K.barcode11Digits1CheckCompositionLabel: '11位数字 + 1位校验',
    K.barcode12Digits1CheckCompositionLabel: '12位数字 + 1位校验',
    // Snackbar Feddbacks
    K.snackBarMessagePermissionRefused: '你必须接受许可才能使用此功能。',
    K.snackBarMessageSaveBitmapOk: '图片已保存',
    K.snackBarMessageSaveBitmapError: '图片未被保存…\n可能是存储空间不足？',
    K.snackBarMessageShareBitmapError: '分享配置时发生错误。',
    // Actions
    K.actionsLabel: '功能',
    K.intentChooserShareTitle: '分享…',
    K.intentChooserMailTitle: '发送邮件…',
    K.copyBarcodeLabel: '复制条码',
    K.copyLabel: '复制',
    K.barcodeCopiedLabel: '条码已复制',
    K.barcodeSearchErrorLabel: 'URL 不支持',
    K.barcodeSearchErrorNoCompatibleApplicationFound: '找不到兼容的应用程序',
    K.searchLabel: '搜索',
    K.actionTitleDialogLabel: '你想做什么？',
    K.actionGoToUrlLabel: '前往 URL',
    K.actionWebSearchLabel: '在网络上搜索',
    K.actionProductSearchLabel: '搜索',
    K.actionSendMailLabel: '发送电子邮件',
    K.actionSendSmsLabel: '发送短信',
    K.actionCallPhoneLabel: '拨打电话号码',
    K.actionAddToCalendar: '加入到日历',
    K.actionAddToContacts: '加入到通讯录',
    K.actionShareVcfFile: '分享为 VCF',
    K.actionShowLocation: '显示位置',
    K.actionOpenLink: '打开链接',
    K.actionModifyBarcode: '修改条码',
    K.actionModifyNotes: '修改备注',
    K.apply: '应用',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    K.errorBarcodeNoneCharacterMessage: '你必须在字段中输入正确的值。',
    K.errorBarcodeNotANumberMessage: '条码只能由数字组成。',
    K.errorBarcodeWrongLengthMessage: '条码要求的数字长度: ',
    K.errorBarcodeWrongKeyMessage: '最后一位数 (验证键) 应该是: ',
    K.errorBarcodeEncodingIso88591ErrorMessage: '此条码类型不支持特殊字符。',
    K.errorBarcodeEncodingUsAsciiErrorMessage: '此条码类型不支持特殊字符。',
    K.errorBarcode93RegexErrorMessage: '"Code 93" 条码类型可编码 26 个大写字母，10 个数字 (0–9) 以及7个特殊字符 « -, ., space, \$, /, +, % »。此条码类型不能编码小写字母与其他特殊字符。',
    K.errorBarcode39RegexErrorMessage: '"Code 39" 条码类型可编码 26 个大写字母，10 个数字 (0–9) 以及7个特殊字符 « -, ., space, \$, /, +, % »。此条码类型不能编码小写字母与其他特殊字符。',
    K.errorBarcodeCodabarRegexErrorMessage: '"Codabar" 条码类型可编码10个数字 (0–9) 以及6个特殊字符 « -, \$, :, /, ., + »。它也可包含字符 A, B, C 或 D 作为第一个与最后一个条码字符，以指定字符串的开头和结尾。',
    K.errorBarcodeItfErrorMessage: '"ITF" 条码类型必须包含偶数个字符。',
    K.errorBarcodeUpcENotStartWith0ErrorMessage: '"UPC-E" 条码类型开头必须是 0。',
    K.errorBarcodeQrUrlFormatMessage: '网址的开头必须是 "http://" 或 "https://"',
    K.errorBarcodeQrPhoneNumberMissingMessage: '你必须输入一个电话号码',
    K.errorBarcodeQrEmailMissingMessage: '你必须至少输入一个字段',
    K.errorBarcodeQrLocalisationMissingMessage: '你必须告知经度和纬度',
    // Action Barcode Generated
    K.barcodeCreatorConfirmTextLabel: '产生',
    K.saveLabel: '保存',
    K.shareLabel: '分享',
    K.shareImageLabel: '分享图片',
    K.shareTextLabel: '分享文本',
    K.popupMessageConfirmationSaveImage: '保存图片？',
    K.clipboardEmpty: '剪贴板是空的。',
    // Barcode Image Editor
    // Form
    K.qrCodeTextGeneratorHintTextInputEditText: '输入文本…',
    K.qrCodeTextGeneratorHintPhoneInputEditText: '输入电话号码…',
    K.qrCodeTextGeneratorHintUrlInputEditText: '输入网址…',
    K.qrCodeTextInputEditTextHintMessage: '信息...',
    // Contact Creator
    K.qrCodeTypeNameGenerateFromContact: '从通讯录产生',
    K.qrCodeImportContactFromVcard: '从vCard产生',
    K.qrCodeTextRadioButtonLabelM: '先生',
    K.qrCodeTextRadioButtonLabelMrs: '女士',
    K.qrCodeTextRadioButtonLabelMiss: '小姐',
    K.qrCodeTextRadioButtonLabelNone: '无',
    K.qrCodeTextInputEditTextHintName: '名称',
    K.qrCodeTextInputEditTextHintFirstName: '姓氏',
    K.qrCodeTextInputEditTextHintWebSite: '网站',
    K.qrCodeTextInputEditTextHintMail1: '邮件地址 1',
    K.qrCodeTextInputEditTextHintMail2: '邮件地址 2',
    K.qrCodeTextInputEditTextHintMail3: '邮件地址 3',
    K.qrCodeTextInputEditTextHintPhone1: '电话号码 1',
    K.qrCodeTextInputEditTextHintPhone2: '电话号码 2',
    K.qrCodeTextInputEditTextHintPhone3: '电话号码 3',
    K.qrCodeTextInputEditTextHintStreetAddress: '街道地址',
    K.qrCodeTextInputEditTextHintPostalCode: '邮政编码',
    K.qrCodeTextInputEditTextHintCity: '城市',
    K.qrCodeTextInputEditTextHintCountry: '国家',
    K.qrCodeTextInputEditTextHintRegion: '地区',
    K.qrCodeTextInputEditTextHintNotes: '备注',
    K.qrCodeSpinnerPromptNone: '无',
    K.spinnerTypeMobile: '手机',
    K.spinnerTypeFax: '传真',
    K.spinnerTypeHome: '住宅',
    K.spinnerTypeWork: '工作',
    K.spinnerTypeOther: '其他',
    // EPC Creator
    // Mail Creator
    K.qrCodeTextInputEditTextHintEmail: '电子邮件',
    K.qrCodeTextInputEditTextHintEmailSubject: '主题',
    // Geo Localisation Creator
    K.qrCodeTextInputEditTextHintLocalisationLatitude: '纬度',
    K.qrCodeTextInputEditTextHintLocalisationLongitude: '经度',
    K.qrCodeTextInputEditTextHintLocalisationHeight: '高度',
    K.qrCodeTextInputEditTextHintLocalisationRequest: '查询',
    // Wifi Creator
    K.qrCodeTextInputEditTextHintWifiSsid: 'SSID / 网络名称',
    K.qrCodeTextInputEditTextHintWifiPassword: '密码',
    K.qrCodeTextInputEditTextHintWifiHide: '隐藏',
    K.spinnerWifiEncryptionWep: 'WEP',
    K.spinnerWifiEncryptionWpa: 'WPA/WPA2',
    K.spinnerWifiEncryptionSae: 'WPA3',
    K.spinnerWifiEncryptionNone: '无密码',
    // Event Creator
    K.qrCodeTextInputEditTextHintAgendaEventName: '事件名称',
    K.qrCodeTextInputEditTextHintAgendaPlace: '地点',
    K.qrCodeTextInputEditTextHintAgendaDescription: '描述',
    K.checkBoxEventAllOfDay: '全天',
    K.beginLabel: '开始',
    K.endLabel: '结束',

    // URL
    // Custom search URL
    K.customSearchUrls: '自定义搜索网址',
    K.customUrls: '自定义网址',
    K.customSearchUrlsAddUrl: '新增网址',
    K.customSearchUrlsModifyUrl: '修改网址',
    K.customSearchUrlsList: '网址列表',
    K.customSearchUrlsListIsEmptyMessage: '没有项目…\n你尚未产生自定义网址。',
    K.popupMessageConfirmationDeletedAllCustomUrls: '你想删除所有自定义网址吗？',
    K.customUrlDeleted: '已删除自定义网址！',
    K.customUrlAdded: '已增加自定义网址！',
    K.customUrlUpdated: '已更新自定义网址！',
    K.customSearchUrlsAddInfo: '在网址中使用术语"{code}"。该术语将会在搜索过程中被条码的内容取代。',
    K.examples: '例子: ',
    K.customSearchUrlsErrorUrl: '网址中必须包含术语: {code}',
    K.errorEmptyFields: '输入字段不得为空。',
    K.customSearchUrlsisDuplicated: '名称已重复，请输入其他名称。',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    K.preferencesDefault: '默认',
    // Appearance Settings
    K.preferencesAppearanceTitle: '外观',
    K.preferencesThemeLabel: '背景颜色',
    K.preferencesSwitchSystemThemeLabel: '系统背景',
    K.preferencesSwitchLightThemeLabel: '浅色',
    K.preferencesSwitchDarkThemeLabel: '深色',
    K.preferencesColor: '主题颜色',
    K.preferencesColorMaterialYou: '系统 Material You',
    K.preferencesColorBlue: '蓝色',
    K.preferencesColorOrange: '橘色',
    K.preferencesColorGreen: '绿色',
    K.preferencesColorRed: '红色',
    K.preferencesColorPurple: '紫色',
    // Languages Settings
    K.preferencesLanguagesTitle: '语言',
    K.preferencesLanguagesChange: '变更语言',
    // Remote API
    // About Remote API
    // Scan Settings
    K.preferencesScanTitle: '扫描',
    K.preferencesSwitchScanAutoOpenWebsiteLabel: '自动打开网站',
    K.preferencesSwitchScanContinuousScanLabel: '连续扫描',
    K.preferencesSwitchScanVibrateLabel: '扫描震动',
    K.preferencesSwitchScanBipLabel: '播放声音',
    K.preferencesSwitchScanScreenRotationLabel: '扫描期间禁用屏幕旋转',
    K.preferencesSwitchScanBarcodeCopiedLabel: '复制到剪贴板',
    K.preferencesSwitchScanUseFrontcameraLabel: '使用前置摄像头',
    // Barcode Generation Settings
    K.preferencesBarcodeGenerationTitle: '条码创建',
    // History settings-->
    K.preferencesSwitchScanAddBarcodeToTheHistoryLabel: '加入扫描的条码至历史记录',
    K.preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel: '加入创建的条码至历史记录',
    K.preferencesSwitchHistorySaveDuplicatesLabel: '扫描或创建时保留重复项',
    // Search Engine Settings
    K.preferencesSearchTitle: '搜索',
    K.preferencesSearchEngine: '搜索引擎',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    K.preferencesAboutTitle: '关于',
    K.preferencesAboutOpenSourceLibrariesLabel: '开源许可证',
    K.preferencesApplicationVersionLabel: '应用版本',
    K.preferencesSourceCodeLabel: '源代码',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}