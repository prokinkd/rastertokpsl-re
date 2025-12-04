#!/bin/bash

# Exit on any error
set -e

# Configuration
RELEASE_DIR="rastertokpsl-re-release"
ARCHIVE_NAME="rastertokpsl-re.tar.xz"

# List of files and folders to include in the release
# Add or remove items as needed
# Wildcards are supported: *.txt, src/*.py, etc.
FILES_TO_COPY=(
    "bin"
    "cupsfilterproxy.sh"
    "install.sh"
    "kpsl"
    "LICENSE"
    "pdftoraster.sh"
    "rastertokpsl-re.sh"
    "rastertokpsl.sh"
    "rastertokpsl_wrapper"
    "README.md"
    "*.pl"
    "*.ppd"
)

echo "Creating release directory..."
# Remove old release directory if it exists
if [ -d "$RELEASE_DIR" ]; then
    echo "Removing existing release directory..."
    rm -rf "$RELEASE_DIR"
fi

# Create fresh release directory
mkdir -p "$RELEASE_DIR"

echo "Copying files and folders..."
# Enable nullglob so patterns that don't match anything expand to nothing
shopt -s nullglob

# Copy each item to the release directory
for pattern in "${FILES_TO_COPY[@]}"; do
    # Expand the pattern (this allows wildcards to work)
    matched=false
    for item in $pattern; do
        if [ -e "$item" ]; then
            echo "  - Copying $item"
            cp -r "$item" "$RELEASE_DIR/"
            matched=true
        fi
    done
    
    # Warn if pattern didn't match anything
    if [ "$matched" = false ]; then
        echo "  - Warning: No files matched pattern '$pattern', skipping..."
    fi
done

# Disable nullglob
shopt -u nullglob

echo "Creating tar.xz archive..."
# Create the archive
tar -cJf "$ARCHIVE_NAME" "$RELEASE_DIR"

echo "Done! Archive created: $ARCHIVE_NAME"
echo "Release directory size: $(du -sh "$RELEASE_DIR" | cut -f1)"
echo "Archive size: $(du -sh "$ARCHIVE_NAME" | cut -f1)"

# Optional: Remove the release directory after archiving
# Uncomment the following line if you want to clean up
# rm -rf "$RELEASE_DIR"
