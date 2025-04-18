@ECHO OFF

:: TODO: Support AARCH64?

IF NOT EXIST bin\ (
  MKDIR bin\
)

IF NOT EXIST bin\pandoc (
  CALL curl -L https://github.com/jgm/pandoc/releases/download/3.6.2/pandoc-3.6.2-windows-x86_64.zip -o pandoc.zip
  CALL tar -xf pandoc.zip -C bin\ --strip-components=1 pandoc-3.6.2/pandoc.exe
  MOVE bin\pandoc.exe bin\pandoc >nul
  DEL pandoc.zip
)

IF NOT EXIST bin\magick (
  CALL curl -L https://github.com/ImageMagick/ImageMagick/releases/download/7.1.1-47/ImageMagick.Q16-HDRI.msixbundle -o bin\magick.msixbundle
  CALL tar -xf .\bin\magick.msixbundle -C bin assets.appx main-x64.appx
  CALL tar -xf .\bin\assets.appx -C bin colors.xml
  CALL tar -xf .\bin\main-x64.appx -C bin magick.exe
  MOVE bin\magick.exe bin\magick >nul
  DEL bin\magick.msixbundle bin\*.appx
)

IF NOT EXIST bin\dash.com (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/dash -o bin\dash.com
)

IF NOT EXIST bin\cp (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/cp.ape -o bin\cp
)

IF NOT EXIST bin\date (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/date -o bin\date
)

IF NOT EXIST bin\dirname (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/dirname -o bin\dirname
)

IF NOT EXIST bin\mkdir (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/mkdir.ape -o bin\mkdir
)

IF NOT EXIST bin\rm (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/rm.ape -o bin\rm
)

IF NOT EXIST bin\sed (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/sed -o bin\sed
)

IF NOT EXIST bin\touch (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/touch -o bin\touch
)

IF NOT EXIST bin\xargs (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/xargs -o bin\xargs
)
