#!/usr/bin/env bash


################
# CHECK PREREQ #
################

if ! [[ -f "getInfo.sh" ]]; then
  echo "ERROR: getInfo.sh does not exist."
	exit
fi

if [ $# -eq 0 ]; then
		printf '%s\n' "ERROR: try 'sh iterate.sh --help' for more information" | fold -s
		exit
fi

while [ ! $# -eq 0 ]
do
  case "$1" in
    --help | -h)
      printf "Usage: sh iterate.sh [OPTION]...\n"
      printf "\t --debug\n"
			printf "\t\t\t Running in debug mode\n"
      printf "\t -i, --input\n"
      printf "\t\t\t Use custom name for list\n"
      printf "\t --html\n"
      printf "\t\t\t Use a list of html\n"
      printf "\t --win-input\n"
      printf "\t\t\t Use a windows-style line endings list\n"
      echo

      echo "Report any bugs to author by including systematic documentations."
      echo "Make sure that your problem is reproducible."
      echo
      printf '%s\n' "WARNING: USER AT YOUR OWN RISK. THE AUTHOR IS NOT RESPONSIBLE FOR ANY DAMAGES." | fold -s
      echo
      printf '%s\n' "NO WARRANTIES: TO THE EXTENT PERMITTED BY APPLICABLE LAW, NOT ANY PERSON, EITHER EXPRESSLY OR IMPLICITLY, WARRANTS ANY ASPECT OF THIS SOFTWARE OR PROGRAM, INCLUDING ANY OUTPUT OR RESULTS OF THIS SOFTWARE OR PROGRAM. UNLESS AGREED TO IN WRITING. THIS SOFTWARE AND PROGRAM IS BEING PROVIDED \"AS IS\", WITHOUT ANY WARRANTY OF ANY TYPE OR NATURE, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, AND ANY WARRANTY THAT THIS SOFTWARE OR PROGRAM IS FREE FROM DEFECTS." | fold -s
      exit
      ;;
    --debug )
      DEBUG=true
      ;;
    --input | -i)
      INPUT_LIST=`echo $2 | awk '{$1=$1};1'`
			;;
    --html )
      IS_HTML=true
      ;;
    --win-input )
      WIN_TO_UNIX=true
      ;;
  esac
  shift
done

# DEFAULT VALUES
IS_HTML="${IS_HTML:-false}"
INPUT_LIST="${INPUT_LIST:-list.txt}"
DEBUG="${DEBUG:-false}"
WIN_TO_UNIX="${WIN_TO_UNIX:-false}"


###############
# MAIN SCRIPT #
###############
if [ ${WIN_TO_UNIX} = 'true' ]; then
  mv ${INPUT_LIST} windows_input.txt
  perl -pe '$_=~s#\r\n#\n#' < windows_input.txt > ${INPUT_LIST}
  rm windows_input.txt
fi

i=1
while read CURRENT_ITEM; do
    if [ -z ${CURRENT_ITEM} ]
    then
      continue
    fi
		OUTPUT_FILE="business_info_"${i}".txt"
		if [ ${IS_HTML} = 'true' ]; then
			# USE HTML
      echo "Processing "${CURRENT_ITEM}" in output file "${OUTPUT_FILE}
      if [ $DEBUG = true ]; then
			  sh getInfo.sh --debug --skip-download --windows --input ${CURRENT_ITEM} -o ${OUTPUT_FILE} || exit
      else
        sh getInfo.sh --skip-download --windows --input ${CURRENT_ITEM} -o ${OUTPUT_FILE} || exit
      fi
		else
			# USE LINK
      LOG_FILE="log_"${i}".txt"
      CLEAN_LINK=`echo ${CURRENT_ITEM} | sed 's/?ref=page_internal//'`
      if [ $DEBUG = true ]; then
        printf '%s\n' "DEBUG: Tidy link = ${CLEAN_LINK}" | fold -s
      fi
      if [ $DEBUG = true ]; then
        sh getInfo.sh --debug --log ${LOG_FILE} --windows --set-link ${CLEAN_LINK} -o ${OUTPUT_FILE} || exit
      else
			  sh getInfo.sh --log ${LOG_FILE} --windows --set-link ${CLEAN_LINK} -o ${OUTPUT_FILE} || exit
      fi
		fi
    echo "Entry $i completed."
		i=$(( $i+1 ))
done < ${INPUT_LIST}
echo "Great ! You can now spend more time to XXXX."
