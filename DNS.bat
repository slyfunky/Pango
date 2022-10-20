@echo off

goto :main

::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------

:DNSQUATRO
     
     setlocal enableDelayedExpansion
     ::--------------------------------------------------------------------------------------------------------------------
     ::--------------------------------------------------------------------------------------------------------------------
         echo Procurando...
	 echo.
	 
         set "URLQUATRO=https://api4.ipify.org"
		 ::----------------------------------------------------------------------------------------------------------
	         for /f "delims=" %%A in ('curl -s -o nul -X GET -LI -w "%%{http_code}" "%URLQUATRO%"') do set "HTTPCODE=%%A"
		 if "%HTTPCODE%"=="000" (
		     set IPVQUATRO=""
		     echo Rede desconectada.
		     endlocal
		     goto :eof )
		 ::----------------------------------------------------------------------------------------------------------
		 ::----------------------------------------------------------------------------------------------------------
		 if "%HTTPCODE%"=="200" (
		     for /f "delims=" %%A in ('curl -s -X GET "%URLQUATRO%"') do set "IPVQUATRO=%%A"
		     
		     for /f "delims=*" %%A in (%~dp0ipv4.txt) do set "ARQUIVO=%%A" )
		 ::----------------------------------------------------------------------------------------------------------
		 if "%HTTPCODE%"=="405" (
		     for /f "delims=" %%A in ('curl -s -X GET "%URLQUATRO%"') do set "IPVQUATRO=%%A"
		     
		     for /f "delims=*" %%A in (%~dp0ipv4.txt) do set "ARQUIVO=%%A" )
		 ::----------------------------------------------------------------------------------------------------------
		 set "ARQUIVO=%ARQUIVO:~0,-1%"
		 ::----------------------------------------------------------------------------------------------------------
		 ::----------------------------------------------------------------------------------------------------------
		 echo ====================
		 echo = Situacao da Rede =
		 echo ====================
		 echo Status: %HTTPCODE%
		 echo IPv4: %IPVQUATRO%
		 ::echo Arquivo: %ARQUIVO%
		 echo.
		 ::----------------------------------------------------------------------------------------------------------
		 echo ===================
		 echo = Situacao do DNS =
		 echo ===================
		 if "%ARQUIVO%"=="%IPVQUATRO%" (
		     echo Nao e necessario seu DNS ser atualizado. ;^) ) else (
		     echo %IPVQUATRO% > "%~dp0ipv4.txt"
		     echo Arquivo atualizado.
		     echo.
		     echo.
		     echo.
		     echo Iniciando atualizacoes em seu DNS...
		     echo.
		     call :NOIPQUATRO
		     echo.
		     call :DYNVQUATRO )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
     goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------
     
:NOIPQUATRO
     
     :: username:password@dynupdate.no-ip.com/nic/update?hostname=%DNS%&myip=%IPVQUATRO%
     :: dynupdate.no-ip.com/nic/update?hostname=%DNS%&myip=%IPVQUATRO%
     
     setlocal enableDelayedExpansion
	     
         set "AGENTE=Pango/1.0 (Windows NT 10.0; Win64; x64) mail@mail.com"
         set "CABECALHO=Authorization: Basic %NOIPTOKEN%"
         ::----------------------------------------------------------------------------------------------------------
         set "URL=https://dynupdate.no-ip.com/nic/update?hostname=%NOIPDNS%&myip=%IPVQUATRO%"
                 ::----------------------------------------------------------------------------------------------------------
	         for /f "delims=*" %%A in ('curl -s --user-agent "%AGENTE%" --header "%CABECALHO%" --request GET "%URL%"') do set "RESPOSTA=%%A"
		 
		 set "ATUALIZADO=good"
		 set "INALTERADO=nochg"
		 set "AUTENTICACAO=badauth"
		 
		 echo ====================
		 echo =      No-IP       =
		 echo ====================
		 
		 if "%RESPOSTA%"=="911" (
		     echo Servidor fora do ar, tentarei mais tarde. :/
		     endlocal
		     goto :eof )
		 ::echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		 if "%RESPOSTA%"=="%AUTENTICACAO%" (
		      echo Credenciais invalidas.
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		      echo Nao foi necessario ser atualizado. ;^)
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		      echo Atualizado. :^) ) || (
		      echo No momento nao foi possivel atualizar, tentarei mais tarde. :/ )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
     goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------
     
