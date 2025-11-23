:: 1.9
@echo off

goto :main

::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
::------------------------------------------------------------------------------- DNS IPv4 -------------------------------------------------------------------------------
::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:DNSQUATRO
     
     setlocal enableDelayedExpansion
         
           :: Searching...
         echo Procurando...
         echo.
         echo ====================
             :: Network situation
         echo = Situação da Rede =
         echo ====================
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         for /f "tokens=2,3* delims=:" %%A in ('ipconfig ^| findstr "IPv4"') do set "IPVQUATRO=%%~A"
         ::----------------------------------------------------------------------------------------------------------
         if "!IPVQUATRO!"=="" (
                  :: The network does not support IPv6 or it is disabled.
                echo Rede não possui suporte ao IPv4 ou esta desabilitada.
		        endlocal
		        goto :eof )
         ::----------------------------------------------------------------------------------------------------------
         if exist "%~dp0ipv4.txt" (
             for /f "delims=*" %%A in (%~dp0ipv4.txt) do set "ARQUIVO=%%A"
             set "ARQUIVO=!ARQUIVO:~0,-1!"
         ::----------------------------------------------------------------------------------------------------------
             if "!ARQUIVO!"=="%IPVQUATRO%" (
                  echo IPv4 [Local]: %IPVQUATRO%
                  echo IPv4 [Public]: !ARQUIVO!
                  echo.
                    :: Your DNS does not need to be updated.
                  echo Não é necessário seu DNS ser atualizado. ;^)
                  endlocal
                  goto :eof ) else (
                  if "!ARQUIVO!"=="" (
                       set "ARQUIVO=--"
                       echo %IPVQUATRO% > "%~dp0ipv4.txt" ) ) )
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         set "URLQUATRO=https://api4.ipify.org"
		 for /f "delims=" %%A in ('curl -s -o nul -X GET -LI -w "%%{http_code}" "!URLQUATRO!"') do set "HTTPCODE=%%A"
         echo Status: !HTTPCODE!
         ::----------------------------------------------------------------------------------------------------------
         if "%HTTPCODE%"=="000" (
             echo.
               :: Disconnected Network.
             echo Rede desconectada.
             endlocal
             goto :eof )
         ::----------------------------------------------------------------------------------------------------------
         if "%HTTPCODE%"=="200" (
             for /f "delims=" %%A in ('curl -s -X GET "%URLQUATRO%"') do set "IPVQUATRO=%%A" )
         ::----------------------------------------------------------------------------------------------------------
         if "%HTTPCODE%"=="405" (
             for /f "delims=" %%A in ('curl -s -X GET "%URLQUATRO%"') do set "IPVSQUATRO=%%A" )
         ::----------------------------------------------------------------------------------------------------------
         echo IPv4 [Public]: %IPVQUATRO%
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         echo.
         echo ===================
             :: DNS situation
         echo = Situação do DNS =
         echo ===================
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         if "%ARQUIVO%"=="%IPVQUATRO%" (
               :: Your DNS does not need to be updated.
             echo Não é necessario seu DNS ser atualizado. ;^)
             ) else (
			      echo %IPVQUATRO% > "%~dp0ipv4.txt"
			        :: Updated File
			      echo Arquivo atualizado.
			      echo.
			        :: Starting updates to your DNS.
			      echo Iniciando atualizações em seu DNS...
			      echo.
				  echo.
			      call :NOIPQUATRO
			      echo.
			      call :DYNVQUATRO )
     
     endlocal
     goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------
     
:NOIPQUATRO
     
     :: username:password@dynupdate.no-ip.com/nic/update?hostname=%DNS%&myip=%IPVQUATRO%
     :: dynupdate.no-ip.com/nic/update?hostname=%DNS%&myip=%IPVQUATRO%
	 
     setlocal enableDelayedExpansion
	     
		 set "AGENTE=Pango/2.0 (Windows NT 10.0; Win64; x64) mail@mail.com"
         set "CABECALHO=Authorization: Basic %NOIPTOKEN%"
		 ::-----------------------------------------------------------------------------------------------------------------------------
		 set "URL=https://dynupdate.no-ip.com/nic/update?hostname=%NOIPDNS%&myip=%IPVQUATRO%"
         ::-----------------------------------------------------------------------------------------------------------------------------
         for /f "delims=*" %%A in ('curl -s --user-agent "%AGENTE%" --header "%CABECALHO%" --request GET "%URL%"') do set "RESPOSTA=%%A"
         
		 set "ATUALIZADO=good"
		 set "INALTERADO=nochg"
		 set "AUTENTICACAO=badauth"
		 
		 echo ====================
		 echo =      No-IP       =
		 echo ====================
		 
		 if "%RESPOSTA%"=="911" (
		       :: The server is down, I'll try again later.
		     echo Servidor fora do ar, tentarei mais tarde. :/
			 endlocal
			 goto :eof )
