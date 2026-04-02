class ProfileUtils {
  /// Generates a simple 32-bit hash from a username and profile picture path.
  /// This is used in BLE advertisements to detect profile updates.
  static int generateProfileHash(String username, String? profilePicturePath) {
    String data = "$username${profilePicturePath ?? ''}";
    int hash = 0;
    for (int i = 0; i < data.length; i++) {
      hash = (31 * hash + data.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash;
  }
}
