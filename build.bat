@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: TODO: Get timestamp for commit time working, is it even possible on Windows with provided tools?
:: TODO: Fix image paths to match build.sh

SET "FILEMISSING="
IF NOT EXIST bin\pandoc.exe SET "FILEMISSING=1"
IF NOT EXIST bin\magick.exe SET "FILEMISSING=1"
IF NOT EXIST bin\sed.exe SET "FILEMISSING=1"
IF DEFINED FILEMISSING (
  ECHO "Required binaries are missing, please run setup.bat to acquire them"
  EXIT 1
)

SET "PAGES=index projects events about websiteabout"

:: From https://superuser.com/a/1541378
(SET LF=^
%=EMPTY=%
)

FOR /F %%F IN ('bin\pandoc.exe -v ^| bin\sed.exe -n "s/^pandoc.exe //p"') DO SET "PANDOC_VERSION=%%F"
FOR /F %%F IN ('bin\magick.exe --version ^| bin\sed.exe -n "s/^Version: ImageMagick \([[:digit:]]\{1,\}\.[[:digit:]]\{1,\}\.[[:digit:]]\{1,\}-[[:digit:]]\{1,\}\).*/\1/p"') DO SET "MAGICK_VERSION=%%F"

:: Based on https://stackoverflow.com/a/203116 and https://stackoverflow.com/a/43146279
FOR /f "tokens=2-4 delims=/ " %%A IN ("%DATE%") DO (SET "BUILD_TIME=%%C-%%B-%%AT")
FOR /f "tokens=1-3 delims=/:." %%A IN ("%TIME%") DO (SET "BUILD_TIME=%BUILD_TIME%%%A:%%B:%%C")
FOR /F "tokens=3" %%F IN ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v ActiveTimeBias') DO SET /A "SBIAS=%%F"
IF "%SBIAS:~0,1%"=="-" (SET "SIGN=+" & SET "UBIAS=%SBIAS:~1%") ELSE SET "SIGN=-" & SET "UBIAS=%SBIAS%"
SET /A "DEC=100*%UBIAS%/60"
SET /A "HOURS=%DEC%/100"
IF "%DEC%"=="0" SET "MINS=00" & SET "SIGN=+"
IF "%DEC:~1%"=="00" (SET "MINS=00") ELSE IF "%DEC:~2%"=="00" SET "MINS=00" && SET "HOURS=%DEC:~0,2%"
IF "%DEC:~1%"=="50" (SET "MINS=30") ELSE IF "%DEC:~2%"=="50" SET "MINS=30" && SET "HOURS=%DEC:~0,2%"
IF "%DEC:~1%"=="75" (SET "MINS=45") ELSE IF "%DEC:~2%"=="75" SET "MINS=45" && SET "HOURS=%DEC:~0,2%"
IF %HOURS% LSS 10 SET "HOURS=0%HOURS%"
SET "BUILD_TIME=%BUILD_TIME%%SIGN%%HOURS%:%MINS%"

FOR /F %%F IN ('git show -s --format^=%%H') DO SET "BUILD_COMMIT=%%F"
FOR /F "tokens=*" %%F IN ('git show -s --format^=%%an') DO SET "BUILD_COMMIT_AUTHORS=%%F"
FOR /F "tokens=*" %%F IN ('git show -s --format^=%%ae') DO SET "BUILD_COMMIT_AUTHORS=%BUILD_COMMIT_AUTHORS% (%%F)"
FOR /F "tokens=*" %%F IN ('git show -s --format^=%%cn') DO SET "BUILD_COMMIT_COMMITTER=%%F"
FOR /F "tokens=*" %%F IN ('git show -s --format^=%%ce') DO SET "BUILD_COMMIT_COMMITTER=%BUILD_COMMIT_COMMITTER% (%%F)"
FOR /F %%F IN ('git rev-parse --abbrev-ref HEAD') DO SET "BUILD_COMMIT_BRANCH=%%F"

