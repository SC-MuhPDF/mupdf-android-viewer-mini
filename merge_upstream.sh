#!/usr/bin/bash

set -e

tag="$1"
if [ -z "$tag" ]; then
    echo "Usage: $0 <tag>"
    exit 1
fi

mydir="$(dirname "$(realpath "$0")")"

# mupdf-android-viewer-mini
cd "$mydir"
# mupdf-android-fitz
pushd jni
# mupdf
pushd libmupdf

# libmupdf "mupdf"
git fetch upstream # git://git.ghostscript.com/mupdf-android-fitz.git
git checkout "$tag"
git branch -D master
git checkout -b master
sed -i 's|url = ../|url = http://git.ghostscript.com/|g' .gitmodules
git add .gitmodules
git commit -m "Track upstream dependencies"
popd

# jni "mupdf-android-fitz"
git fetch upstream # git://git.ghostscript.com/mupdf-android-fitz.git
git merge "$tag" || read -p "Enter when conflicts resolved and committed. Maybe git submodule update --recursive helps too. This step is still very WIP."
# TODO...
popd

# mupdf-android-viewer-mini
git fetch upstream
git merge "$tag" || read -p "Enter when conflicts are resolved and committed"
# TODO...