rem      echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		 if "%RESPOSTA%"=="%AUTENTICACAO%" (
		        :: Invalid credentials.
		      echo Credenciais inválidas.
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		        :: No need to update.
			  echo Não foi necessário ser atualizado. ;^)
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		        :: Updated.
		      echo Atualizado. :^) ) || (
			    :: I was unable to update at the moment, I will try again later.
		      echo No momento não foi possível atualizar, tentarei mais tarde. :/ )
     
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
		        :: Invalid token
		      echo Token inválido.
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ZONA%" > nul && (
		        :: The DNS entered is incorrect; correct it or add this hostname to your zone.
		      echo DNS inserido errado, corrija ou acrescente a sua zona esse hostname.
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		        :: No need to update.
		      echo Não foi necessário ser atualizado. ;^) 
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		        :: Updated
		      echo Atualizado. :^) ) || ( 
			    :: I was unable to update at the moment, I will try again later.
		      echo No momento não foi possível atualizar, tentarei mais tarde. :/ )
		 ::----------------------------------------------------------------------------------------------------------
     endlocal
	 goto :eof
::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
::------------------------------------------------------------------------------- DNS IPv4 -------------------------------------------------------------------------------
::------------------------------------------------------------------------------------------------------------------------------------------------------------------------




::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
::------------------------------------------------------------------------------- DNS IPv6 -------------------------------------------------------------------------------
::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:DNSSEIS
     
     setlocal enableDelayedExpansion
         
           :: Searching...
         echo Procurando...
         echo.
         echo ====================
             :: Network situation
         echo = Situação da Rede =
         echo ====================
		 ::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		 ::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          for /f "tokens=1,2* delims=:" %%A in ('ipconfig ^| findstr "IPv6" ^| findstr /n "^" ^| findstr "^2:" ^| more') do for /f "tokens=*" %%D in ("%%~C") do set "IPVSEIS=%%~D"
         ::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         if "!IPVSEIS!"=="" (
                  :: The network does not support IPv6 or it is disabled.
                echo Rede não possui suporte ao IPv6 ou esta desabilitada.
		        endlocal
		        goto :eof )
         ::----------------------------------------------------------------------------------------------------------
         if exist "%~dp0ipv6.txt" (
             for /f "delims=*" %%A in (%~dp0ipv6.txt) do set "ARQUIVO=%%A"
             set "ARQUIVO=!ARQUIVO:~0,-1!"
         ::----------------------------------------------------------------------------------------------------------
             if "!ARQUIVO!"=="%IPVSEIS%" (
                  echo IPv6 [Local]: %IPVSEIS%
                  echo IPv6 [Public]: !ARQUIVO!
                  echo.
                    :: Your DNS does not need to be updated.
                  echo Não é necessário seu DNS ser atualizado. ;^)
                  endlocal
                  goto :eof ) else (
                  if "!ARQUIVO!"=="" (
                       set "ARQUIVO=--"
                       echo %IPVSEIS% > "%~dp0ipv6.txt" ) ) )
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         set "URLSEIS=https://api6.ipify.org"
		 for /f "delims=" %%A in ('curl -s -o nul -X GET -LI -w "%%{http_code}" "!URLSEIS!"') do set "HTTPCODE=%%A"
         echo Status: !HTTPCODE!
         ::----------------------------------------------------------------------------------------------------------
         if "%HTTPCODE%"=="000" (
             echo.
               :: Disconnected Network.
             echo Rede desconectada.
             endlocal
             goto :eof )
         ::----------------------------------------------------------------------------------------------------------
         if "%HTTPCODE%"=="200" (
             for /f "delims=" %%A in ('curl -s -X GET "%URLSEIS%"') do set "IPVSEIS=%%A" )
         ::----------------------------------------------------------------------------------------------------------
         if "%HTTPCODE%"=="405" (
             for /f "delims=" %%A in ('curl -s -X GET "%URLSEIS%"') do set "IPVSEIS=%%A" )
         ::----------------------------------------------------------------------------------------------------------
         echo IPv6 [Public]: %IPVSEIS%
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         echo.
         echo ===================
             :: DNS Situation
         echo = Situação do DNS =
         echo ===================
         ::----------------------------------------------------------------------------------------------------------
         ::----------------------------------------------------------------------------------------------------------
         if "%ARQUIVO%"=="%IPVSEIS%" (
               :: Your DNS does not need to be updated.
             echo Não é necessário seu DNS ser atualizado. ;^)
             ) else (
			      echo %IPVSEIS% > "%~dp0ipv6.txt"
			        :: Updated File
			      echo Arquivo atualizado.
			      echo.
			        :: Starting updates to your DNS.
			      echo Iniciando atualizações em seu DNS...
			      echo.
				  echo.
			      call :NOIPSEIS
			      echo.
			      call :DYNVSEIS )
     
     endlocal
     goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------

