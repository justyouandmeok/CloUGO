import 'package:supabase_flutter/supabase_flutter.dart';

class Sb {
  static const url = 'https://kfprbacbmvsxshzfufvr.supabase.co';
  static const anon = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmcHJiYWNibXZzeHNoemZ1ZnZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA5OTY4NDAsImV4cCI6MjEwNjU3Mjg0MH0.JQnTD8pdzBTjpIdi4zjwzhvIjXJn56O_-1f1e1UK11I';
  static SupabaseClient get c => Supabase.instance.client;
  static User? get user => c.auth.currentUser;
}
