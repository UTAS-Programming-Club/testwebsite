#!/bin/sh

# Currently setup.sh only fetches pandoc and magick, should it download cosmo execs like on windows if somehow missing?
if ! command -v git"$GITEXT" >/dev/null || ! command -v touch >/dev/null ; then
  if [ "$OS" = Windows_NT ]; then
    printf "Required binaries are missing, please run setup.bat to acquire them\n"
  fi
  exit 1
fi

if [ -f output/.git ]; then
  git"$GITEXT" worktree remove output/ || exit
elif [ -d output/ ]; then
  printf "Error: Output already exists and is not a git worktree"
  exit 1
fi

git"$GITEXT" worktree add -fq output/ pages
git"$GITEXT" -C output/ rm -rq .

touch output/.nojekyll
. ./build.sh
git"$GITEXT" -C output/ add .

if ! git"$GITEXT" -C output/ diff --staged --quiet; then
  git"$GITEXT" -C output/ commit
  git"$GITEXT" -C output/ push
fi
