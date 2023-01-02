import 'dart:io';

class AdHelper {
  //Bottom nav stickey ad banner
  static String get getAndroidBtmBarBannerAddUnit {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/8350131952";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/5532396923";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  //Home banner add
  static String get getAndroidHomeBannerAddUnit {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/7294108103";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/7793635706";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  //all games banner add
  static String get getAndroidAllGamePageBannerAddUnit {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/5094448033";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/6511525385  ";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  //all games banner add
  static String get getAndroidGameHistoryPageBannerAddUnit {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/9405405748";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/2648425708  ";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  static String get getAndroidHotEventPageBannerAddUnit {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/5099824063";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/7534415713";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  static String get getAndroidDetailedPageBannerAddUnit {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/7062313436";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/2001558446";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  // interstitial ads
  static String get getInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6750553580179806/1972425860";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6750553580179806/9850915886";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }
}
