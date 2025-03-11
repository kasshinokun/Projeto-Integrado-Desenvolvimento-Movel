
PAUSE ---------Indo pasta a pasta documentos 

set USERDOCS=%USERPROFILE%\Documents

cd %USERDOCS%

PAUSE ---------Criando pasta

mkdir TP_S1

cd TP_S1

PAUSE ---------Criando projeto 

flutter create --org com.grupo.rentahouse --platform android,web,windows --project-name rent_a_house ./

PAUSE ---------Entrando na pasta

code .\

PAUSE ---------Processo Finalizado
