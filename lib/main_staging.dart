import 'package:wavica/app.dart';
import 'package:wavica/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