:DYNVQUATRO
     
     :: ipv4.dynv6.com/api/update?hostname=%DNS%&token=%TOKEN%&ipv4=%IPVQUATRO%
     :: dynv6.com/api/update?hostname=%DNS%&token=%TOKEN%&ipv4=%IPVQUATRO%
	 
     setlocal enableDelayedExpansion
	 ::----------------------------------------------------------------------------------------------------------
         set "URL=https://ipv4.dynv6.com/api/update?hostname=%DYNVDNS%&token=%DYNVTOKEN%&ipv4=%IPVQUATRO%"
	         ::----------------------------------------------------------------------------------------------------------
		 for /f "delims=*" %%A in ('curl -s --request GET "%URL%"') do set "RESPOSTA=%%A"
		 
		 set "ATUALIZADO=addresses updated"
		 set "INALTERADO=addresses unchanged"
		 set "AUTENTICACAO=invalid authentication token"
		 set "ZONA=zone not found"
		 
		 echo ====================
		 echo =      Dynv6       =
		 echo ====================
		 
		 echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		      echo Token invalido.
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ZONA%" > nul && (
		      echo DNS inserido errado, corrija ou acrescente a sua zona esse hostname.
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		      echo Nao foi necessario ser atualizado. ;^) 
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		      echo Atualizado. :^) ) || ( 
		      echo No momento nao foi possivel atualizar, tentarei mais tarde. :/ )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
     goto :eof
     
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------

:DNSSEIS
     
     setlocal enableDelayedExpansion
     ::--------------------------------------------------------------------------------------------------------------------
     ::--------------------------------------------------------------------------------------------------------------------
         echo Procurando...
		 echo.
		 
         set "URLSEIS=https://api6.ipify.org"
	         ::--------------------------------------------------------------------------------------------------------------------
		 if "%IPVQUATRO%"=="" (
		     for /f "delims=*" %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=2-3 delims=, " %%B in ("%%~A") do set "IPVSEIS=%%~B" ) else (
		 ::----------------------------------------------------------------------------------------------------------
		     for /f "delims=*" %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=3-4 delims=, " %%B in ("%%~A") do set "IPVSEIS=%%~B"
		     if "%IPVSEIS%"=="" (
		         echo Rede nao possui suporte ao IPv6 ou esta desabilitada.
		         endlocal
		         goto :eof ) )
		 ::----------------------------------------------------------------------------------------------------------
		 for /f "delims=" %%A in ('curl -s -o nul -X GET -LI -w "%%{http_code}" "%URLSEIS%"') do set "HTTPCODE=%%A"
		 ::----------------------------------------------------------------------------------------------------------
		 ::----------------------------------------------------------------------------------------------------------
		 if "%HTTPCODE%"=="000" (
		     echo Rede desconectada.
		     endlocal
		     goto :eof )
		 ::----------------------------------------------------------------------------------------------------------
		 if "%HTTPCODE%"=="200" (
		     for /f "delims=" %%A in ('curl -s -X GET "%URLSEIS%"') do set "IPVSEIS=%%A"
			 
		     for /f "delims=*" %%A in (%~dp0ipv6.txt) do set "ARQUIVO=%%A" )
	     ::----------------------------------------------------------------------------------------------------------
		 if "%ARQUIVO%"=="" (
		     set "ARQUIVO=--"
		     echo %IPVSEIS% > "%~dp0ipv6.txt" ) else (
		     set "ARQUIVO=%ARQUIVO:~0,-1%" )
		 ::----------------------------------------------------------------------------------------------------------
		 if "%HTTPCODE%"=="405" (
		     for /f "delims=" %%A in ('curl -s -X GET "%URLSEIS%"') do set "IPVSEIS=%%A"
		     
		     for /f "delims=*" %%A in (%~dp0ipv6.txt) do set "ARQUIVO=%%A" )
		 ::----------------------------------------------------------------------------------------------------------
		 ::----------------------------------------------------------------------------------------------------------
		 echo ====================
		 echo = Situacao da Rede =
		 echo ====================
		 echo Status: %HTTPCODE%
		 echo IPv6: %IPVSEIS%
		 ::echo Arquivo: %ARQUIVO%
		 echo.
		 ::----------------------------------------------------------------------------------------------------------
		 echo ===================
		 echo = Situacao do DNS =
		 echo ===================
		 if "%ARQUIVO%"=="%IPVSEIS%" (
		     echo Nao e necessario seu DNS ser atualizado. ;^) ) else (
		     echo %IPVSEIS% > "%~dp0ipv6.txt"
		     echo Arquivo atualizado.
		     echo.
		     echo.
		     echo.
		     echo Iniciando atualizacoes em seu DNS...
		     echo.
		     call :NOIPSEIS
		     echo.
		     call :DYNVSEIS )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
     goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------

