#!/bin/bash
chmod +x collect_files.sh
set -e

if [[ "$#" -lt 2 ]]; then
  echo "Usage: $0 /path/to/input_dir /path/to/output_dir [--max_depth N]"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"
MAX_DEPTH=""

shift 2

if [[ "$1" == "--max_depth" && -n "$2" ]]; then
  MAX_DEPTH="$2"
fi

if [[ ! -d "$INPUT_DIR" ]]; then
  echo "Error: Input directory '$INPUT_DIR' does not exist."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

if [[ -n "$MAX_DEPTH" ]]; then
  find "$INPUT_DIR" -mindepth 1 -maxdepth "$MAX_DEPTH" -type f
else
  find "$INPUT_DIR" -type f
fi | while read -r filepath; do
  filename=$(basename "$filepath")
  name="${filename%.*}"
  ext="${filename##*.}"

 
  if [[ "$name" == "$filename" ]]; then
    ext=""
  else
    ext=".$ext"
  fi

  newname="$filename"
  counter=1

 
  while [[ -e "$OUTPUT_DIR/$newname" ]]; do
    newname="${name}${counter}${ext}"
    ((counter++))
  done

  cp "$filepath" "$OUTPUT_DIR/$newname"
done
