import 'package:shared_preferences/shared_preferences.dart';

class ServerConfig {
  static const _keyIp = 'server_ip';
  static const _keyPort = 'server_port';

  //  IP laptop 
  static const String defaultIp = '192.168.56.1';
  static const String defaultPort = '8000';

  static Future<String> getIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyIp) ?? defaultIp;
  }

  static Future<String> getPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPort) ?? defaultPort;
  }

  static Future<void> setServer(String ip, String port) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyIp, ip);
    await prefs.setString(_keyPort, port);
  }

  static Future<String> getBaseUrl() async {
    final ip = await getIp();
    final port = await getPort();
    return 'http://$ip:$port';
  }
}