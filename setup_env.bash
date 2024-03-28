#!/bin/bash

HELP_MESSAGE="Usage: ./build.sh [-r, --rebuild]
Build the '${IMAGE_NAME}' image.
Options:
  -r, --rebuild            Remove the previous venv completely before rebuilding
  -h, --help               Show this help message."

# Parse input flags
rebuild=false
while [ "$#" -gt 0 ]; do
  case "$1" in
  -r | --rebuild)
    rebuild=true
    shift 1
    ;;
  -h | --help)
    echo "${HELP_MESSAGE}"
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
  esac
done



# Check if we need to (re)install freqtrade
if [ "$rebuild" = true ] || [ ! -d freqtrade/.venv ]  ; then
    echo "Installing freqtrade..."
    rm -rf freqtrade
    rm -rf .env
    git clone https://github.com/freqtrade/freqtrade.git 
    cd freqtrade
    git checkout stable
    ./setup.sh -i
    cd ..
    echo "Done"
fi

echo "Activating venv..."
source freqtrade/.venv/bin/activate        # Activate venv
echo "Done"

echo "Installing python libraries"
pip install --upgrade pip            # We need the latest version to have editable mode with a .toml
pip install -r  requierments.txt      # Install package requirements
python -m build                   # Build package
python -m pip install -e .        # Install package. -e for editable, developer mode.