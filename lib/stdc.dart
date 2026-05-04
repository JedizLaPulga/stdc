/// A unified entrypoint for the `stdc` library.
/// 
/// You can import this to get access to all available headers at once,
/// or you can import specific headers like `import 'package:stdc/math.dart';`
/// for a more authentic C experience.
library stdc;

export 'src/stdc_base.dart';
export 'math.dart';
export 'ctype.dart';
