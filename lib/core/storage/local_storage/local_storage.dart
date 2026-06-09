/// Abstract contract for local key-value storage.
///
/// Implementations (SharedPreferences, Hive, …) must honour this interface.
/// Reads are synchronous — implementations are expected to pre-load data into
/// memory during initialisation. Writes are async to allow I/O persistence.
abstract class LocalStorage {
  static const kPhoneNumberKey = 'phone_number';

  Future<void> setPhoneNumber({required String? value});
  String getPhoneNumber();

  Future<void> remove(String key);
  Future<void> clear();
  bool containsKey(String key);
}
