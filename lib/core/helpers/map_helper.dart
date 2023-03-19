extension MapEntryIterableHelper<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() {
    return Map<K, V>.fromEntries(this);
  }
}
