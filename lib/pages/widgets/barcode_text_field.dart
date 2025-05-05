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
    return FormBuilderTextField(
      name: name,
      maxLines: _allowLineBreaks,
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(_isRequestNumbers ? Icons.pin_outlined : Icons.format_size),
        labelText: HistoryFormat.composition(format, localeStr),
        errorMaxLines: 8,
      ),
      keyboardType: _isRequestNumbers ? TextInputType.number : null,
      validator: (value) => _barcodeValidators(value, localeStr),
      onEditingComplete: () {
        formKey.currentState?.fields[name]?.validate();
      },
    );
  }

  int? get _allowLineBreaks => const <HistoryFormat>[
    HistoryFormat.qrCode,
    HistoryFormat.dataMatrix,
    HistoryFormat.aztec,
    HistoryFormat.pdf417,
    HistoryFormat.code128
  ].contains(format) ? null : 1;

  bool get _isRequestNumbers => const <HistoryFormat>[
    HistoryFormat.ean13,
    HistoryFormat.ean8,
    HistoryFormat.upcA,
    HistoryFormat.upcE,
    HistoryFormat.codebar,
    HistoryFormat.itf
  ].contains(format);

  String? _barcodeValidators(String? value, Language localeStr){
    if (value==null || value.replaceAll('\n', '').replaceAll(' ', '').isEmpty ) {
      return localeStr.errorBarcodeNoneCharacterMessage;
    } else if (_isRequestNumbers && !value.isNumeric) {
      return localeStr.errorBarcodeNotANumberMessage;
    }
    switch (format) {
      case HistoryFormat.qrCode:
        if (value.length > 4296) {
          return localeStr.error;
        }
        break;
      case HistoryFormat.pdf417:
        break;
      case HistoryFormat.aztec:
        if (value.length > 3832) {
          return localeStr.error;
        }
        final isValid = Barcode.aztec().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcodeEncodingIso88591ErrorMessage;
        }
        break;
      case HistoryFormat.dataMatrix:
        if (value.length > 2335) {
          return localeStr.error;
        }
        bool isValid = Barcode.dataMatrix().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcodeEncodingUsAsciiErrorMessage;
        }
        for (int i = 0; i < value.length; i++) {
          if (value.codeUnitAt(i) > 255) {
            isValid = false;
            break;
          }
        }
        if ( !isValid && !value.isAscii ) {
          return localeStr.errorBarcodeEncodingIso88591ErrorMessage;
        }
        break;
      case HistoryFormat.ean13:
        if (value.length != 13) {
          return '${localeStr.errorBarcodeWrongLengthMessage}13';
        }
        final String checkDigit = _trytoFindCheck(value, Barcode.ean13);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case HistoryFormat.ean8:
        if (value.length != 8) {
          return '${localeStr.errorBarcodeWrongLengthMessage}8';
        }
        final String checkDigit = _trytoFindCheck(value, Barcode.ean8);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case HistoryFormat.upcA:
        if (value.length != 12) {
          return '${localeStr.errorBarcodeWrongLengthMessage}12';
        }
        final String checkDigit = _trytoFindCheck(value, Barcode.upcA);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case HistoryFormat.upcE:
        if (value[0] != '0') {
          return localeStr.errorBarcodeUpcENotStartWith0ErrorMessage;
        }
        if (value.length != 8) {
          return '${localeStr.errorBarcodeWrongLengthMessage}8';
        }
        final String checkDigit = _trytoFindCheck(value, Barcode.upcE);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case HistoryFormat.code128:
        if (value.length > 2046) {
          return localeStr.error;
        }
        final isValid = Barcode.code128().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcodeEncodingUsAsciiErrorMessage;
        }
        break;
      case HistoryFormat.code93:
        if (value.length > 47) {
          return localeStr.error;
        }
        final fixedValue = value.replaceAll('*', '0');
        final isValid = Barcode.code93().isValid(fixedValue);
        if (!isValid) {
          return localeStr.errorBarcode93RegexErrorMessage;
        }
        break;
      case HistoryFormat.code39:
        if (value.length > 43) {
          return localeStr.error;
        }
        final isValid = Barcode.code39().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcode39RegexErrorMessage;
        }
        break;
      case HistoryFormat.codebar:
        if (value.length > 20) {
          return localeStr.error;
        }
        break;
      case HistoryFormat.itf:
        if (value.length > 20) {
          return localeStr.error;
        }
        if ((value.length % 2) != 0) {
          return localeStr.errorBarcodeItfErrorMessage;
        }
        break;
      default:
    }
    return null;
  }

  String _trytoFindCheck(String value, Function codeType) {
    final valueNoCheck = value.substring(0, value.length - 1);
    for (int i=0; i < 10; i++) {
      final bool isValid = codeType().isValid('$valueNoCheck$i');
      if (isValid) return i.toString();
    }
    return value[value.length - 1];
  }

}