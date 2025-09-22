import 'package:wavica/app/app.dart';
import 'package:wavica/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
