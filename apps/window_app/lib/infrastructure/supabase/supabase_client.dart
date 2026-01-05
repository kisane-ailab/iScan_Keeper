import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_client.g.dart';

const _supabaseUrl = 'https://xsufebgbzqlovqvdlura.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhzdWZlYmdienFsb3ZxdmRsdXJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU5NjQ0NTYsImV4cCI6MjA4MTU0MDQ1Nn0.-zRk5Gy457NXetUSmXAMALZycD5OzTZGfum1HXaFxRE';

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Supabase 초기화 유틸리티
class SupabaseInitializer {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 2,
      ),
    );
  }
}