IF NOT "%BUILD_COMMIT_AUTHORS%" == "%BUILD_COMMIT_COMMITTER%" (
  SET "BUILD_COMMIT_AUTHORS=%BUILD_COMMIT_AUTHORS%, %BUILD_COMMIT_COMMITTER%"
)

IF NOT EXIST output\assets\ MKDIR output\assets\

(FOR %%o IN (%PAGES%) DO (
  IF NOT EXIST pages\%%o.md (
    ECHO Page %%o is missing, skipping
  ) ELSE (
    SET "navbar=\!LF!"
    (FOR %%n IN (%PAGES%) DO (
      IF EXIST pages\%%n.md (
        SET "ignore="
        SET "name="
        FOR /F "tokens=*" %%F IN ('bin\sed.exe -n "s/^no-nav-entry: //p" pages/"%%n".md') DO SET "ignore=%%F"
        IF NOT DEFINED ignore (
          FOR /F "tokens=*" %%F IN ('bin\sed.exe -n "s/^pagetitle: //p" pages/%%n.md') DO SET "name=%%F"
          IF NOT DEFINED name FOR /F "tokens=*" %%F IN ('bin\sed.exe -n "s/^title: //p" pages/%%n.md') DO SET "name=%%F"
          IF NOT DEFINED name (
            ECHO Skipping %%n due to missing yaml title
          ) ELSE (
            SET navbar=!navbar!                ^<li class=^"nav-item mb-2 px-2^"^>\!LF!
            SET navbar=!navbar!                  ^<a class=^"nav-link pt-1^"
            IF "%%o" == "%%n" (
              SET navbar=!navbar! aria-current=^"page^" href=^"#
            ) ELSE (
              SET navbar=!navbar! href=^"%%n.html
            )
            SET navbar=!navbar!^"^>!name!^</a^>\!LF!
            SET navbar=!navbar!                ^</li^>\!LF!
          )
        )
      )
    ))
    SET navbar=!navbar!              

    bin\pandoc.exe templates\setup.yaml -s --template templates\template.html -f markdown-implicit_figures^
                   --wrap=preserve -B templates\header.html -A templates\footer.html "pages\%%o.md"^
                   -o "output\%%o.html"
    :: TODO: Figure out how to make sed.exe accept input directly
    ECHO s$%%NAVBAR_ITEMS%%$!navbar!$> sed.txt
    bin\sed.exe -i.tmp -f sed.txt -e 's# />#>#' -e "s/%%PANDOC_VERSION%%/%PANDOC_VERSION%/"^
                       -e "s/%%MAGICK_VERSION%%/%MAGICK_VERSION%/" -e "s/%%BUILD_TIME%%/%BUILD_TIME%/"^
                       -e "s/%%BUILD_COMMIT%%/%BUILD_COMMIT%/" -e "s/%%BUILD_COMMIT_AUTHOR%%/%BUILD_COMMIT_AUTHORS%/"^
                       -e "s/%%BUILD_COMMIT_BRANCH%%/%BUILD_COMMIT_BRANCH%/"^
                       -e 's#^<h\([123456]\)\(.*\)id="\([^"]*\)"\(.*\)</h\1>#<h\1\2id="\3"><span\4</span><a class="ms-2" href="\#\3"><svg class="heading-anchor-icon"><title>Link icon</title></svg></a></h\1>#'^
                       "output\%%o.html"
    del sed.txt
    del "output\%%o.html.tmp"
  )
))

COPY assets\script.js output\assets\script.js
COPY assets\style.css output\assets\style.css
COPY assets\"Programming Club Constitution.pdf" output\assets\"Programming Club Constitution.pdf"

IF NOT EXIST output\assets\favicon.ico bin\magick.exe assets\logo.webp -strip -background none -resize 48x48 -density 48x48 output\assets\favicon.ico
IF NOT EXIST output\assets\icon.avif   bin\magick.exe assets\logo.webp -strip -background none -compress lossless -resize 250x253 -density 250x253 output\assets\icon.avif
IF NOT EXIST output\assets\icon.png    bin\magick.exe assets\logo.webp -strip -background none -compress lossless -resize 250x253 -density 250x253 output\assets\icon.png
IF NOT EXIST output\assets\icon.webp   bin\magick.exe assets\logo.webp -strip -background none -compress lossless -resize 250x253 -density 250x253 output\assets\icon.webp

