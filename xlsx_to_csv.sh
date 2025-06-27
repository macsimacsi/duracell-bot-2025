#!/bin/bash

# Script to convert all XLSX files in db/seeds/codes/ to CSV using LibreOffice

# Check if LibreOffice is installed
if ! command -v libreoffice &> /dev/null ; then
    echo "LibreOffice is not installed. Please install it to proceed."
    echo "On Debian/Ubuntu: sudo apt-get install libreoffice"
    echo "On Fedora: sudo dnf install libreoffice"
    echo "On macOS: brew install --cask libreoffice"
    exit 1
fi

# Directory to search for XLSX files
SOURCE_DIR="db/seeds/codes"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Directory $SOURCE_DIR does not exist. Please create it or adjust the path."
    exit 1
fi

# Find all XLSX files and convert them
echo "Searching for XLSX files in $SOURCE_DIR..."
find "$SOURCE_DIR" -type f -name "*.xlsx" | while read -r xlsx_file; do
    # Generate the output CSV filename by replacing .xlsx with .csv
    csv_file="${xlsx_file%.xlsx}.csv"
    
    echo "Converting: $xlsx_file -> $csv_file"
    
    # Use LibreOffice in headless mode to convert XLSX to CSV
    libreoffice --headless --convert-to csv --outdir "$(dirname "$csv_file")" "$xlsx_file" > /dev/null 2>&1
    
    # Check if conversion was successful
    if [ $? -eq 0 ] && [ -f "$csv_file" ]; then
        echo "Successfully converted: $xlsx_file"
    else
        echo "Error converting: $xlsx_file"
    fi
done

echo "Conversion process completed!"
