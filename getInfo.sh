#!/usr/bin/env bash

if [ $# -eq 0 ]; then
		printf '%s\n' "ERROR: try 'sh getInfo.sh --help' for more information" | fold -s
		exit
fi


#####################
# DO NOT EDIT BELOW #
#####################
while [ ! $# -eq 0 ]
do
  case "$1" in
    --help | -h)
      printf "Usage: sh getInfo.sh [OPTION]...\n"
      printf "\t --clean-input\n"
      printf "\t\t\t Set tidy input html\n"
			printf "\t --debug\n"
			printf "\t\t\t Running in debug mode\n"
      printf "\t -i, --input\n"
      printf "\t\t\t Set messy input html\n"
			printf "\t -log\n"
			printf "\t\t\t Set custom log output when downloading html\n"
      printf "\t -o, --output\n"
      printf "\t\t\t Set messy input html\n"
      printf "\t --skip-download\n"
      printf "\t\t\t Skip downloading html\n"
      printf "\t --set-link\n"
      printf "\t\t\t Set facebook link for download\n"
			printf "\t --windows\n"
			printf "\t\t\t Output windows compatible output\n"
      echo
      echo "Report any bugs to author by including systematic documentations."
      echo "Make sure that your problem is reproducible."
      echo
      printf '%s\n' "WARNING: USER AT YOUR OWN RISK. THE AUTHOR IS NOT RESPONSIBLE FOR ANY DAMAGES." | fold -s
      echo
      printf '%s\n' "NO WARRANTIES: TO THE EXTENT PERMITTED BY APPLICABLE LAW, NOT ANY PERSON, EITHER EXPRESSLY OR IMPLICITLY, WARRANTS ANY ASPECT OF THIS SOFTWARE OR PROGRAM, INCLUDING ANY OUTPUT OR RESULTS OF THIS SOFTWARE OR PROGRAM. UNLESS AGREED TO IN WRITING. THIS SOFTWARE AND PROGRAM IS BEING PROVIDED \"AS IS\", WITHOUT ANY WARRANTY OF ANY TYPE OR NATURE, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, AND ANY WARRANTY THAT THIS SOFTWARE OR PROGRAM IS FREE FROM DEFECTS." | fold -s
      exit
      ;;
    --clean-input )
      CLEAN_HTML=`echo $2 | "${AWK_EXE}" '{$1=$1};1'`
      ;;
		--debug )
			DEBUG=true
			;;
		--input | -i)
			USER_HTML=`echo $2 | "${AWK_EXE}" '{$1=$1};1'`
			;;
		--log )
			LOG_FILE=`echo $2 | "${AWK_EXE}" '{$1=$1};1'`
			;;
		--output | -o )
      OUTPUT_FILE=`echo $2 | "${AWK_EXE}" '{$1=$1};1'`
      ;;
    --skip-download )
      SKIP_DOWNLOAD=true
      ;;
		--set-link )
			FB_LINK=`echo $2 | "${AWK_EXE}" '{$1=$1};1'`
			;;
		--windows )
			WINDOWS_FILE=true
			;;
		--win-subsys )
			WIN_SUBSYS=true
			;;
		--win-awk )
			# THIS FLAG IS NOT USABLE
			WIN_AWK=false
			;;
  esac
  shift
done


# DEFAULT VALUES
FB_LINK="${FB_LINK:-https://www.facebook.com/pg/sgairconservicing/about/}"
OUTPUT_FILE="${OUTPUT_FILE:-business_info.txt}"
USER_HTML="${USER_HTML:-index.html}"
CLEAN_HTML="${CLEAN_HTML:-tidy.html}"
SKIP_DOWNLOAD="${SKIP_DOWNLOAD:-false}"
LOG_FILE="${LOG_FILE:-log.txt}"
WINDOWS_FILE="${WINDOWS_FILE:-false}"
DEBUG="${DEBUG:-false}"
WIN_SUBSYS="${WIN_SUBSYS:-false}"
WIN_AWK="${WIN_AWK:-false}"
TIDY_EXE=''
AWK_EXE=''

if [ $DEBUG = true ]; then echo ; echo "Running getInfo in DEBUG mode"; fi