:NOIPSEIS
     
     :: username:password@dynupdate.no-ip.com/nic/update?hostname=%DNS%&myipv6=%IPVSEIS%
     :: dynupdate.no-ip.com/nic/update?hostname=%DNS%&myipv6=%IPVSEIS%
	 
     setlocal enableDelayedExpansion
	     
		 set "AGENTE=Pango/2.0 (Windows NT 10.0; Win64; x64) mail@mail.com"
         set "CABECALHO=Authorization: Basic %NOIPTOKEN%"
		 ::-----------------------------------------------------------------------------------------------------------------------------
		 set "URL=https://dynupdate.no-ip.com/nic/update?hostname=%NOIPDNS%&myipv6=%IPVSEIS%"
         ::-----------------------------------------------------------------------------------------------------------------------------
         for /f "delims=*" %%A in ('curl -s --user-agent "%AGENTE%" --header "%CABECALHO%" --request GET "%URL%"') do set "RESPOSTA=%%A"
         
		 set "ATUALIZADO=good"
		 set "INALTERADO=nochg"
		 set "AUTENTICACAO=badauth"
		 
		 echo ====================
		 echo =      No-IP       =
		 echo ====================
		 
		 if "%RESPOSTA%"=="911" (
		       :: The server is down, I'll try again later.
		     echo Servidor fora do ar, tentarei mais tarde. :/
			 endlocal
			 goto :eof )
rem      if "%RESPOSTA%"=="%AUTENTICACAO%" (
		 echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		        :: Invalid credentials.
		      echo Credenciais inválidas.
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		        :: No need to update.
		      echo Não foi necessário ser atualizado. ;^)
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		        :: Updated.
		      echo Atualizado. :^) ) || (
			    :: I was unable to update at the moment, I will try again later.
		      echo No momento não foi possível atualizar, tentarei mais tarde. :/ )
     endlocal
	 goto :eof
	 
::--------------------------------------------------------------------------------------------------------------------
::--------------------------------------------------------------------------------------------------------------------

:DYNVSEIS
     
     :: ipv6.dynv6.com/api/update?hostname=%DNS%&token=%TOKEN%&ipv6=%IPVSEIS%&ipv6prefix=auto
	 :: dynv6.com/api/update?hostname=%DNS%&token=%TOKEN%&ipv6=%IPVSEIS%&ipv6prefix=auto
	 
     setlocal enableDelayedExpansion
		 ::-------------------------------------------------------------------------------------------------------------	 
         set "URL=https://ipv6.dynv6.com/api/update?hostname=%DYNVDNS%&token=%DYNVTOKEN%&ipv6=%IPVSEIS%&ipv6prefix=auto"
		 ::-------------------------------------------------------------------------------------------------------------
         for /f "delims=*" %%A in ('curl -s --request GET "%URL%"') do set "RESPOSTA=%%A"
rem echo RESPOSTA: "%RESPOSTA%"
         
		 set "ATUALIZADO=addresses updated"
		 set "INALTERADO=addresses unchanged"
		 set "AUTENTICACAO=invalid authentication token"
         
		 set "ZONA=zone not found"
		 
		 echo ====================
		 echo =      Dynv6       =
		 echo ====================
		 
		 echo %RESPOSTA% | findstr /r /c:"%AUTENTICACAO%" > nul && (
		        :: Invalid token
		      echo Token inválido.
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%ZONA%" > nul && (
		        :: The DNS entered is incorrect; correct it or add this hostname to your 
		      echo DNS inserido errado, corrija ou acrescente a sua zona esse hostname.
			  endlocal
			  goto :eof )
		 echo %RESPOSTA% | findstr /r /c:"%INALTERADO%" > nul && (
		        :: No need to update.
		      echo Não foi necessário ser atualizado. ;^)
			  endlocal
			  goto :eof )
rem         if "%RESPOSTA%"=="%ATUALIZADO%" (
		 echo %RESPOSTA% | findstr /r /c:"%ATUALIZADO%" > nul && (
		        :: Updated
		      echo Atualizado. :^) ) || (
rem		      echo Atualizado. :^) ) else ( 
			    :: I was unable to update at the moment, I will try again later.
		      echo No momento não foi possível atualizar, tentarei mais tarde. :/ )
		 ::-------------------------------------------------------------------------------------------------------------
     endlocal
	 goto :eof
::------------------------------------------------------------------------------------------------------------------------------------------------------------------------
::------------------------------------------------------------------------------- DNS IPv6 -------------------------------------------------------------------------------
::------------------------------------------------------------------------------------------------------------------------------------------------------------------------





:main

cls

:: UTF-8 Codification for Portuguese-Brazil
chcp 65001
echo.

echo ################################################
echo ##########        Pango DNS             ########
echo ################################################
echo %DATE%             -             %TIME%
echo.
echo.
::----------------------------------------------------------

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

::----------------------------------------------------------

  :: Setting username and password..
echo Definindo usuário e senha...
echo.

::----------------------------------------------------------

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

echo ------------------------------------------------
::----------------------------------------------------------
rem pause
timeout /t 10
rem exit
