@ECHO OFF

IF NOT EXIST bin\dash.com (
  ECHO "Required binaries are missing, please run setup.bat to acquire them"
  EXIT 1
)

CALL bin\dash.com -c ". ./build-win.sh"
