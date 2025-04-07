@ECHO OFF

IF NOT EXIST bin\dash.com (
  ECHO "Required binaries are missing, please run setup.bat to acquire them"
  EXIT 1
)

SET GITEXT=.exe
SET PATH=%CD%\bin\;%PATH%
CALL bin\dash.com -c ". ./deploy.sh"