######################
# CHECK FOR PACKAGES #
######################
basePath=`echo ~`

# curlPath=$basePath/Documents/cmder/userApp/curl-7.65.3_1-win64-mingw/bin/
# curlPathAlt=$basePath/Documents/cmder/myApp/curl-7.65.3_1-win64-mingw/bin/

if [ ${WIN_SUBSYS} = true ]; then
	USERNAME=`pwd | grep -oP '/mnt/c/Users/\K[^/]+' | sed -e 's/ /\\ /g'`
	TIDY_EXE="/mnt/c/Users/${USERNAME}/Documents/cmder/userApp/tidy-5.6.0-vc14-64b/bin/tidy.exe"
	echo ${TIDY_EXE}
	if [ ! -f "${TIDY_EXE}" ]; then
		echo ERROR: tidy.exe does not exist.
		exit
	fi
fi

if [ ${WIN_AWK} = true ]; then
	USERNAME=`pwd | grep -oP '/mnt/c/Users/\K[^/]+' | sed -e 's/ /\\ /g'`
	AWK_EXE="/mnt/c/Users/${USERNAME}/Documents/ServiceList/gawk-5.0.1-w32-bin/bin/gawk.exe"
	echo ${AWK_EXE}
	if [ ! -f "${AWK_EXE}" ]; then
		echo ERROR: awk.exe does not exist.
		exit
	fi
fi

if ! tidy --version &>/dev/null; then
	tidyPath=$basePath/Documents/cmder/userApp/tidy-5.6.0-vc14-64b/bin/
	tidyPathAlt=$basePath/Documents/cmder/myApp/tidy-5.6.0-vc14-64b/bin/
	export PATH=$PATH:$tidyPath:$tidyPathAlt
fi

if ! wget --version &>/dev/null; then
	wgetPath=$basePath/Documents/cmder/userApp/wget-1.11.4-1/bin/
	wgetPathAlt=$basePath/Documents/cmder/myApp/wget-1.11.4-1/bin/
export PATH=$PATH:$wgetPath:$wgetPathAlt
fi

if [ -z "${AWK_EXE}" ]; then
	AWK_EXE='awk'
	if ! "${AWK_EXE}" --version &>/dev/null; then
		echo "ERROR: Please install AWK"
		exit
	else
		VERSION_AWK=`"${AWK_EXE}" --version 2>&1 | "${AWK_EXE}" '/GNU Awk/{print $3}' | sed -e 's/,//g'`
		NUM_AWK=`echo ${VERSION_AWK} | sed -e 's/\.//g'`
		if [ ${NUM_AWK} -lt 421 ]; then
			printf '%s\n' "ERROR: Your AWK version is ${VERSION_AWK}. Please updagrade to version 4.2.1 or later" | fold -s
			# wget http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz
		fi
	fi
fi

if [ -z "${TIDY_EXE}" ]; then
	TIDY_EXE='tidy'
	if ! "${TIDY_EXE}" --version &>/dev/null; then
		printf '%s\n' "(╯°□°)╯︵ tidy not found. Check the path." | fold -s
		printf '%s\n' "Remember to use --win-subsys flag for linux subsystem." | fold -s
		exit
	fi
fi

if ! wget --version &>/dev/null; then
  printf '%s\n' "(╯°□°)╯︵ wget not found. Check the path." | fold -s
  exit
fi

if [  $DEBUG = true  ]; then
	echo "DEBUG: Your OS is "$OSTYPE
fi

###############
# MAIN SCRIPT #
###############

# Remove old files
if [ -f ${OUTPUT_FILE} ]; then
	echo "Removing old output file"
	rm -rf ${OUTPUT_FILE}
fi

# DOWNLOAD HTML
if [ ${SKIP_DOWNLOAD} = 'false' ]; then
  echo DOWNLOADING HTML FROM ${FB_LINK}
  rm -rf index.html ${LOG_FILE}
  wget --no-check-certificate -U "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36" ${FB_LINK} -o ${LOG_FILE} -O index.html
else
	if [  $DEBUG = true  ]; then
		echo "DEBUG: Skipping download"
	fi
fi

