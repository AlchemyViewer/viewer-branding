#!/usr/bin/env bash

cd "$(dirname "$0")"

# turn on verbose debugging output for logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x
# make errors fatal
set -e
# bleat on references to undefined shell variables
set -u

PKG_SOURCE_DIR="assets"
PKG_VERSION="1.0.0"

top="$(pwd)"
stage="$top"/stage
stage_pkg="$stage/branding"

# load autobuild provided shell functions and variables
case "$AUTOBUILD_PLATFORM" in
    windows*)
        autobuild="$(cygpath -u "$AUTOBUILD")"
    ;;
    *)
        autobuild="$AUTOBUILD"
    ;;
esac
source_environment_tempfile="$stage/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

echo "${PKG_VERSION}" > "${stage}/VERSION.txt"

# Create the staging license folder
mkdir -p "$stage/LICENSES"

#Create the staging debug and release folders
mkdir -p "$stage_pkg"

pushd "$PKG_SOURCE_DIR"
    cp -a assets/* "$stage_pkg"

    # Copy License
    echo "Copyright (c) 2023 Alchemy Development Group. All Rights Reserved." >> "$stage/LICENSES/branding.txt"
popd
