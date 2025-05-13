
//Teste de permissão em tempo de execução 
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PermissionStatus _cameraPermission = PermissionStatus.denied;

  Future<void> _checkPermission() async {
    _cameraPermission = await Permission.camera.status;
    if (_cameraPermission != PermissionStatus.granted) {
      // 許可がされていない場合
      var status = await Permission.camera.request();
      setState(() {
        _cameraPermission = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Permission Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Permissão de câmera: ${_cameraPermission}'),
              ElevatedButton(
                onPressed: () async {
                  await _checkPermission();
                },
                child: Text('Permissão de câmera - checagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Bluetooth -----> carece análise 
Future<void> _checkPermissionBluetooth() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    if(sdkInt>=31) {
      //Opcional: mostrar uma justificativa do porquê a permissão é usada no seu app.
      var statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect
      ].request();
      if (statuses[Permission.bluetoothScan]!.isDenied) {
      //Opcional: reiterar com uma justificativa do porquê a permissão é usada e necessária no seu app.
        statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect
        ].request();
      }
    }
  }
