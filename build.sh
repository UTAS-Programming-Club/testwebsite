#!/bin/sh

# TODO: Try to remove any html tags from markdown code
# TODO: Add heading self anchors

# Currently setup.sh only fetches pandoc and magick, should it download cosmo execs like on windows if somehow missing?
if [ ! -f bin/pandoc ] || [ ! -f bin/magick ] || ! command -v cp           >/dev/null || ! command -v date  >/dev/null\
  || ! command -v dirname >/dev/null          || ! command -v git"$GITEXT" >/dev/null || ! command -v mkdir >/dev/null\
  || ! command -v rm      >/dev/null          || ! command -v sed          >/dev/null || ! command -v xargs >/dev/null ; then
  if [ "$OS" = Windows_NT ]; then
    SETUPEXT=.bat
  else
    SETUPEXT=.sh
  fi
  printf "Required binaries are missing, please run setup%s to acquire them\n" $SETUPEXT
  exit 1
fi

PAGES="index projects events about websiteabout"

PANDOC_VERSION=$(bin/pandoc -v | sed -n 's/^pandoc //p' | sed "s/$(printf '\r')//")
MAGICK_VERSION=$(bin/magick --version | sed -n 's/^Version: ImageMagick \([[:digit:]]\{1,\}\.[[:digit:]]\{1,\}\.[[:digit:]]\{1,\}-[[:digit:]]\{1,\}\).*/\1/p')

BUILD_TIME=$(date "+%Y-%m-%dT%T")$(. ./gettimezone.sh)
BUILD_COMMIT=$(git"$GITEXT" show -s --format=%H)
BUILD_COMMIT_AUTHORS=$(git"$GITEXT" show -s --format=%an)" "\($(git"$GITEXT" show -s --format=%ae)\)
BUILD_COMMIT_COMMITTER=$(git"$GITEXT" show -s --format=%cn)" "\($(git"$GITEXT" show -s --format=%ce)\)
BUILD_COMMIT_TIME=$(git"$GITEXT" show -s --format=%cI)
#TODO: Make a link if the branch has a remote
#TODO: Report if any local changes have occurred since last commit
BUILD_COMMIT_BRANCH=$(git"$GITEXT" rev-parse --abbrev-ref HEAD)

if [ "$BUILD_COMMIT_AUTHORS" != "$BUILD_COMMIT_COMMITTER" ]; then
  BUILD_COMMIT_AUTHORS="$BUILD_COMMIT_AUTHORS, $BUILD_COMMIT_COMMITTER"
fi

mkdir -p output/assets/2021-2022 output/assets/2022-2023

for output_page in $PAGES; do
  if [ ! -f pages/"$output_page".md ]; then
    printf "Page %s is missing, skipping\n" "$output_page"
    continue
  fi

  navbar="\n"
  for navbar_page in $PAGES; do
    if [ ! -f pages/"$navbar_page".md ]; then
      continue
    fi

    ignore=$(sed -n 's/^no-nav-entry: //p' pages/"$navbar_page".md)
    if [ "$ignore" = True ]; then
      continue
    fi

    name=$(sed -n 's/^pagetitle: //p' pages/"$navbar_page".md)
    if [ -z "$name" ]; then
      name=$(sed -n 's/^title: //p' pages/"$navbar_page".md)
    fi
    if [ -z "$name" ]; then
      printf "Skipping %s due to missing yaml title\n" "$navbar_page"
      continue
    fi

    navbar="$navbar                <li class=\"nav-item mb-2 px-2\">\n"
    navbar="$navbar                  <a class=\"nav-link pt-1\""
    if [ "$output_page" = "$navbar_page" ]; then
      navbar="$navbar aria-current=\"page\" href=\"#"
    else
      navbar="$navbar href=\"$navbar_page.html"
    fi
    navbar="$navbar\">$name</a>\n"
    navbar="$navbar                </li>\n"
  done
  navbar="$navbar              "

  printf "Processing %s\n" "pages/$output_page.md"
  bin/pandoc templates/setup.yaml --eol=lf -s --template templates/template.html\
             -f markdown-implicit_figures --wrap=preserve -B templates/header.html\
             -A templates/footer.html "pages/$output_page.md" -o "output/$output_page.html"
  sed -i.tmp -e "s\`%NAVBAR_ITEMS%\`$navbar\`" -e 's# />#>#' -e "s/%PANDOC_VERSION%/$PANDOC_VERSION/"\
             -e "s/%MAGICK_VERSION%/$MAGICK_VERSION/" -e "s/%BUILD_TIME%/$BUILD_TIME/"\
             -e "s/%BUILD_COMMIT%/$BUILD_COMMIT/g" -e "s/%BUILD_COMMIT_AUTHOR%/$BUILD_COMMIT_AUTHORS/"\
             -e "s/%BUILD_COMMIT_TIME%/$BUILD_COMMIT_TIME/" -e "s/%BUILD_COMMIT_BRANCH%/$BUILD_COMMIT_BRANCH/g"\
             -e 's#^<h\([123456]\)\(.*\)id="\([^"]*\)"\(.*\)</h\1>#<h\1\2id="\3"><span\4</span><a class="ms-2" href="\#\3"><svg class="heading-anchor-icon"><title>Link icon</title></svg></a></h\1>#'\
             "output/$output_page.html"
  rm "output/$output_page.html.tmp"
