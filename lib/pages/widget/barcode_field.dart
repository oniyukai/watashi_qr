import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/entity/history_format.dart';
import 'package:barcode/barcode.dart';
import 'package:watashi_qr/locale/app_language.dart';

class BarcodeField extends StatelessWidget {
  final HistoryFormat? format;
  final String name;
  final String? initialValue;

  const BarcodeField({
    super.key,
    required this.format,
    required this.name,
    this.initialValue,
  });

  @override
  Widget build(context) {
    final bool isNumbers = format?.isNumbers ?? false;
    return FormBuilderTextField(
      name: name,
      keyboardType: isNumbers ? .number : null,
      autovalidateMode: .onUserInteraction,
      maxLines: format?.allowLineBreaks,
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(isNumbers ? Icons.pin_outlined : Icons.format_size),
        labelText: format?.composition ?? AppLocale.barcodeTextCompositionLabel.s,
        errorMaxLines: 8,
      ),
      validator: (value) => barcodeValidator(value, format),
    );
  }
}

extension _HistoryFormatForValid on HistoryFormat {
  int? get allowLineBreaks => const <HistoryFormat>[
    .qrCode, .dataMatrix, .aztec, .pdf417, .code128
  ].contains(this) ? null : 1;

  bool get isNumbers => const <HistoryFormat>[
    .ean13, .ean8, .upcA, .upcE, .itf
  ].contains(this);

  int? get maxByteLength => switch (this) {
    .qrCode => 2953,
    .pdf417 => 990,
    .aztec => 2335,
    .dataMatrix => 1559,
    _ => null
  };

  int? get maxLength => switch (this) {
    .code128 => 2046,
    .code93 => 47,
    .code39 => 43,
    .codabar => 20,
    .itf => 20,
    _ => null
  };

  int? get hardLength => switch (this) {
    .ean13 => 13,
    .ean8 => 8,
    .upcA => 12,
    .upcE => 8,
    _ => null
  };

  String? get encodingErrorMessage => switch (this) {
    .aztec => AppLocale.errorBarcodeEncodingIso88591ErrorMessage,
    .dataMatrix => AppLocale.errorBarcodeEncodingIso88591ErrorMessage,
    .code128 => AppLocale.errorBarcodeEncodingUsAsciiErrorMessage,
    .code93 => AppLocale.errorBarcode93RegexErrorMessage,
    .code39 => AppLocale.errorBarcode39RegexErrorMessage,
    .codabar=> AppLocale.errorBarcodeCodabarRegexErrorMessage,
    _ => null
  }?.s;

  bool get hasCheckDigit => const <HistoryFormat>[
    .ean13, .ean8, .upcA, .upcE,
  ].contains(this);
}

String? barcodeValidator(String? value, HistoryFormat? format){
  if (value == null || value.replaceAll('\n', '').replaceAll(' ', '').isEmpty) {
    return AppLocale.errorEmptyFields.s;
  } else if (format == null) {
    return null;
  }

  final bool isNumbers = format.isNumbers;
  final int? maxByteLength = format.maxByteLength;
  final int? maxLength = format.maxLength;
  final int? hardLength = format.hardLength;
  final String? encodingErrorMessage = format.encodingErrorMessage;
  final ValueGetter<Barcode> barcodeFunc = format.barcodeFunc;

  if (isNumbers && !value.codeUnits.every((u) => u >= 48 && u <= 57)) {
    return AppLocale.errorBarcodeNotANumberMessage.s;
  }
  if (format == .upcE && value[0] != '0') {
    return AppLocale.errorBarcodeUpcENotStartWith0ErrorMessage.s;
  }
  if (format == .itf && (value.length % 2) != 0) {
    return AppLocale.errorBarcodeItfErrorMessage.s;
  }
  if (maxByteLength != null && utf8.encode(value).length > maxByteLength) {
    return '${AppLocale.errorBarcodeWrongLengthMessage.s}< $maxByteLength (Bytes)';
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
    final String checkDigit = _tryFindCheck(value, format.barcodeFunc);
    if (value[value.length - 1] != checkDigit) {
      return '${AppLocale.errorBarcodeWrongKeyMessage.s}$checkDigit';
    }
  }
  try {
    format.barcodeFunc().verify(value);
  } catch (e) {
    return e.toString();
  }
  return null;
}

String _tryFindCheck(String value, ValueGetter<Barcode> codeType) {
  final String valueNoCheck = value.substring(0, value.length - 1);
  for (int i=0; i < 10; i++) {
    final bool isValid = codeType().isValid('$valueNoCheck$i');
    if (isValid) return i.toString();
  }
  return value[value.length - 1];
}
