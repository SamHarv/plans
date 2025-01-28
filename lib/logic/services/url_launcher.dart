import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  /// Launch O2Tech website
  final _url = Uri.parse('https://o2tech.com.au');

  Future<void> launchO2Tech() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
