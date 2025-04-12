import 'language.dart';
import 'language_en.dart';

class LanguageZh extends Language {
  LanguageZh() : super(
    fallbackLanguage: LanguageEn(), const {
    // Permission Denied
    'cameraPermissionDenied': '等待授权访问相机。',
    // AlertDialog
    'closeDialogLabel': '关闭',
    'yesLabel': '是',
    'noLabel': '否',
    'goToDialogLabel': '进入网站',
    'error': '错误',
    // ImageView Description
    'imageViewDescriptionFlag': '标志',
    'imageViewDescriptionLogo': '标识',
    'imageViewDescriptionTypeIcon': '类型',
    'imageViewDescriptionBarCode': '条码',
    'imageViewDescriptionIcon': '图标',
    'imageViewDescriptionProductFront': '产品图片',
    'imageViewDescriptionNutriscore': '营养分数',
    'imageViewDescriptionNovaGroup': 'NOVA GROUP',
    'imageViewDescriptionEcoScore': 'ECO SCORE',
    'imageViewDescriptionBackground': '背景',
    'imageViewDescriptionImage': '图片',
    'sliderDescriptionZoom': '缩放',
    // Menu Item
    'titleScan': '扫描',
    'titleHistory': '历史记录',
    'titleGenerate': '创建',
    'titleSettings': '设置',
    'titleQrCodeCreator': '创建二维码',
    'titleBarCodeCreator': '创建条形码',
    'createQrFromClipboard': '从剪贴板创建二维码',
    'informationLabel': '信息',
    'barcodeLabel': '条码',
    'downloadFromApiLabel': '从 API 下载',
    'shareToThisAppLabel': '也可以在其他应用中分享到此程序。',
    'menuMore': '更多',
    // Barcode Type
    'barcodeQrCodeLabel': '二维码',
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
    'qrCodeTypeNameText': '文本',
    'qrCodeTypeNameWebSite': '网站',
    'qrCodeTypeNameContact': '联系人',
    'qrCodeTypeNameMail': '邮件',
    'qrCodeTypeNameSms': '短信',
    'qrCodeTypeNamePhone': '电话号码',
    'qrCodeTypeNameGeographicCoordinates': '地理坐标',
    'qrCodeTypeNameAgenda': '日程',
    'qrCodeTypeNameWifi': 'Wi-Fi',
    'qrCodeTypeNameApps': '应用程序',
    // Product Type
    'barCodeTypeProduct': '产品代码',
    'barCodeTypeIndustrial': '工业代码',
    'barCodeTypeNameUnknown': '未知',
    // Error Correction Level
    'qrCodeErrorCorrectionLevelLabel': '纠错等级',
    'qrCodeErrorCorrectionLevelSettingsLabel': '纠错等级（二维码）',
    'qrCodeErrorCorrectionLevelNameLow': '低（~7%）',
    'qrCodeErrorCorrectionLevelNameMedium': '中（~15%）',
    'qrCodeErrorCorrectionLevelNameQuartile': '四分位数（~25%）',
    'qrCodeErrorCorrectionLevelNameHigh': '高（~30%）',
    // History
    'labelHistoryEmpty': '没有历史记录…',
    'snackBarMessageItemDeleted': '产品已从历史记录中删除。',
    'snackBarMessageItemsDeleted': '已从历史记录中删除项目。',
    'popupMessageConfirmationDeleteHistory': '删除所有历史记录？',
    'popupMessageConfirmationDeleteSelectedItemsHistory': '删除选取的项目？',
    'menuItemHistoryDelete': '删除历史记录',
    'menuItemHistoryDeleteFromHistory': '从历史记录中删除',
    'menuItemHistoryRemovedFromHistory': '已从历史记录中移除！',
    'menuItemHistoryAddInHistory': '加入至历史记录',
    'menuItemHistoryAddedInHistory': '已加入至历史记录！',
    'menuItemHistoryAddFavorite': '添加到收藏夹',
    'menuItemHistoryRemoveFavorite': '收藏夹中移出',
    'deleteLabel': '删除',
    'cancelLabel': '取消',
    'recordLabel': '保存',
    // Export File
    'exportLabel': '导出',
    'exportJsonLabel': '导出为 JSON',
    'importJsonLabel': '导入 (JSON)',
    'snackBarMessageFileExportSuccess': '文件已保存！',
    'snackBarMessageFileExportError': '发生了错误！文件未保存。',
    'snackBarMessageFileImportSuccess': '文件已导入！',
    'snackBarMessageFileImportError': '发生了错误！文件未导入。',
    // CaptureActivity
    // BarcodeAnalysisActivity
    'barcodeInformationSearchLabel': '搜索中…',
    'scanErrorLabel': '扫描时发生错误！',
    'scanErrorShortInformationLabel': '搜索信息时发生错误！',
    'barcodeScannedLabel': '%1s 已扫描！',
    'barcodeFoundOnLabel': '发现 %1s！',
    'barcodeNotFoundOnApiLabel': '没有发现信息 %1s。',
    'noInternetPermission': '你没有允许访问网络。',
    'aboutBarcodeInformationLabel': '条码信息',
    'aboutBarcodeLabel': '关于条码',
    'aboutBarcodeFormatLabel': '格式: ',
    'aboutBarcodeContentLabel': '条码: ',
    'aboutBarcodeOriginLabel': '来源: ',
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
    'barCodeContentLabel': '条码内容',
    'barCodeAnalysisLabel': '条码分析',
    // Matrix Barcode Contact Analysis
    'matrixContactNameLabel': '名称',
    'matrixContactOrganisationLabel': '公司',
    'matrixContactJobTitleLabel': '职位名称',
    'matrixContactPhoneLabel': '电话',
    'matrixContactMailLabel': '电子邮件',
    'matrixContactAddressLabel': '地址',
    'matrixContactNotesLabel': '备注',
    // Matrix Barcode Agenda Analysis
    'matrixAgendaNameEventLabel': '事件名称',
    'matrixAgendaStartDateEventLabel': '开始',
    'matrixAgendaEndDateEventLabel': '结束',
    'matrixAgendaPlaceEventLabel': '地点',
    'matrixAgendaDescriptionEventLabel': '描述',
    // Matrix Barcode Phone Analysis
    'matrixPhoneTelNumberLabel': '电话',
    // Matrix Barcode Email Analysis
    'matrixEmailRecipientLabel': '收件人',
    'matrixEmailCcLabel': '抄送',
    'matrixEmailBccLabel': '密送',
    'matrixSubjectLabel': '主题',
    'matrixBodyLabel': '信息',
    // Matrix Barcode Wi-Fi Analysis
    'matrixWifiSsidLabel': 'SSID',
    'matrixWifiPasswordLabel': '密码',
    'matrixWifiEncryptionLabel': '加密',
    'matrixWifiIsHiddenLabel': '隐藏',
    'matrixWifiAnonymousIdentityLabel': '匿名身份',
    'matrixWifiIdentityLabel': '身份',
    'matrixWifiEapMethodLabel': 'Eap 方法',
    'matrixWifiPhase2MethodLabel': 'Phase 2 方法',
    // Matrix Barcode URL Analysis
    'matrixUriUrlLabel': 'URL',
    'matrixUriMaliciousLabel': '可能是恶意 URL…',
    // Matrix Barcode URI UPI Analysis
    // Matrix Barcode URL Localisation Analysis
    'matrixLocalisationLatitudeLabel': '纬度',
    'matrixLocalisationLongitudeLabel': '经度',
    'matrixLocalisationAltitudeLabel': '高度',
    'matrixLocalisationQueryLabel': '查询',
    'matrixLocalisationButtonFindLocation': '从你的位置产生',
    'matrixLocalisationSearchCurrentPositionLabel': '搜索当前位置…',
    'matrixLocalisationLocationDisabledLabel': '你的设备定位似乎没有被启用。',
    // Barcode Description
    'barcodeIndustrialDescriptionLabel': '此条码类型经常被使用于工业。',
    'barcodeCode39DescriptionLabel': 'Code 39 是一种用于纺织记号与西药房药品的条码。它也用于军事行业与汽车工业。',
    'barcodeCode93DescriptionLabel': 'Code 93 是一种用于军事与汽车产业的条码，也被 "Postes Canada" 用于编码特殊交货信息。',
    'barcodeCode128DescriptionLabel': 'Code 128 是一种产业经常使用的条码。它用于运输产业和供应链中的产品识别。它也可用用于汽车产业或西药房的产品标识。Code 128 使用广泛，也可以用在很多其他结尾。',
    'barcodeItfDescriptionLabel': 'Code ITF (Interleaved 2 of 5) 是一种主要用于货物运输的条码。',
    'barcodeCodabarDescriptionLabel': 'Code Codabar 是设计用于点阵打印机读取的条码。现今，是很少用于其他营利的条码类型，但仍被一些组织使用如图书馆。',
    'barcodeUpcADescriptionLabel': 'Code UPC-A (通用产品代码) 是在美国与加拿大广泛使用的条码，用于辨认商店与商店中销售的商品。它由 12 位数字所组成。',
    'barcodeUpcEDescriptionLabel': 'Code UPC-E (通用产品代码) 是 UPC-A 代码的压缩条码，主要用于美国和加拿大辨认商店与商店中销售的商品。它用于太小而无法使用 UPC-A 的包装。',
    'barcodeEan13DescriptionLabel': 'Code EAN-13 (欧洲商品条码 13) 是一种广泛用于辨识销售在欧洲与世界上几乎所有地方的产品的条码。它由 13 位数字组成。',
    'barcodeEan8DescriptionLabel': 'Code EAN-8 (欧洲商品条码 8) 是 EAN-13 代码的压缩条码，用于辨识销售在欧洲与世界上几乎所有地方的产品的条码。它用于太小而无法使用 EAN-13 的包装。',
    // Barcode Composition
    'barcodeTextCompositionLabel': '文本',
    'barcodeTextNoSpecialCompositionLabel': '没有特殊字符的文本',
    'barcodeTextUpperNoSpecialCompositionLabel': '没有特殊字符的大写文本',
    'barcodeDigitsCompositionLabel': '数字',
    'barcodeEvenDigitsCompositionLabel': '偶位数字',
    'barcode7Digits1CheckCompositionLabel': '7位数字 + 1位校验',
    'barcode11Digits1CheckCompositionLabel': '11位数字 + 1位校验',
    'barcode12Digits1CheckCompositionLabel': '12位数字 + 1位校验',
    // Snackbar Feddbacks
    'snackBarMessagePermissionRefused': '你必须接受许可才能使用此功能。',
    'snackBarMessageSaveBitmapOk': '图片已保存',
    'snackBarMessageSaveBitmapError': '图片未被保存… \n可能是存储空间不足？',
    'snackBarMessageShareBitmapError': '分享配置时发生错误。',
    // Actions
    'actionsLabel': '功能',
    'intentChooserShareTitle': '分享…',
    'intentChooserMailTitle': '发送邮件…',
    'copyBarcodeLabel': '复制条码',
    'copyLabel': '复制',
    'barcodeCopiedLabel': '条码已复制',
    'barcodeSearchErrorLabel': 'URL 不支持',
    'barcodeSearchErrorNoCompatibleApplicationFound': '找不到兼容的应用程序',
    'searchLabel': '搜索',
    'actionTitleDialogLabel': '你想做什么？',
    'actionGoToUrlLabel': '前往 URL',
    'actionWebSearchLabel': '在网络上搜索',
    'actionProductSearchLabel': '搜索',
    'actionSendMailLabel': '发送电子邮件',
    'actionSendSmsLabel': '发送短信',
    'actionCallPhoneLabel': '拨打电话号码',
    'actionAddToCalendar': '加入到日历',
    'actionAddToContacts': '加入到通讯录',
    'actionShareVcfFile': '分享为 VCF',
    'actionShowLocation': '显示位置',
    'actionOpenLink': '打开链接',
    'actionModifyBarcode': '修改条码',
    'actionModifyNotes': '修改备注',
    'apply': '应用',
    // Wi-Fi Connection

    // QR Code Generator
    // Barcode Generator Errors
    'errorBarcodeNoneCharacterMessage': '你必须在字段中输入正确的值。',
    'errorBarcodeNotANumberMessage': '条码只能由数字组成。',
    'errorBarcodeWrongLengthMessage': '条码要求的数字长度: ',
    'errorBarcodeWrongKeyMessage': '最后一位数 (验证键) 应该是: ',
    'errorBarcodeEncodingIso88591ErrorMessage': '此条码类型不支持特殊字符。',
    'errorBarcodeEncodingUsAsciiErrorMessage': '此条码类型不支持特殊字符。',
    'errorBarcode93RegexErrorMessage': '"Code 93" 条码类型可编码 26 个大写字母，10 个数字 (0–9) 以及8个特殊字符 « -, ., space, *, \$, /, +, % »。此条码类型不能编码小写字母与其他特殊字符。',
    'errorBarcode39RegexErrorMessage': '"Code 39" 条码类型可编码 26 大写字母，10 个数字 (0–9) 以及7个特殊字符 « -, ., space, \$, /, +, % »。此条码类型不能编码小写字母与其他特殊字符。',
    'errorBarcodeCodabarRegexErrorMessage': '"Codabar" 条码类型可编码10个数字 (0–9) 以及6个特殊字符 « -, \$, :, /, ., + »。它也可包含字符 A, B, C 或 D 作为第一个与最后一个条码字符，以指定字符串的开头和结尾。',
    'errorBarcodeItfErrorMessage': '"ITF" 条码类型必须包含偶数个字符。',
    'errorBarcodeUpcENotStartWith0ErrorMessage': '"UPC-E" 条码类型开头必须是 0。',
    'errorBarcodeQrUrlFormatMessage': '网址的开头必须是 "http://" 或 "https://"',
    'errorBarcodeQrPhoneNumberMissingMessage': '你必须输入一个电话号码',
    'errorBarcodeQrEmailMissingMessage': '你必须至少输入一个字段',
    'errorBarcodeQrLocalisationMissingMessage': '你必须告知经度和纬度',
    // Action Barcode Generated
    'barcodeCreatorConfirmTextLabel': '产生',
    'saveLabel': '保存',
    'shareLabel': '分享',
    'shareImageLabel': '分享图片',
    'shareTextLabel': '分享文本',
    'popupMessageConfirmationSaveImage': '保存图片？',
    'clipboardEmpty': '剪贴板是空的。',
    // Barcode Image Editor
    // Form
    'qrCodeTextGeneratorHintTextInputEditText': '输入文本…',
    'qrCodeTextGeneratorHintPhoneInputEditText': '输入电话号码…',
    'qrCodeTextGeneratorHintUrlInputEditText': '输入网址…',
    'qrCodeTextInputEditTextHintMessage': '信息...',
    // Contact Creator
    'qrCodeTypeNameGenerateFromContact': '从通讯录产生',
    'qrCodeImportContactFromVcard': '从vCard产生',
    'qrCodeTextRadioButtonLabelM': '先生',
    'qrCodeTextRadioButtonLabelMrs': '女士',
    'qrCodeTextRadioButtonLabelMiss': '小姐',
    'qrCodeTextRadioButtonLabelNone': '无',
    'qrCodeTextInputEditTextHintName': '名称',
    'qrCodeTextInputEditTextHintFirstName': '姓氏',
    'qrCodeTextInputEditTextHintWebSite': '网站',
    'qrCodeTextInputEditTextHintMail1': '邮件地址 1',
    'qrCodeTextInputEditTextHintMail2': '邮件地址 2',
    'qrCodeTextInputEditTextHintMail3': '邮件地址 3',
    'qrCodeTextInputEditTextHintPhone1': '电话号码 1',
    'qrCodeTextInputEditTextHintPhone2': '电话号码 2',
    'qrCodeTextInputEditTextHintPhone3': '电话号码 3',
    'qrCodeTextInputEditTextHintStreetAddress': '街道地址',
    'qrCodeTextInputEditTextHintPostalCode': '邮政编码',
    'qrCodeTextInputEditTextHintCity': '城市',
    'qrCodeTextInputEditTextHintCountry': '国家',
    'qrCodeTextInputEditTextHintRegion': '地区',
    'qrCodeTextInputEditTextHintNotes': '备注',
    'qrCodeSpinnerPromptNone': '无',
    'spinnerTypeMobile': '手机',
    'spinnerTypeFax': '传真',
    'spinnerTypeHome': '住宅',
    'spinnerTypeWork': '工作',
    'spinnerTypeOther': '其他',
    // EPC Creator
    'qrCodeTextInputEditTextHintEpcServiceTag': '服务标签',
    'qrCodeTextInputEditTextHintEpcVersion': '版本',
    'qrCodeTextInputEditTextHintEpcCharacterSet': '字符集',
    'qrCodeTextInputEditTextHintEpcIdentification': '识别',
    'qrCodeTextInputEditTextHintEpcBic': 'BIC',
    'qrCodeTextInputEditTextHintEpcName': '名称',
    'qrCodeTextInputEditTextHintEpcIban': 'IBAN',
    'qrCodeTextInputEditTextHintEpcAmount': '金额',
    'qrCodeTextInputEditTextHintEpcPurpose': '目的',
    'qrCodeTextInputEditTextHintEpcRemittanceRef': '汇款（参考）',
    'qrCodeTextInputEditTextHintEpcRemittanceText': '汇款（信息）',
    'qrCodeTextInputEditTextHintEpcInformation': '信息',
    'qrCodeTextInputEditTextEpcNameError': '「名称」字段是必须的',
    'qrCodeTextInputEditTextEpcIbanError': 'IBAN 不正确',
    'listBankEmptyMessage': '没有项目…\n你还没有产生一个 EPC QR Code。',
    // Mail Creator
    'qrCodeTextInputEditTextHintEmail': '电子邮件',
    'qrCodeTextInputEditTextHintEmailSubject': '主题',
    // Geo Localisation Creator
    'qrCodeTextInputEditTextHintLocalisationLatitude': '纬度',
    'qrCodeTextInputEditTextHintLocalisationLongitude': '经度',
    'qrCodeTextInputEditTextHintLocalisationHeight': '高度',
    'qrCodeTextInputEditTextHintLocalisationRequest': '查询',
    // Wifi Creator
    'qrCodeTextInputEditTextHintWifiSsid': 'SSID / 网络名称',
    'qrCodeTextInputEditTextHintWifiPassword': '密码',
    'qrCodeTextInputEditTextHintWifiHide': '隐藏',
    'spinnerWifiEncryptionWep': 'WEP',
    'spinnerWifiEncryptionWpa': 'WPA/WPA2',
    'spinnerWifiEncryptionSae': 'WPA3',
    'spinnerWifiEncryptionNone': '无密码',
    // Event Creator
    'qrCodeTextInputEditTextHintAgendaEventName': '事件名称',
    'qrCodeTextInputEditTextHintAgendaPlace': '地点',
    'qrCodeTextInputEditTextHintAgendaDescription': '描述',
    'checkBoxEventAllOfDay': '全天',
    'beginLabel': '开始',
    'endLabel': '结束',

    // URL
    // Custom search URL
    'customSearchUrls': '自定义搜索网址',
    'customUrls': '自定义网址',
    'customSearchUrlsAddUrl': '新增网址',
    'customSearchUrlsModifyUrl': '修改网址',
    'customSearchUrlsList': '网址列表',
    'customSearchUrlsListIsEmptyMessage': '没有项目…\n你尚未产生自定义网址。',
    'popupMessageConfirmationDeletedAllCustomUrls': '你想删除所有自定义网址吗？',
    'customUrlDeleted': '已删除自定义网址！',
    'customUrlAdded': '已增加自定义网址！',
    'customUrlUpdated': '已更新自定义网址！',
    'customSearchUrlsAddInfo': '在网址中使用术语"{code}"。该术语将会在搜索过程中被条码的内容取代。',
    'examples': '例子: ',
    'customSearchUrlsErrorUrl': '网址中必须包含术语: {code}',
    'errorEmptyFields': '输入字段不得为空。',
    'customSearchUrlsisDuplicated': '名称已重复，请输入其他名称。',
    // API Base URL
    // URL Engines
    // E-Commerce Engines
    // API Product Engines
    // API Sources Links
    // API Sources Description
    // Preferences
    'preferencesDefault': '默认',
    // Appearance Settings
    'preferencesAppearanceTitle': '外观',
    'preferencesThemeLabel': '背景颜色',
    'preferencesSwitchSystemThemeLabel': '系统背景',
    'preferencesSwitchLightThemeLabel': '浅色',
    'preferencesSwitchDarkThemeLabel': '深色',
    'preferencesColor': '主题颜色',
    'preferencesColorMaterialYou': '系统 Material You',
    'preferencesColorBlue': '蓝色',
    'preferencesColorOrange': '橘色',
    'preferencesColorGreen': '绿色',
    'preferencesColorRed': '红色',
    'preferencesColorPurple': '紫色',
    // Languages Settings
    'preferencesLanguagesTitle': '语言',
    'preferencesLanguagesChange': '变更语言',
    // Remote API
    // About Remote API
    // Scan Settings
    'preferencesScanTitle': '扫描',
    'preferencesSwitchScanAutoOpenWebsiteLabel': '自动打开网站',
    'preferencesSwitchScanContinuousScanLabel': '连续扫描',
    'preferencesSwitchScanVibrateLabel': '扫描震动',
    'preferencesSwitchScanBipLabel': '播放声音',
    'preferencesSwitchScanScreenRotationLabel': '扫描期间禁用屏幕旋转',
    'preferencesSwitchScanBarcodeCopiedLabel': '复制到剪贴板',
    'preferencesSwitchScanUseFrontcameraLabel': '使用前置摄像头',
    // Barcode Generation Settings
    'preferencesBarcodeGenerationTitle': '条码创建',
    // History settings-->
    'preferencesSwitchScanAddBarcodeToTheHistoryLabel': '加入扫描的条码至历史记录',
    'preferencesSwitchBarcodeGenerationAddBarcodeToTheHistoryLabel': '加入创建的条码至历史记录',
    'preferencesSwitchHistorySaveDuplicatesLabel': '扫描或创建时保留重复项',
    // Search Engine Settings
    'preferencesSearchTitle': '搜索',
    'preferencesSearchEngine': '搜索引擎',
    // Settings: Additional options
    // Shortcuts
    // About Settings
    'preferencesAboutTitle': '关于',
    'preferencesAboutOpenSourceLibrariesLabel': '开源许可证',
    'preferencesApplicationVersionLabel': '应用版本',
    'preferencesSourceCodeLabel': '源代码',
    // About Permissions
    // About BDD
    // About Library Third
    // Countries
  });
}