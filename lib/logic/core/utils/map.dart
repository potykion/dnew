extension MapUtils<K, V> on Map<K, V> {
  K? keyByValue(V value) {
    try {
      return entries.where((e) => e.value == value).first.key;
    } on StateError {
      return null;
    }
  }
}
