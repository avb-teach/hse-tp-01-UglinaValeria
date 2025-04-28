#!/bin/bash

chmod +x collect_files.sh

set -e

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 INPUT_DIR OUTPUT_DIR [--max_depth N]"
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
  FIND_CMD=(find "$INPUT_DIR" -mindepth 1 -maxdepth "$MAX_DEPTH" -type f)
else
  FIND_CMD=(find "$INPUT_DIR" -type f)
fi

"${FIND_CMD[@]}" | while IFS= read -r file_path; do
  base_name="$(basename "$file_path")"
  name="${base_name%.*}"
  extension="${base_name##*.}"

 
  if [[ "$name" == "$base_name" ]]; then
    extension=""
  else
    extension=".$extension"
  fi

  dest_file="$OUTPUT_DIR/$base_name"
  counter=1

 
  while [[ -e "$dest_file" ]]; do
    dest_file="$OUTPUT_DIR/${name}${counter}${extension}"
    ((counter++))
  done

 
  cp "$file_path" "$dest_file"
done

exit 0
