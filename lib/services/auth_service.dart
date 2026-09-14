import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  //                                                    REGISTRATION

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullname,
    required String businessname,
  }) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullname, 'business_name': businessname},
    );

    final user = response.user;

    if (user == null) {
      throw Exception("Unable to create account");
    }

    return response;
  }

  //                                                      LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return response;
  }

  //                                                    LOGOUT
  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
  }

  //                                              FORGOT PASSWORD
  Future<void> resetPassword(String email) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }
}
