import 'package:asp_asia/module/packages/model/package_model.dart';
import 'package:asp_asia/module/packages/model/package_rate_model.dart';

import 'common_strings.dart';

class CustomFunctions {
  ///show the cheapest rates by sorting hotel category in
  ///ascending order
  int getIndexByHotelCategory(PackageModel packageModel) {
    int rateIndexByHotelCategory = 0;
    List<int> hotelCategoryNumberArray = [];
    packageModel.packageRate?.forEach((element) {
      if (element.hotelCategory != null) {
        int hotelCatNumber =
            int.parse(element.hotelCategory!.replaceAll(RegExp('[^0-9]'), ''));
        hotelCategoryNumberArray.add(hotelCatNumber);
      }
    });
    if (hotelCategoryNumberArray.isNotEmpty) {
      int smallestHotelCategory =
          hotelCategoryNumberArray.reduce((a, b) => a < b ? a : b);
      rateIndexByHotelCategory = packageModel.packageRate!.indexWhere(
          (element) =>
              element.hotelCategory!.contains('$smallestHotelCategory'));
    }
    return rateIndexByHotelCategory;
  }

  ///Function to get rate according to currency selected bu user
  int? packageRateAccordingToCurrencyAndHotelCategory(PackageModel packageModel,
      int rateIndexByHotelCategory, String selectedCurrency) {
    int? packageRate =
        packageModel.packageRate![rateIndexByHotelCategory].rateInUSD;
    if (selectedCurrency == CommonStrings.npr) {
      packageRate =
          packageModel.packageRate![rateIndexByHotelCategory].rateInNPR;
    } else if (selectedCurrency == CommonStrings.bdt) {
      packageRate =
          packageModel.packageRate![rateIndexByHotelCategory].rateInBDT;
    } else if (selectedCurrency == CommonStrings.inr) {
      packageRate =
          packageModel.packageRate![rateIndexByHotelCategory].rateInINR;
    } else if (selectedCurrency == CommonStrings.eur) {
      packageRate =
          packageModel.packageRate![rateIndexByHotelCategory].rateInEUR;
    }
    return packageRate;
  }

  int? packageRateAccordingToCurrency(
      PackageRateModel packageRateModel, String selectedCurrency) {
    int? packageRate = packageRateModel.rateInUSD;
    if (selectedCurrency == CommonStrings.npr) {
      packageRate = packageRateModel.rateInNPR;
    } else if (selectedCurrency == CommonStrings.bdt) {
      packageRate = packageRateModel.rateInBDT;
    } else if (selectedCurrency == CommonStrings.inr) {
      packageRate = packageRateModel.rateInINR;
    } else if (selectedCurrency == CommonStrings.eur) {
      packageRate = packageRateModel.rateInEUR;
    }
    return packageRate;
  }

  bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }
}
