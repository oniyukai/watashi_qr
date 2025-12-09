import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:string_validator/string_validator.dart';
import 'package:barcode/barcode.dart';
import 'package:watashi_qr/locale/app_language.dart';

class BarcodeField extends StatelessWidget {
  const BarcodeField({
    super.key,
    required this.format,
    required this.name,
    required this.formKey,
    this.initialValue,
  });

  final HistoryFormat? format;
  final String name;
  final GlobalKey<FormBuilderState> formKey;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final isNumbers = format?.isNumbers ?? false;
    return FormBuilderTextField(
      name: name,
      maxLines: _allowLineBreaks,
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(isNumbers ? Icons.pin_outlined : Icons.format_size),
        labelText: format?.composition ?? AppLocale.barcodeTextCompositionLabel.s,
        errorMaxLines: 8,
      ),
      keyboardType: isNumbers ? TextInputType.number : null,
      validator: (value) => barcodeValidator(value, format),
      onEditingComplete: () {
        formKey.currentState?.fields[name]?.validate();
      },
    );
  }

  int? get _allowLineBreaks => const <HistoryFormat>{
    HistoryFormat.qrCode,
    HistoryFormat.dataMatrix,
    HistoryFormat.aztec,
    HistoryFormat.pdf417,
    HistoryFormat.code128
  }.contains(format) ? null : 1;
}

extension _HistoryFormatForValid on HistoryFormat {
  bool get isNumbers => const <HistoryFormat>{
    HistoryFormat.ean13,
    HistoryFormat.ean8,
    HistoryFormat.upcA,
    HistoryFormat.upcE,
    HistoryFormat.codabar,
    HistoryFormat.itf
  }.contains(this);

  int? get maxLength => const <HistoryFormat, int>{
    HistoryFormat.qrCode: 2953,
    HistoryFormat.pdf417: 990,
    HistoryFormat.aztec: 2335,
    HistoryFormat.dataMatrix: 1559,
    HistoryFormat.code128: 2046,
    HistoryFormat.code93: 47,
    HistoryFormat.code39: 43,
    HistoryFormat.codabar: 20,
    HistoryFormat.itf: 20,
  }[this];

  int? get hardLength => const <HistoryFormat, int>{
    HistoryFormat.ean13: 13,
    HistoryFormat.ean8: 8,
    HistoryFormat.upcA: 12,
    HistoryFormat.upcE: 8,
  }[this];

  String? get encodingErrorMessage => <HistoryFormat, String>{
    HistoryFormat.aztec: AppLocale.errorBarcodeEncodingIso88591ErrorMessage.s,
    HistoryFormat.dataMatrix: AppLocale.errorBarcodeEncodingIso88591ErrorMessage.s,
    HistoryFormat.code128: AppLocale.errorBarcodeEncodingUsAsciiErrorMessage.s,
    HistoryFormat.code93: AppLocale.errorBarcode93RegexErrorMessage.s,
    HistoryFormat.code39: AppLocale.errorBarcode39RegexErrorMessage.s,
  }[this];

  bool get hasCheckDigit => const <HistoryFormat>{
    HistoryFormat.ean13,
    HistoryFormat.ean8,
    HistoryFormat.upcA,
    HistoryFormat.upcE,
  }.contains(this);
}

String? barcodeValidator(String? value, HistoryFormat? format){
  if (value==null || value.replaceAll('\n', '').replaceAll(' ', '').isEmpty) {
    return AppLocale.errorEmptyFields.s;
  } else if (format == null) {
    return null;
  }

  final bool isNumbers = format.isNumbers;
  final int? maxLength = format.maxLength;
  final int? hardLength = format.hardLength;
  final String? encodingErrorMessage = format.encodingErrorMessage;
  final barcodeFunc = format.barcodeFunc;

  if (isNumbers && !value.isNumeric) {
    return AppLocale.errorBarcodeNotANumberMessage.s;
  }
  if (format == HistoryFormat.upcE && value[0] != '0') {
    return AppLocale.errorBarcodeUpcENotStartWith0ErrorMessage.s;
  }
  if (format == HistoryFormat.itf && (value.length % 2) != 0) {
    return AppLocale.errorBarcodeItfErrorMessage.s;
  }
  if (maxLength != null && value.length > maxLength) {
    return '${AppLocale.errorBarcodeWrongLengthMessage.s}< $maxLength';
  }
  if (hardLength != null && value.length != hardLength) {
    return '${AppLocale.errorBarcodeWrongLengthMessage.s}$hardLength';
  }
  if (encodingErrorMessage != null && !barcodeFunc().isValid(value)) {
    return encodingErrorMessage;
  }
  if (format.hasCheckDigit) {
    final String checkDigit = _trytoFindCheck(value, format.barcodeFunc);
    if (value[value.length - 1] != checkDigit) {
      return '${AppLocale.errorBarcodeWrongKeyMessage.s}$checkDigit';
    }
  }
  if (format == HistoryFormat.code128 && !value.isAscii) {
    return AppLocale.errorBarcodeEncodingUsAsciiErrorMessage.s;
  }
  return null;
}

String _trytoFindCheck(String value, Barcode Function() codeType) {
  final valueNoCheck = value.substring(0, value.length - 1);
  for (int i=0; i < 10; i++) {
    final bool isValid = codeType().isValid('$valueNoCheck$i');
    if (isValid) return i.toString();
  }
  return value[value.length - 1];
}