if ! [[ -f ${USER_HTML} ]]; then
  echo "ERROR: ${USER_HTML} does not exist."
	exit
fi


# TIDY UP MESSY HTML
if [ $DEBUG = true ]; then echo "DEBUG: TIDY UP MESSY HTML"; fi

cat << EOF > 'messy.config'
indent: auto
indent-spaces: 2
write-back: no
output-html: yes
output-xml: no
output-file: ${CLEAN_HTML}
markup: yes
wrap: 10000
join-classes: yes
strict-tags-attributes: no
repeated-attributes: keep-first
hide-comments: yes
show-warnings: no
quote-marks: yes
quote-nbsp: yes
quote-ampersand: no
break-before-br: no
uppercase-tags: no
uppercase-attributes: no
char-encoding: utf8
EOF


"${TIDY_EXE}" -config messy.config -q ${USER_HTML}
rm messy.config

# GET INFORMATION
if [ $DEBUG = true ]; then echo "DEBUG: GET INFORMATION"; fi

email=`grep "mailto:" ${CLEAN_HTML} | grep -EiEio '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b'`
if [ $DEBUG = true ]; then echo "DEBUG: email: "$email; fi
phone=`grep "Call +" ${CLEAN_HTML} | sed 's/Call//' | "${AWK_EXE}" '{$1=$1};1'`
if [ $DEBUG = true ]; then echo "DEBUG: phone: "$phone; fi
websiteurl=`grep -B2 -A3 -oP '"website_url":"http:\K[^"]+' ${CLEAN_HTML} | "${AWK_EXE}" '!seen[$0]++' | sed 's/[\]//g'`
websiteurl="http:"$websiteurl
websiteurlhttps=`grep -B2 -A3 -oP '"website_url":"https:\K[^"]+' ${CLEAN_HTML} | "${AWK_EXE}" '!seen[$0]++' | sed 's/[\]//g'`
websiteurlhttps="http:"$websiteurlhttps
if [ $DEBUG = true ]; then echo "DEBUG: url: "$websiteurl; fi
category=`grep -B2 -A3 -oP '"category_type"\:"\K[^"]+' ${CLEAN_HTML}`
if [ $DEBUG = true ]; then echo "DEBUG: Category: "$category; fi
hours=`"${AWK_EXE}" '/alt="clock"/{
  for (i=1;i<=4;i++) {
    getline;
  }
  while ($1 !="</div>") {
    print;
    getline;
  }
}' ${CLEAN_HTML}`
hours=`echo $hours | grep -B2 -A3 -oP '>\K[^<]+'`
if [ $DEBUG = true ]; then echo "DEBUG: Hours: "$hours; fi
aboutTag=`"${AWK_EXE}" '
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }
/MORE INFO/{
  while ($1 !="About") {
    prev=$0;
    getline;
  }
  getline; # </div>
  getline; # <div>
  print trim($0);
};
' ${CLEAN_HTML}`
if [ $DEBUG = true ]; then echo "DEBUG: AboutTag: "$aboutTag; fi
description=`"${AWK_EXE}" -v tag="$aboutTag" '$0~tag{
  while ($1 !="</div>") {
    print;
    getline;
  }
}' ${CLEAN_HTML}`
if [ $DEBUG = true ]; then echo "DEBUG: Description: "$description; fi
descriptionMain=`echo $description | grep -A2 -B3 -oP "${aboutTag}\K[^<]+"`
descriptionMain=`echo $descriptionMain | "${AWK_EXE}" '
  function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
  function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
  function trim(s) { return rtrim(ltrim(s)); }
  {  print trim($0) };'`