FOR /R %%F IN ("assets\Committee*.jpg") DO (
  IF NOT EXIST "output\assets\%%~nF.avif" bin\magick.exe "%%F" -strip -background none -resize 250x250 -density 250x250 "output\assets\%%~nF.avif"
  IF NOT EXIST "output\assets\%%~nF.jpg"  bin\magick.exe "%%F" -strip -background none -resize 250x250 -density 250x250 "output\assets\%%~nF.jpg"
  IF NOT EXIST "output\assets\%%~nF.webp" bin\magick.exe "%%F" -strip -background none -resize 250x250 -density 250x250 "output\assets\%%~nF.webp"
)

FOR /R %%F IN ("assets\discord-*.png") DO (
  IF NOT EXIST "output\assets\%%~nF.avif" bin\magick.exe "%%F" -strip -background none -compress lossless "output\assets\%%~nF.avif"
  IF NOT EXIST "output\assets\%%~nF.png"  bin\magick.exe "%%F" -strip -background none -compress lossless "output\assets\%%~nF.png"
  IF NOT EXIST "output\assets\%%~nF.webp" bin\magick.exe "%%F" -strip -background none -compress lossless "output\assets\%%~nF.webp"
)

IF NOT EXIST output/assets/minecraft-1.avif bin\magick.exe assets\minecraft-1.png -strip -background none -resize 1024x576 -density 1024x576 output\assets\minecraft-1.avif
IF NOT EXIST output/assets/minecraft-1.png  bin\magick.exe assets\minecraft-1.png -strip -background none -resize 1024x576 -density 1024x576 output\assets\minecraft-1.png
IF NOT EXIST output/assets/minecraft-1.webp bin\magick.exe assets\minecraft-1.png -strip -background none -resize 1024x576 -density 1024x576 output\assets\minecraft-1.webp
IF NOT EXIST output/assets/minecraft-2.avif bin\magick.exe assets\minecraft-2.png -strip -background none -resize 1024x576 -density 1024x576 output\assets\minecraft-2.avif
IF NOT EXIST output/assets/minecraft-2.png  bin\magick.exe assets\minecraft-2.png -strip -background none -resize 1024x576 -density 1024x576 output\assets\minecraft-2.png
IF NOT EXIST output/assets/minecraft-2.webp bin\magick.exe assets\minecraft-2.png -strip -background none -resize 1024x576 -density 1024x576 output\assets\minecraft-2.webp
IF NOT EXIST output/assets/minecraft-3.avif bin\magick.exe assets\minecraft-3.png -strip -background none -resize  521x576 -density  521x576 output\assets\minecraft-3.avif
IF NOT EXIST output/assets/minecraft-3.png  bin\magick.exe assets\minecraft-3.png -strip -background none -resize  521x576 -density  521x576 output\assets\minecraft-3.png
IF NOT EXIST output/assets/minecraft-3.webp bin\magick.exe assets\minecraft-3.png -strip -background none -resize  521x576 -density  521x576 output\assets\minecraft-3.webp
IF NOT EXIST output/assets/minecraft-4.avif bin\magick.exe assets\minecraft-4.png -strip -background none -resize 1024x576 -density 1024x405 output\assets\minecraft-4.avif
IF NOT EXIST output/assets/minecraft-4.png  bin\magick.exe assets\minecraft-4.png -strip -background none -resize 1024x576 -density 1024x405 output\assets\minecraft-4.png
IF NOT EXIST output/assets/minecraft-4.webp bin\magick.exe assets\minecraft-4.png -strip -background none -resize 1024x576 -density 1024x405 output\assets\minecraft-4.webp
