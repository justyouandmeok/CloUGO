import 'package:supabase_flutter/supabase_flutter.dart';

class Sb {
  static const url = 'https://pqclcoegyhyjzpxflvdm.supabase.co';
  static const anon = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxY2xjb2VneWh5anpweGZsdmRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA5OTcwODAsImV4cCI6MjEwNjU3MzA4MH0.q54neSIw-_-sW-IfezwaXON4QvPAeK7jOw2Aee-_SWQ';
  static SupabaseClient get c => Supabase.instance.client;
  static User? get user => c.auth.currentUser;
}