if [ $DEBUG = true ]; then echo "DEBUG: descriptionMain: "$descriptionMain; fi
descriptionDetail=`echo $description | sed 's/<a\(.*\)[/]a>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<br>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<[/]span>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/\.\.\.//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<div[^>]*>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<span[^>]*>//g'`
descriptionDetail=`echo $descriptionDetail | sed "0,/$descriptionMain/{s/$descriptionMain//}"`
if [ $DEBUG = true ]; then echo "DEBUG: descriptionDetail: "$descriptionDetail; fi
companyName=`grep -A2 -B3 -oP '<meta property="og:title" content="\K[^<]+"' ${CLEAN_HTML} | sed 's/"//g'`
if [ $DEBUG = true ]; then echo "DEBUG: Name: "$companyName; fi
mapInfo=`"${AWK_EXE}" '
  function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
  function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
  function trim(s) { return rtrim(ltrim(s)); }
  /application\/ld\+json/{
  prev=$0;
  while(trim($1)!="</script>") {
    prev=$0;
    getline;
  }
  print trim(prev);
}' ${CLEAN_HTML}`
if [ $DEBUG = true ]; then echo "DEBUG: mapInfo: "$mapInfo; fi
postalCode=`echo $mapInfo | grep -B2 -A3 -oP '"postalCode"\:"\K[^"]+'`
if [ $DEBUG = true ]; then echo "DEBUG: postalCode: "$postalCode; fi
state=`echo $mapInfo | grep -B2 -A3 -oP '"addressRegion"\:"\K[^"]+'`
if [ $DEBUG = true ]; then echo "DEBUG: state: "$state; fi
streetAddress=`echo $mapInfo | grep -B2 -A3 -oP '"streetAddress"\:"\K[^"]+'`
if [ $DEBUG = true ]; then echo "DEBUG: streetAddress: "$streetAddress; fi
addressLocality=`echo $mapInfo | grep -B2 -A3 -oP '"addressLocality"\:"\K[^"]+'`
if [ $DEBUG = true ]; then echo "DEBUG: addressLocality: "$addressLocality; fi


#### PRINT
if [ $DEBUG = true ]; then echo "DEBUG: SAVING OUTPUT FILE"; fi
# if [ $DEBUG = true ]; then
# 	echo "===== Company Information ======"
# 	echo "Company name = $companyName"
# 	echo ""
# 	echo "Hours = $hours"
# 	echo "Address Locality: $addressLocality"
# 	echo "Street Address: $streetAddress"
# 	echo "Category = $category"
# 	echo "Postal Code = $postalCode"
# 	echo "State = $state"
# 	echo "Email = $email"
# 	echo "Phone = $phone"
# 	echo "URL 1 = $websiteurl"
# 	echo "URL 2 = $websiteurlhttps"
# 	echo ""
# 	echo "===== Business Description ======"
# 	echo "Introduction = $descriptionMain"
# 	echo ""
# 	echo "Detail description = $descriptionDetail"
# fi

echo "===== Company Information ======" >> ${OUTPUT_FILE}
echo "Company name = $companyName" >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}
echo "Hours = $hours" >> ${OUTPUT_FILE}
echo "Address Locality: $addressLocality" >> ${OUTPUT_FILE}
echo "Street Address: $streetAddress" >> ${OUTPUT_FILE}
echo "Category = $category" >> ${OUTPUT_FILE}
echo "Postal Code = $postalCode" >> ${OUTPUT_FILE}
echo "State = $state" >> ${OUTPUT_FILE}
echo "Email = $email" >> ${OUTPUT_FILE}
echo "Phone = $phone" >> ${OUTPUT_FILE}
echo "URL 1 = $websiteurl" >> ${OUTPUT_FILE}
echo "URL 2 = $websiteurlhttps" >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}
echo "===== Business Description ======" >> ${OUTPUT_FILE}
echo "Introduction = $descriptionMain" >> ${OUTPUT_FILE}
echo "" >> ${OUTPUT_FILE}
echo "Detail description = $descriptionDetail" >> ${OUTPUT_FILE}

if [ $DEBUG = true ]; then echo "DEBUG: CONVERTING TO NOTEPAD FORMAT"; fi
if [ ${WINDOWS_FILE} = true ]; then
	# Convert UNIX to Win
	# https://pdes-net.org/x-haui/archives/2010/02/01/howto_convert_windows-style_line_endings_to_unix-style_and_vice_versa/index.html
	mv ${OUTPUT_FILE} unix_output.txt
	perl -p -e 's/\n/\r\n/' < unix_output.txt > ${OUTPUT_FILE}
	rm unix_output.txt
fi
rm ${CLEAN_HTML}
if [ $DEBUG = true ]; then echo "DEBUG: DONE"; fi
