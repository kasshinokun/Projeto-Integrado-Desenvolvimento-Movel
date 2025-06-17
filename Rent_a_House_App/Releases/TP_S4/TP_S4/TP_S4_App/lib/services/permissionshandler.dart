//Teste de permissão em tempo de execução
//flutter pub add permission_handler
import 'package:permission_handler/permission_handler.dart';

//Rode: flutter pub add device_info_plus
import 'package:device_info_plus/device_info_plus.dart';
//Bibliotecas Padrão
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PermissionStatus _cameraPermission;

  Future<void> _checkPermission() async {
    _cameraPermission = await Permission.camera.status;
    if (_cameraPermission != PermissionStatus.granted) {
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
        appBar: AppBar(title: Text('Permission Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Permissão de câmera: ${_cameraPermission.toString()}'),
              ElevatedButton(
                onPressed: () async {
                  await _checkPermission();
                },
                child: Text('Permissão de câmera - checagem'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _checkPermissionBluetooth();
                },
                child: Text('Permissão de Bluetooth - checagem'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await checkAllPermissions();
                },
                child: Text('Permissão em Etapas - checagem'),
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
  if (sdkInt >= 31) {
    //Opcional: mostrar uma justificativa do porquê a permissão é usada no seu app.
    var statuses =
        await [
          Permission.bluetoothScan,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
        ].request();
    if (statuses[Permission.bluetoothScan]!.isDenied) {
      //Opcional: reiterar com uma justificativa do porquê a permissão é usada e necessária no seu app.
      statuses =
          await [
            Permission.bluetoothScan,
            Permission.bluetoothAdvertise,
            Permission.bluetoothConnect,
          ].request();
    }
  }
}

//Maiores detalhes do código abaixo em:
//https://stackoverflow.com/questions/68711126/handling-permission-group-multiple-permissions-at-app-runtime-flutter
//Em etapas(Use no processo que precisar)
Future<void> checkAllPermissions() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = Permission.location.request() as PermissionStatus;
  }
  if (status.isGranted) {
    status = await Permission.bluetoothScan.status;
    if (!status.isGranted) {
      status = await Permission.bluetoothScan.request();
    }
    if (status.isGranted) {
      status = await Permission.bluetoothAdvertise.status;
      if (!status.isGranted) {
        status = await Permission.bluetoothAdvertise.request();
      }
      if (status.isGranted) {
        status = await Permission.bluetoothConnect.status;
        if (!status.isGranted) {
          status = await Permission.bluetoothConnect.request();
        }
        if (status.isGranted) {
          status = await Permission.ignoreBatteryOptimizations.status;
          if (!status.isGranted) {
            status = await Permission.ignoreBatteryOptimizations.request();
          }
          if (status.isGranted) {
            status = await Permission.camera.status;
            if (!status.isGranted) {
              status = await Permission.camera.request();
            }
            if (status.isGranted) {
              /* Estrutura Padrão 
                              var status = await Permission.<>.status;
                              if(!status.isGranted){
                                var status = await Permission.<>.request();
                                }if(status.isGranted){}
                              }else{}<> Negada
                              */
            } else {} //Câmera negada
          } else {} //Ignore Battery Optmizations  negada
        } else {} //Bluetooth Connect negada
      } else {} //Bluetooth Advertise negada
    } else {} //Bluetooth Scan negada
  } else {} //Localização negada
}
