@ECHO OFF

:: TODO: Support AARCH64?

IF NOT EXIST bin\ (
  MKDIR bin\
)

IF NOT EXIST bin\pandoc.exe (
  CALL curl -L https://github.com/jgm/pandoc/releases/download/3.6.2/pandoc-3.6.2-windows-x86_64.zip -o pandoc.zip
  CALL tar -xf pandoc.zip -C bin\ --strip-components=1 pandoc-3.6.2/pandoc.exe
  DEL pandoc.zip
)

IF NOT EXIST bin\magick.exe (
  CALL curl -L https://imagemagick.org/archive/binaries/ImageMagick-7.1.1-47-portable-Q16-HDRI-x64.zip -o magick.zip
  CALL tar -xf magick.zip -C bin\ --strip-components=1 ImageMagick-7.1.1-47-portable-Q16-HDRI-x64/magick.exe
  CALL tar -xf magick.zip -C bin\ --strip-components=1 ImageMagick-7.1.1-47-portable-Q16-HDRI-x64/colors.xml
  DEL magick.zip
)

IF NOT EXIST bin\sed.exe (
  CALL curl -L https://github.com/mbuilov/sed-windows/releases/download/sed-4.9-x64-fixed/sed-4.9-x64.exe -o bin\sed.exe
)

IF NOT EXIST bin\dash.com (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/dash -o bin\dash.com
)

IF NOT EXIST bin\cp (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/cp.ape -o bin\cp
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

IF NOT EXIST bin\xargs (
  CALL curl -l https://cosmo.zip/pub/cosmos/v/4.0.2/bin/xargs -o bin\xargs
)
