#!/bin/sh
#
# Convert WineTricks checksums from SHA1 to SHA256 (GNU/Linux coreutils specific).
#
# Copyright (C) 2017-2025
#   - Original author: Austin English
#   - Improvements by: [Your Name/Team]
#
# License: GNU LGPL 2.1 or later
#
# Usage: Run from the project's top-level directory (where README.md resides).
#
# WARNING:
#  - This script is specialized for maintainers on GNU/Linux.
#  - It modifies the winetricks script and attempts to commit changes.
#  - Ensure your Git working tree is clean before running.

set -e  # Exit on any unhandled error
set -u  # Treat unset variables as an error
set -o pipefail  # Propagate errors through pipes

# Uncomment this for debugging:
#set -x

# Directories and files
CACHE_DIR="${HOME}/.cache/winetricks"
SRC_DIR="${PWD}"
WINETRICKS="${SRC_DIR}/src/winetricks"

# Basic sanity checks
if [ ! -f README.md ]; then
    echo "Error: Please run from the repository's top-level directory."
    exit 1
fi

if [ ! -f "${WINETRICKS}" ]; then
    echo "Error: winetricks script not found at '${WINETRICKS}'"
    exit 1
fi

if [ ! -d "${CACHE_DIR}" ]; then
    echo "Error: Winetricks cache directory not found at '${CACHE_DIR}'"
    exit 1
fi

# Check if Git repo is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "Warning: Your Git working tree is not clean. Uncommitted changes might be overwritten."
    echo "Press Ctrl+C now to abort, or wait 5 seconds to continue anyway..."
    sleep 5
fi

# Logging directory
LOGDIR="${SRC_DIR}/sha-convert-logs"
rm -rf "${LOGDIR}"
mkdir -p "${LOGDIR}"

echo "Starting SHA1 -> SHA256 conversion..."
echo "Cache dir: ${CACHE_DIR}"
echo "Working dir: ${SRC_DIR}"

# Process each package directory in the cache
for dir in "${CACHE_DIR}/"*; do

    # Skip non-directories (LATEST, etc.)
    if [ ! -d "${dir}" ]; then
        continue
    fi

    package="$(basename "${dir}")"

    # Some known packages to skip
    case "${package}" in
        win2ksp4|win7sp1|xpsp3|winxpsp3)
            echo "Skipping ${package} (excluded by case statement)."
            continue
            ;;
    esac

    # For each file in this package directory
    changed_any=0
    for file in "${dir}"/*; do
        if [ ! -f "${file}" ]; then
            continue
        fi

        echo "Processing file=${file}, package=${package}"

        # Compute original (SHA1) and new (SHA256) checksums
        sha1_file="$(sha1sum "${file}" | awk '{print $1}')"
        sha256_file="$(sha256sum "${file}" | awk '{print $1}')"

        # If the script doesn't contain the SHA1, skip sed (avoid no-op or partial changes)
        if ! grep -q "${sha1_file}" "${WINETRICKS}"; then
            echo "No match for SHA1 ${sha1_file} in ${WINETRICKS}, skipping..."
            continue
        fi

        # Replace all occurrences of the old SHA1 with the new SHA256
        sed -i "s!${sha1_file}!${sha256_file}!g" "${WINETRICKS}"
        changed_any=1
    done

    # If we didn't change anything for this package, continue
    if [ "${changed_any}" -eq 0 ]; then
        echo "No checksums updated for package: ${package}."
        continue
    fi

    # Check if there is a real diff in Git
    if git diff-index --quiet HEAD --; then
        echo "No net diff detected for package: ${package}."
        continue
    fi

    echo "Diff detected. Testing install of '${package}'..."

    # Attempt to install/test the package with updated checksums
    # Clean environment
    wineserver -k || true
    rm -rf "${HOME}/.wine"

    # Also remove the package from cache to force re-download with updated checksum
    rm -rf "${CACHE_DIR:?}/${package}"

    # Attempt quiet install
    if "${WINETRICKS}" -q -v "${package}"; then
        # On success, commit the changes
        git commit -m "${package}: convert to sha256" "${WINETRICKS}"
        echo "Committed changes for package: ${package}."
    else
        # On failure, revert
        echo "Installation failed for '${package}' with new SHA256. Reverting changes..."
        git checkout -f
        echo "converting ${package} to sha256 failed" >> "${LOGDIR}/conversion.log"
    fi
done

# If there were errors logged, report them
if [ "$(find "${LOGDIR}" -type f | wc -l)" -gt 0 ]; then
    echo "There were errors, check logs in ${LOGDIR}"
    exit 1
else
    rm -rf "${LOGDIR}"
    echo "All conversions completed successfully."
fi

exit 0
