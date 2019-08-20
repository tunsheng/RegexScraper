#!/bin/bash -l

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
      printf "\t -i, --input\n"
      printf "\t\t\t Use custom name for list\n"
      printf "\t --html\n"
      printf "\t\t\t Use a list of html\n"
      echo

      echo "Report any bugs to author by including systematic documentations."
      echo "Make sure that your problem is reproducible."
      echo
      printf '%s\n' "WARNING: USER AT YOUR OWN RISK. THE AUTHOR IS NOT RESPONSIBLE FOR ANY DAMAGES." | fold -s
      echo
      printf '%s\n' "NO WARRANTIES: TO THE EXTENT PERMITTED BY APPLICABLE LAW, NOT ANY PERSON, EITHER EXPRESSLY OR IMPLICITLY, WARRANTS ANY ASPECT OF THIS SOFTWARE OR PROGRAM, INCLUDING ANY OUTPUT OR RESULTS OF THIS SOFTWARE OR PROGRAM. UNLESS AGREED TO IN WRITING. THIS SOFTWARE AND PROGRAM IS BEING PROVIDED \"AS IS\", WITHOUT ANY WARRANTY OF ANY TYPE OR NATURE, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, AND ANY WARRANTY THAT THIS SOFTWARE OR PROGRAM IS FREE FROM DEFECTS." | fold -s
      exit
      ;;
    --input | -i)
      INPUT_LIST=`echo $2 | awk '{$1=$1};1'`
			;;
    --html )
      IS_HTML=true
      ;;
  esac
  shift
done

# DEFAULT VALUES
if [ -z ${IS_HTML} ]
then
  IS_HTML=false
fi

if [ -z ${INPUT_LIST} ]
then
  INPUT_LIST='list.txt'
fi

###############
# MAIN SCRIPT #
###############
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
			sh getInfo.sh --skip-download --windows --input ${CURRENT_ITEM} -o ${OUTPUT_FILE}
		else
			# USE LINK
      LOG_FILE="log_"${i}".txt"
			sh getInfo.sh --log ${LOG_FILE} --windows --set-link ${CURRENT_ITEM} -o ${OUTPUT_FILE}
		fi
		i=$(( $i+1 ))
done < ${INPUT_LIST}
