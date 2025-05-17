import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/common/models/history_item.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:string_validator/string_validator.dart';
import 'package:barcode/barcode.dart';

class BarcodeTextField extends StatelessWidget {
  final HistoryFormat? format;
  final String name;
  final GlobalKey<FormBuilderState> formKey;
  final String? initialValue;

  const BarcodeTextField({
    super.key,
    required this.format,
    required this.name,
    required this.formKey,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context);
    final isNumbers = format?.isNumbers ?? false;
    return FormBuilderTextField(
      name: name,
      maxLines: _allowLineBreaks,
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(isNumbers ? Icons.pin_outlined : Icons.format_size),
        labelText: format?.composition(localeStr) ?? localeStr.barcodeTextCompositionLabel,
        errorMaxLines: 8,
      ),
      keyboardType: isNumbers ? TextInputType.number : null,
      validator: (value) => barcodeValidator(value, format, localeStr),
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
    HistoryFormat.codebar,
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
    HistoryFormat.codebar: 20,
    HistoryFormat.itf: 20,
  }[this];

  int? get hardLength => const <HistoryFormat, int>{
    HistoryFormat.ean13: 13,
    HistoryFormat.ean8: 8,
    HistoryFormat.upcA: 12,
    HistoryFormat.upcE: 8,
  }[this];

  String? encodingErrorMessage(Language localeStr) => <HistoryFormat, String>{
    HistoryFormat.aztec: localeStr.errorBarcodeEncodingIso88591ErrorMessage,
    HistoryFormat.dataMatrix: localeStr.errorBarcodeEncodingIso88591ErrorMessage,
    HistoryFormat.code128: localeStr.errorBarcodeEncodingUsAsciiErrorMessage,
    HistoryFormat.code93: localeStr.errorBarcode93RegexErrorMessage,
    HistoryFormat.code39: localeStr.errorBarcode39RegexErrorMessage,
  }[this];

  bool get hasCheckDigit => const <HistoryFormat>{
    HistoryFormat.ean13,
    HistoryFormat.ean8,
    HistoryFormat.upcA,
    HistoryFormat.upcE,
  }.contains(this);
}

String? barcodeValidator(String? value, HistoryFormat? format, Language localeStr){
  if (value==null || value.replaceAll('\n', '').replaceAll(' ', '').isEmpty) {
    return localeStr.errorEmptyFields;
  } else if (format == null) {
    return null;
  }

  final bool isNumbers = format.isNumbers;
  final int? maxLength = format.maxLength;
  final int? hardLength = format.hardLength;
  final String? encodingErrorMessage = format.encodingErrorMessage(localeStr);
  final barcodeFunc = format.barcodeFunc;

  if (isNumbers && !value.isNumeric) {
    return localeStr.errorBarcodeNotANumberMessage;
  }
  if (format == HistoryFormat.upcE && value[0] != '0') {
    return localeStr.errorBarcodeUpcENotStartWith0ErrorMessage;
  }
  if (format == HistoryFormat.itf && (value.length % 2) != 0) {
    return localeStr.errorBarcodeItfErrorMessage;
  }
  if (maxLength != null && value.length > maxLength) {
    return '${localeStr.errorBarcodeWrongLengthMessage}< $maxLength';
  }
  if (hardLength != null && value.length != hardLength) {
    return '${localeStr.errorBarcodeWrongLengthMessage}$hardLength';
  }
  if (encodingErrorMessage != null && !barcodeFunc().isValid(value)) {
    return encodingErrorMessage;
  }
  if (format.hasCheckDigit) {
    final String checkDigit = _trytoFindCheck(value, format.barcodeFunc);
    if (value[value.length - 1] != checkDigit) {
      return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
    }
  }
  if (format == HistoryFormat.code128 && !value.isAscii) {
    return localeStr.errorBarcodeEncodingUsAsciiErrorMessage;
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