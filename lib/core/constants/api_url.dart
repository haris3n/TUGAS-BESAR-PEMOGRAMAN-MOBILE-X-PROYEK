class ApiUrl {
  // --- BASE URL NGROK ---
  // Pastikan tidak ada slash (/) di akhir
  static const String baseUrl = 'https://unbeaded-unbargained-kori.ngrok-free.dev/api';

  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  
  // PINTU KHUSUS TRACKER (SESUAIKAN DENGAN API.PHP)
  static const String targets = '$baseUrl/targets'; // Untuk setTarget
  
  static const String water = '$baseUrl/water';     // Untuk addWater
  static const String steps = '$baseUrl/steps';     // Untuk updateSteps
  static const String workout = '$baseUrl/workout'; // Untuk addWorkout
  
  static const String dashboard = '$baseUrl/dashboard';
}