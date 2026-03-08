class ApiEndpoints {
  ApiEndpoints._();

  // static const String baseUrl = 'http://10.0.2.2:5050';
  static const String baseUrl = 'http://192.168.1.67:5050';

  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';

  // ============ Profile Endpoints ============
  static const String myProfile = '/api/profile/me';
  static const String myDashboard = '/api/profile/me/dashboard';
  static const String myBodyMetrics = '/api/profile/me/body-metrics';
  static const String latestBodyMetric = '/api/profile/me/body-metrics/latest';
  static String deleteBodyMetric(String id) => '/api/profile/me/body-metrics/$id';

  // ============ Goal Endpoints ============
  static const String goals = '/api/goals';
  static const String goalsSummary = '/api/goals/summary';
  static String goalById(String id) => '/api/goals/$id';
  static String completeGoal(String id) => '/api/goals/$id/complete';
  static String abandonGoal(String id) => '/api/goals/$id/abandon';

  // ============ Workout Endpoints ============
  static const String exercises = '/api/workouts/exercises';
  static String exerciseById(String id) => '/api/workouts/exercises/$id';
  static const String plans = '/api/workouts/plans';
  static const String myPlans = '/api/workouts/plans/my';
  static const String publicPlans = '/api/workouts/plans/public';
  static String planById(String id) => '/api/workouts/plans/$id';

  // ============ Analytics Endpoints ============
  static const String analyticsDashboard = '/api/analytics/dashboard';
  static const String analyticsBody = '/api/analytics/body';
  static const String analyticsMeasurements = '/api/analytics/measurements';
  static const String analyticsGoals = '/api/analytics/goals';
  static const String analyticsWorkouts = '/api/analytics/workouts';

  // ============ User Endpoints ============
  static const String user = '/users';
  static String userById(String id) => '/users/$id';
}
