// Conditional export: agar `dart:html` available ho (web build) to
// _web.dart use hoga, warna (mobile/desktop) _stub.dart use hoga.
// Baaki app is file ko hi import karega, kabhi dart:html directly nahi.

export 'browser_diagnostics_stub.dart'
    if (dart.library.html) 'browser_diagnostics_web.dart';