:NOIPSEIS
     
     :: username:password@dynupdate.no-ip.com/nic/update?hostname=%DNS%&myipv6=%IPVSEIS%
     :: dynupdate.no-ip.com/nic/update?hostname=%DNS%&myipv6=%IPVSEIS%
	 
     setlocal enableDelayedExpansion
	     
         set "AGENTE=Pango/1.0 (Windows NT 10.0; Win64; x64) mail@mail.com"
         set "CABECALHO=Authorization: Basic %NOIPTOKEN%"
	 ::----------------------------------------------------------------------------------------------------------
	 set "URL=https://dynupdate.no-ip.com/nic/update?hostname=%NOIPDNS%&myipv6=%IPVSEIS%"
                 ::----------------------------------------------------------------------------------------------------------
		 for /f "delims=*" %%A in ('curl -s --user-agent "%AGENTE%" --header "%CABECALHO%" --request GET "%URL%"') do set "RESPOSTA=%%A"
		 
		 set "ATUALIZADO=good"
		 set "INALTERADO=nochg"
		 set "AUTENTICACAO=badauth"
		 
		 echo ====================
		 echo =      No-IP       =
		 echo ====================
		 
		 if "%RESPOSTA%"=="911" (
		     echo Servidor fora do ar, tentarei mais tarde. :/
		     endlocal
		     goto :eof )
		 ::if "%RESPOSTA%"=="%AUTENTICACAO%" (
		 echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		      echo Credenciais invalidas.
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		      echo Nao foi necessario ser atualizado. ;^)
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		      echo Atualizado. :^) ) || (
		      echo No momento nao foi possivel atualizar, tentarei mais tarde. :/ )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
     goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------

:DYNVSEIS
     
     :: ipv6.dynv6.com/api/update?hostname=%DNS%&token=%TOKEN%&ipv6=%IPVSEIS%&ipv6prefix=auto
     :: dynv6.com/api/update?hostname=%DNS%&token=%TOKEN%&ipv6=%IPVSEIS%&ipv6prefix=auto
	 
     setlocal enableDelayedExpansion
	 ::----------------------------------------------------------------------------------------------------------
         set "URL=https://ipv6.dynv6.com/api/update?hostname=%DYNVDNS%&token=%DYNVTOKEN%&ipv6=%IPVSEIS%&ipv6prefix=auto"
	         ::----------------------------------------------------------------------------------------------------------
		 for /f "delims=*" %%A in ('curl -s --request GET "%URL%"') do set "RESPOSTA=%%A"
		 
		 set "ATUALIZADO=addresses updated"
		 set "INALTERADO=addresses unchanged"
		 set "AUTENTICACAO=invalid authentication token"
		 set "ZONA=zone not found"
		 
		 echo ====================
		 echo =      Dynv6       =
		 echo ====================
		 
		 ::if "%RESPOSTA%"=="%AUTENTICACAO%" (
		 echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		      echo Token invalido.
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ZONA%" > nul && (
		      echo DNS inserido errado, corrija ou acrescente a sua zona esse hostname.
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		      echo Nao foi necessario ser atualizado. ;^)
		      endlocal
		      goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		      echo Atualizado. :^) ) || (
		      echo No momento nao foi possivel atualizar, tentarei mais tarde. :/ )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
     goto :eof
     
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------

:main

cls

echo ################################################
echo ##########        Pango DNS             ########
echo ################################################
echo %DATE%             -             %TIME%
echo.
echo.
::----------------------------------------------------------------------------------------------------------

::  [No-IP]
::   DNS
set "NOIPDNS=yourhost.no-ip.org"
::   Credentials must be encoded to base64 format
set "NOIPTOKEN=ZS1tYWlsOnBhc3N3b3Jk"

::  [Dynv6]
::   DNS
set "DYNVDNS=yourhost.dynv6.net"
::   Token
set "DYNVTOKEN=token"

::----------------------------------------------------------------------------------------------------------

echo Definindo usuario e senha...
echo.

::----------------------------------------------------------------------------------------------------------

echo ------------------------------------------------
echo.
echo                     IPv4
echo.
call :DNSQUATRO
echo.

echo ------------------------------------------------
echo.
echo                     IPv6
echo.
call :DNSSEIS
echo.

::----------------------------------------------------------------------------------------------------------
::pause
timeout /t 10
::exit