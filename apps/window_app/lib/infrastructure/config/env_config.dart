import 'package:envied/envied.dart';

part 'env_config.g.dart';

@Envied(path: '../../.env')
abstract class EnvConfig {
  @EnviedField(varName: 'DASHBOARD_URL', defaultValue: 'http://localhost:60500')
  static const String dashboardUrl = _EnvConfig.dashboardUrl;

  @EnviedField(varName: 'DASHBOARD_HOST', defaultValue: 'localhost')
  static const String dashboardHost = _EnvConfig.dashboardHost;

  @EnviedField(varName: 'DASHBOARD_PORT', defaultValue: '60500')
  static const String dashboardPort = _EnvConfig.dashboardPort;

  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _EnvConfig.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _EnvConfig.supabaseAnonKey;
}
