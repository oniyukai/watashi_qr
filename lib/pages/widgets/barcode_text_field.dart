import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:watashi_qr/common/utils.dart';
import 'package:watashi_qr/locale/language.dart';
import 'package:string_validator/string_validator.dart';
import 'package:barcode/barcode.dart';

class BarcodeTextField extends StatelessWidget {
  final String barcodeType;
  final String name;
  final GlobalKey<FormBuilderState> formKey;
  final String? initialValue;

  const BarcodeTextField({
    super.key,
    required this.barcodeType,
    required this.name,
    required this.formKey,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final localeStr = Language.of(context)!;
    return FormBuilderTextField(
      name: name,
      maxLines: _allowLineBreaks(),
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(_isRequestNumbers() ? Icons.pin_outlined : Icons.format_size),
        labelText: Utils.formatNameComposition(barcodeType, localeStr),
        errorMaxLines: 8,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: _isRequestNumbers() ? TextInputType.number : null,
      validator: (value) => _barcodeValidators(value, localeStr),
      onEditingComplete: () {
        formKey.currentState?.fields[name]?.validate();
      },
    );
  }

  int? _allowLineBreaks() {
    final allowList = const <String>[
      'QR_CODE',
      'DATA_MATRIX',
      'AZTEC',
      'PDF_417',
      'Code_128'
    ];
    return (allowList.contains(barcodeType)) ? null : 1;
  }

  bool _isRequestNumbers() {
    final isNumbersList = const <String>[
      'EAN_13',
      'EAN_8',
      'UPC_A',
      'UPC_E',
      'CODABAR',
      'IFT',
    ];
    return isNumbersList.contains(barcodeType);
  }

  String? _barcodeValidators(String? value, Language localeStr){
    if (value==null || value.replaceAll('\n', '').replaceAll(' ', '').isEmpty ) {
      return localeStr.errorBarcodeNoneCharacterMessage;
    } else if (_isRequestNumbers() && !value.isNumeric) {
      return localeStr.errorBarcodeNotANumberMessage;
    }
    switch (barcodeType) {
      case 'QR_CODE':
        if (value.length > 4296) {
          return localeStr.error;
        }
        break;
      case 'PDF_417':
        break;
      case 'AZTEC':
        if (value.length > 3832) {
          return localeStr.error;
        }
        final isValid = Barcode.aztec().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcodeEncodingIso88591ErrorMessage;
        }
        break;
      case 'DATA_MATRIX':
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
      case 'EAN_13':
        if (value.length != 13) {
          return '${localeStr.errorBarcodeWrongLengthMessage}13';
        }
        String checkDigit = _trytoFindCheck(value, Barcode.ean13);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case 'EAN_8':
        if (value.length != 8) {
          return '${localeStr.errorBarcodeWrongLengthMessage}8';
        }
        String checkDigit = _trytoFindCheck(value, Barcode.ean8);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case 'UPC_A':
        if (value.length != 12) {
          return '${localeStr.errorBarcodeWrongLengthMessage}12';
        }
        String checkDigit = _trytoFindCheck(value, Barcode.upcA);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case 'UPC_E':
        if (value[0] != '0') {
          return localeStr.errorBarcodeUpcENotStartWith0ErrorMessage;
        }
        if (value.length != 8) {
          return '${localeStr.errorBarcodeWrongLengthMessage}8';
        }
        String checkDigit = _trytoFindCheck(value, Barcode.upcE);
        if (value[value.length - 1] != checkDigit) {
          return '${localeStr.errorBarcodeWrongKeyMessage}$checkDigit';
        }
        break;
      case 'Code_128':
        if (value.length > 2046) {
          return localeStr.error;
        }
        final isValid = Barcode.code128().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcodeEncodingUsAsciiErrorMessage;
        }
        break;
      case 'Code_93':
        if (value.length > 47) {
          return localeStr.error;
        }
        final fixedValue = value.replaceAll('*', '0');
        final isValid = Barcode.code93().isValid(fixedValue);
        if (!isValid) {
          return localeStr.errorBarcode93RegexErrorMessage;
        }
        break;
      case 'Code_39':
        if (value.length > 43) {
          return localeStr.error;
        }
        final isValid = Barcode.code39().isValid(value);
        if (!isValid) {
          return localeStr.errorBarcode39RegexErrorMessage;
        }
        break;
      case 'CODABAR':
        if (value.length > 20) {
          return localeStr.error;
        }
        break;
      case 'IFT':
        if (value.length > 20) {
          return localeStr.error;
        }
        if ((value.length % 2) != 0) {
          return localeStr.errorBarcodeItfErrorMessage;
        }
        break;
    }
    return null;
  }

  String _trytoFindCheck(String value, Function codeType) {
    final valueNoCheck = value.substring(0, value.length - 1);
    for (int i=0; i < 10; i++) {
      bool isValid = codeType().isValid('$valueNoCheck$i');
      if (isValid) return i.toString();
    }
    return value[value.length - 1];
  }

}