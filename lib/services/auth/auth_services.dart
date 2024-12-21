import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _supabase;

  AuthServices([SupabaseClient? supabaseClient])
      : _supabase = supabaseClient ?? Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse?> signInWithEmailPassword(
      String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      print("Sign-in error: $error");
      return null;
    }
  }

  // Sign up with email and password
  Future<AuthResponse?> signUpWithEmailPassword(
      String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      print("Sign-up error: $error");
      return null;
    }
  }

  // Sign out
  Future<bool> signOut() async {
    try {
      await _supabase.auth.signOut();
      return true;
    } catch (error) {
      print("Sign-out error: $error");
      return false;
    }
  }

  // Get current user's email
  String? getCurrentUserEmail() {
    return _supabase.auth.currentSession?.user.email;
  }
}
