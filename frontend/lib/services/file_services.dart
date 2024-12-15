import 'package:flutter/material.dart';

class FileServices {
  static final textControllerKeys = [
    'usernameLogin',
    'passwordLogin',
    'usernameSignup',
    'passwordSignup',
    'confirmPasswordSignup',
    'roleSignup',
    'manufacturingDate',
    'productName',
    'batchNumber',
    'expirationDate',
    'packageCount',
    'pricing',
    'dateInventory',
    'productNameInventory',
    'producedQuantity',
    'productNameSales',
    'dateSales',
    'soldQuantity',
    'unsoldQuantity',
    'totalSalesAmount',
  ];

  static Map<String, TextEditingController> textControllers = {
    for (var key in textControllerKeys) key: TextEditingController()
  };

  static bool obscurePassword = true;
  static bool obscureConfirmPassword = true;

  static bool get areLoginInputFieldsEmpty {
    return [
      textControllers['usernameLogin']?.text,
      textControllers['passwordLogin']?.text,
    ].any((text) => text?.isEmpty ?? true);
  }

  static bool get areSignUpInputFieldsEmpty {
    return [
      textControllers['usernameSignup']?.text,
      textControllers['passwordSignup']?.text,
      textControllers['confirmPasswordSignup']?.text,
      textControllers['roleSignup']?.text,
    ].any((text) => text?.isEmpty ?? true);
  }

  static bool get areProductFieldsEmpty {
    return [
      textControllers['manufacturingDate']?.text,
      textControllers['productName']?.text,
      textControllers['packageCount']?.text,
      textControllers['pricing']?.text,
    ].any((text) => text?.isEmpty ?? true);
  }

  static bool get areInventoryFieldsEmpty {
    return [
      textControllers['dateInventory']?.text,
      textControllers['productNameInventory']?.text,
      textControllers['batchNumber']?.text,
      textControllers['expirationDate']?.text,
      textControllers['producedQuantity']?.text,
    ].any((text) => text?.isEmpty ?? true);
  }

  static bool get areSalesFieldsEmpty {
    return [
      textControllers['dateSales']?.text,
      textControllers['productNameSales']?.text,
      textControllers['soldQuantity']?.text,
      textControllers['totalSalesAmount']?.text,
      textControllers['unsoldQuantity']?.text,
    ].any((text) => text?.isEmpty ?? true);
  }

  static void clearLoginInputFields() {
    textControllers['usernameLogin']?.clear();
    textControllers['passwordLogin']?.clear();
  }

  static void clearSignupInputFields() {
    textControllers['usernameSignup']?.clear();
    textControllers['passwordSignup']?.clear();
    textControllers['confirmPasswordSignup']?.clear();
    textControllers['roleSignup']?.clear();
  }

  static void clearproductFields() {
    textControllers['manufacturingDate']?.clear();
    textControllers['productName']?.clear();
    textControllers['packageCount']?.clear();
    textControllers['pricing']?.clear();
  }

  static void clearInventoryFields() {
    textControllers['dateInventory']?.clear();
    textControllers['productNameInventory']?.clear();
    textControllers['batchNumber']?.clear();
    textControllers['expirationDate']?.clear();
    textControllers['producedQuantity']?.clear();
  }

  static void clearSalesFields() {
    textControllers['dateSales']?.clear();
    textControllers['quantitySoldSales']?.clear();
    textControllers['soldQuantity']?.clear();
    textControllers['unsoldQuantity']?.clear();
    textControllers['totalSalesAmount']?.clear();
  }

  static String? validateUsername(String firstName) {
    if (firstName.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$').hasMatch(password)) {
      return 'Password must contain upper, lower, and numeric characters';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
