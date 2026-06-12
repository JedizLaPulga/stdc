// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'src/stdc_base.dart';

/// Entry structure for hash table search.
class ENTRY {
  /// Key for the entry
  String key;
  /// Data associated with the key
  dynamic data;
  /// Creates a new entry
  ENTRY(this.key, this.data);
}

class _TNode {
  dynamic key;
  _TNode? left;
  _TNode? right;
  _TNode(this.key);
}

/// Extension providing `<search.h>` functionality.
extension StdcSearch on Stdc {
  /// Find an entry in the table.
  int get FIND => 0;

  /// Enter an entry into the table.
  int get ENTER => 1;

  static Map<String, ENTRY>? _hsearchTable;

  /// Creates a hash table with at least [nel] elements.
  /// Returns 0 on error, non-zero on success.
  int hcreate(int nel) {
    if (_hsearchTable != null) return 0;
    _hsearchTable = <String, ENTRY>{};
    return 1;
  }

  /// Searches the hash table for an item with the same key as [item].
  /// If [action] is `FIND`, it returns the item or null if not found.
  /// If [action] is `ENTER`, it inserts the item and returns it.
  ENTRY? hsearch(ENTRY item, int action) {
    if (_hsearchTable == null) return null;
    if (action == FIND) {
      return _hsearchTable![item.key];
    } else {
      if (!_hsearchTable!.containsKey(item.key)) {
        _hsearchTable![item.key] = item;
      }
      return _hsearchTable![item.key];
    }
  }

  /// Destroys the hash table.
  void hdestroy() {
    _hsearchTable = null;
  }

  /// Performs a linear search for [key] in [base].
  /// If not found, it appends [key] to [base].
  dynamic lsearch(dynamic key, List<dynamic> base, int Function(dynamic, dynamic) compar) {
    for (int i = 0; i < base.length; i++) {
      if (compar(key, base[i]) == 0) return base[i];
    }
    base.add(key);
    return key;
  }

  /// Performs a linear search for [key] in [base].
  /// Returns null if not found.
  dynamic lfind(dynamic key, List<dynamic> base, int Function(dynamic, dynamic) compar) {
    for (int i = 0; i < base.length; i++) {
      if (compar(key, base[i]) == 0) return base[i];
    }
    return null;
  }

  /// Binary tree search. [rootp] should be a single-element list holding the root node,
  /// or null if empty. If [key] is found, it is returned. Otherwise, it is inserted and returned.
  dynamic tsearch(dynamic key, List<dynamic> rootp, int Function(dynamic, dynamic) compar) {
    if (rootp.isEmpty) rootp.add(null);
    if (rootp[0] == null) {
      rootp[0] = _TNode(key);
      return (rootp[0] as _TNode).key;
    }
    _TNode curr = rootp[0];
    while (true) {
      int c = compar(key, curr.key);
      if (c == 0) return curr.key;
      if (c < 0) {
        if (curr.left == null) {
          curr.left = _TNode(key);
          return curr.left!.key;
        }
        curr = curr.left!;
      } else {
        if (curr.right == null) {
          curr.right = _TNode(key);
          return curr.right!.key;
        }
        curr = curr.right!;
      }
    }
  }

  /// Binary tree find.
  dynamic tfind(dynamic key, List<dynamic> rootp, int Function(dynamic, dynamic) compar) {
    if (rootp.isEmpty || rootp[0] == null) return null;
    _TNode? curr = rootp[0];
    while (curr != null) {
      int c = compar(key, curr.key);
      if (c == 0) return curr.key;
      if (c < 0) {
        curr = curr.left;
      } else {
        curr = curr.right;
      }
    }
    return null;
  }
}
