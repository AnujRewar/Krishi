import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lbhpntmxvqfmlszwqnrc.supabase.co',
    anonKey: 'sb_publishable_mPJ_kM_nJX1oc89UdHh_yQ_Kc_RFjC5',
  );

  runApp(const App());
}
