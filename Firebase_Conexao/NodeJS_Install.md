### Instalação do NodeJS e NPM no Windows

o NodeJS depende do Python, VS Redistributable C++ e Chocolatey
<br>mas seu pacote .msi já possui as dependências.
<br>
<br>Mas é bompossui os instaladores em caso de erro.
<br>```NodeJS:```
<br>Acesse:
<br>English-US: ```https://nodejs.org/en/download```
<br>Portugues-PT: ```https://nodejs.org/pt/download```
<br>Español-ES: ```https://nodejs.org/es/download```
<br>
<br>```VS Redistributable C++:```
<br>English-US: ```https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170```
<br>Portugues-BR: ```https://learn.microsoft.com/pt-br/cpp/windows/latest-supported-vc-redist?view=msvc-170```
<br>Español-ES: ```https://learn.microsoft.com/es-es/cpp/windows/latest-supported-vc-redist?view=msvc-170```
<br>
<br>```Python:```
<br>English-US:```https://www.python.org/downloads/```, clique sobre ```Download Python 3.13.3```
<br>
<br>Clique sobre o pacote .msi do NodeJS será aberto o CMD pode apresentar erros durante e após.

#### Erros possíveis
Ao usar o ```Windows 11 Education com 2 usuários e já tendo o Python, VS Redistributable C++ e Chocolatey```
<br>houve erro, principalmente ao rodar ```npm -v```, apresentou erro que não permitia a execução do script.
<br>----------------------- ```Texto apresentado``` -------------------------------------
<br>npm : o arquivo c:\program files\nodejs\npm.ps1 não pode ser carregado 
<br>porque a execução de scripts foi desabilitada neste sistema.
<br>-------------------------------------------------------------------------------
<br>```Solução:```
<br>Acessei o site:
<br>```https://pt.stackoverflow.com/questions/220078/o-que-significa-o-erro-execu%C3%A7%C3%A3o-de-scripts-foi-desabilitada-neste-sistema```
<br>Rodei o script ```Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser```
<br>Marquei apenas ```"S"```, pois quero apenas para o usuário atual.
<br>Após isto, ao rodar ```npm -v```, me mostrou a versão.

##### Verificar o Python, VS Redistributable C++ e Chocolatey
Comandos realizados no Powershell
<br><br>Para o ```Python``` rode: ```py --version``` ou ```python --version```
<br>
<br>Para o ```Chocolatey``` rode: ```choco -?``` (Exibirá um texto grande e depois a versão)
<br>
<br>Para o ```VS Redistributable C++(GCC/GCC+)``` rode: ```gcc --version``` ou ```g++ --version```(Pode haver erros)
##### Erros C/C++
<br>verfique se o GCC/GCC+ está no PATH
<br>deixe instalado IDE's que usam o GCC/GCC+ como o ```CodeBlocks```
<br>Caso não esteja no PATH, adicione ```MinGW do CodeBlocks```
<br>```C:\Program Files\CodeBlocks\MinGW\bin```
<br>
<br>Para testar rode: ```gcc --version``` e ```g++ --version```
##### Orientações finais
Se não aparecer a versão, instale  VS Redistributable C++ ou quaisquer outro instalador, leia tutoriais adicionais 
<br>acerca do problema encontrado durante o processo.