done

cp assets/script.js output/assets/script.js
cp assets/style.css output/assets/style.css
cp assets/"Programming Club Constitution.pdf" output/assets/"Programming Club Constitution.pdf"

# From https://stackoverflow.com/a/63869938
# Replaces ${1%.*} which somehow causes a seg fault with cosmo dash when assigned to a var
# i.e. echo "${1%.*}" is fine but FILE="${1%.*}" gives SIGSEGV
remove_file_ext() {
  printf "%s" "$1" | sed -re 's/(^.*[^/])\.[^./]*$/\1/'
}

process_image() {
  FILE=$(remove_file_ext "$1")
  dirname "output/$image" | xargs mkdir -p

  if [ -f "output/$FILE.avif" ] && [ -f "output/$FILE.png" ] && [ -f "output/$FILE.webp" ]; then
    printf "Skipping %s\n" "$1"
  else
    printf "Processing %s\n" "$1"
  fi

  # shellcheck disable=SC2086
  [ -f "output/$FILE.avif" ] || bin/magick "$1" -strip -background none $2 "output/$FILE.avif" &
  # shellcheck disable=SC2086
  [ -f "output/$FILE.png" ]  || bin/magick "$1" -strip -background none $2 "output/$FILE.png" &
  # shellcheck disable=SC2086
  [ -f "output/$FILE.webp" ] || bin/magick "$1" -strip -background none $2 "output/$FILE.webp"
  wait
}

[ -f output/assets/favicon.ico ] || bin/magick assets/logo.webp -strip -background none -resize 48x48 -density 48x48 output/assets/favicon.ico
process_image assets/logo.webp "-compress lossless -resize 250x250 -density 250x250"

for image in assets/2023-2024/committee-*.jpg assets/2024-2025/committee-*.*; do
  process_image "$image" "-compress lossless"
done

for image in assets/2023-2024/discord-*.png assets/2024-2025/discord-*.png; do
  process_image "$image" "-compress lossless"
done

process_image assets/2023-2024/minecraft-1.png       "-resize 1024x576 -density 1024x576"
process_image assets/2023-2024/minecraft-2.png       "-resize 1024x576 -density 1024x576"
process_image assets/2023-2024/minecraft-3.png       "-resize  521x576 -density  521x576"
process_image assets/2024-2025/minecraft-highway.png "-resize 1024x576 -density 1024x576"

process_image assets/2021-2022/first_meetup.jpg     "-resize  960x502 -density  960x502"
process_image assets/2022-2023/holiday-meetup-1.jpg "-resize  720x540 -density  720x540"
process_image assets/2022-2023/meetup-2.jpg         "-resize  921x691 -density  921x691"
process_image assets/2023-2024/meetup.jpg           "-resize 1008x567 -density 1008x567"

process_image assets/2023-2024/tasjam-1.jpg "-resize 806x604 -density 806x604"
process_image assets/2023-2024/tasjam-2.jpg "-resize 806x604 -density 806x604"

process_image assets/2022-2023/industry-night-1.jpg "-resize 1008x496 -density 1008x496"
process_image assets/2022-2023/industry-night-2.jpg "-resize 1008x496 -density 1008x496"
process_image assets/2022-2023/industry-night-4.jpg "-resize 1008x496 -density 1008x496"

process_image assets/2022-2023/c\&s-1-cropped.jpg "-resize  985x625 -density  985x625"
process_image assets/2022-2023/open-day.jpg       "-resize 1080x608 -density 1080x608"
process_image assets/2023-2024/mini-c\&s.jpg      "-resize  806x604 -density  806x604"
process_image assets/2024-2025/c\&s.png           "-resize  560x560 -density  560x560"
