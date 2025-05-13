
//Teste de permissão em tempo de execução 

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
