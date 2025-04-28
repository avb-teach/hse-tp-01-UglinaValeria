#!/bin/bash
chmod +x dcollect_files.sh
set -e

INPUT_DIR="$1"
OUTPUT_DIR="$2"
MAX_DEPTH=""

shift 2

if [[ "$1" == "--max_depth" && -n "$2" ]]; then
  MAX_DEPTH="$2"
fi


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
