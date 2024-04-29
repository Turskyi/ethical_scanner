import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  // You can customize the behavior of specific methods if needed
  // For example, mock the behavior of getInstance
  static Future<MockSharedPreferences> getInstance() async {
    final MockSharedPreferences mock = MockSharedPreferences();
    // Customize behavior as needed
    // when(mock.getString('')).thenReturn(null); // Example behavior, customize as needed
    return Future<MockSharedPreferences>.value(mock);
  }

  // Mock the setString method
  @override
  Future<bool> setString(String key, String value) {
    return Future<bool>.value(true); // Always return true for testing
  }

  // Mock the getString method
  @override
  String? getString(String key) {
    return 'mock'; // Always return 'mock' for testing
  }

  // Mock the setBool method
  @override
  Future<bool> setBool(String key, bool value) {
    return Future<bool>.value(true); // Always return true for testing
  }

  // Mock the getBool method
  @override
  bool? getBool(String key) {
    return true; // Always return true for testing
  }
}
