#!/usr/bin/env bash

if [ $# -eq 0 ]; then
	printf '%s\n' "ERROR: try 'sh dos2unix.sh --help' for more information"
	exit
fi

while [[ $# -gt 0 ]];
do
  case "$1" in
    --help | -h)
		  printf "When to use ? When you see the message Error: \$\'r\'"
      printf "Usage: sh dos2unix.sh [FILE]...\n"
      echo
      echo "Report any bugs to author by including systematic documentations."
      echo "Make sure that your problem is reproducible."
      exit
			;;
		--input )
		  INPUT=$1
		  OUTPUT=unix_$1
			shift
			;;
		* )
			break
			;;
  esac
done

INPUT="${INPUT:-$1}"
OUTPUT="${OUTPUT:-unix_$1}"

if [ -z ${INPUT} ]; then
	echo "ERROR: No input file detected."
	exit
fi
if [ -z ${OUTPUT} ]; then
	echo "ERROR: No output file detected."
	exit
fi
echo Converting ${INPUT} from DOS to UNIX compatible file
cp ${INPUT} ${INPUT}_backup
tr -d '\015' < "$1" > ${OUTPUT}
cp ${OUTPUT} ${INPUT}
