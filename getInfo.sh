#!/bin/bash -l

################
# CHECK PREREQ #
################

export PATH=$PATH:~/Documents/cmder/myApp/curl-7.65.3-win64-mingw/bin/
export PATH=$PATH:~/Documents/cmder/myApp/tidy-5.6.0-vc14-64b/bin/
export PATH=$PATH:~/Documents/cmder/myApp/wget-1.11.4-1/bin/

if [ $# -eq 0 ]; then
		printf '%s\n' "ERROR: try 'sh getInfo.sh --help' for more information" | fold -s
		exit
fi

if ! [[ -d ~/Documents/cmder/myApp/curl-7.65.3-win64-mingw/bin/ ]]; then
  printf '%s\n' "ERROR: ~/Documents/cmder/myApp/curl-7.65.3-win64-mingw/bin/ does not exist." | fold -s
	exit
fi

if ! [[ -d ~/Documents/cmder/myApp/tidy-5.6.0-vc14-64b/bin/ ]]; then
  printf '%s\n' "ERROR: ~/Documents/cmder/myApp/tidy-5.6.0-vc14-64b/bin/ does not exist." | fold -s
	exit
fi

if ! [[ -d ~/Documents/cmder/myApp/wget-1.11.4-1/bin/ ]]; then
  printf '%s\n' "ERROR: ~/Documents/cmder/myApp/wget-1.11.4-1/bin/ does not exist." | fold -s
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
      CLEAN_HTML=`echo $2 | awk '{$1=$1};1'`
      ;;
		--input | -i)
			USER_HTML=`echo $2 | awk '{$1=$1};1'`
			;;
		--log )
			LOG_FILE=`echo $2 | awk '{$1=$1};1'`
			;;
		--output | -o )
      OUTPUT_FILE=`echo $2 | awk '{$1=$1};1'`
      ;;
    --skip-download )
      SKIP_DOWNLOAD=true
      ;;
		--set-link )
			FB_LINK=`echo $2 | awk '{$1=$1};1'`
			;;
		--windows )
			WINDOWS_FILE=true
			;;
  esac
  shift
done

# DEFAULT VALUES
if [ -z ${FB_LINK} ]
then
  FB_LINK=https://www.facebook.com/pg/sgairconservicing/about/
fi

if [ -z ${OUTPUT_FILE} ]
then
  OUTPUT_FILE='business_info.txt'
fi

if [ -z ${USER_HTML} ]
then
  USER_HTML='index.html'
fi

if [ -z ${CLEAN_HTML} ]
then
  CLEAN_HTML='tidy.html'
fi

if [ -z ${SKIP_DOWNLOAD} ]
then
  SKIP_DOWNLOAD=false
fi

if [ -z ${LOG_FILE} ]
then
  LOG_FILE='log.txt'
fi

if [ -z ${WINDOWS_FILE} ]
then
  WINDOWS_FILE=false
fi

###############
# MAIN SCRIPT #
###############

# Remove old files
rm -rf ${OUTPUT_FILE}

# DOWNLOAD HTML
if [ ${SKIP_DOWNLOAD} = 'false' ]; then
  echo DOWNLOADING HTML FROM ${FB_LINK}
  rm -rf index.html ${LOG_FILE}
  wget --no-check-certificate -U "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36" ${FB_LINK} -o ${LOG_FILE}
fi

if ! [[ -f ${USER_HTML} ]]; then
  echo "ERROR: ${USER_HTML} does not exist."
	exit
fi


# TIDY UP MESSY HTML
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

tidy -config messy.config -q ${USER_HTML}
rm messy.config

# GET INFORMATION
email=`grep "mailto:" ${CLEAN_HTML} | grep -EiEio '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b'`
phone=`grep "Call +" ${CLEAN_HTML} | sed 's/Call//' | awk '{$1=$1};1'`
websiteurl=`grep -B2 -A3 -oP '"website_url":"http:\K[^"]+' ${CLEAN_HTML} | awk '!seen[$0]++' | sed 's/[\]//g'`
websiteurl="http:"$websiteurl
websiteurlhttps=`grep -B2 -A3 -oP '"website_url":"https:\K[^"]+' ${CLEAN_HTML} | awk '!seen[$0]++' | sed 's/[\]//g'`
websiteurlhttps="http:"$websiteurlhttps
category=`grep -B2 -A3 -oP '"category_type"\:"\K[^"]+' ${CLEAN_HTML}`
hours=`awk '/alt="clock"/{
  for (i=1;i<=4;i++) {
    getline;
  }
  while ($1 !="</div>") {
    print;
    getline;
  }
}' ${CLEAN_HTML}`
hours=`echo $hours | grep -B2 -A3 -oP '>\K[^<]+'`
aboutTag=`awk '
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
description=`awk -v tag="$aboutTag" '$0~tag{
  while ($1 !="</div>") {
    print;
    getline;
  }
}' ${CLEAN_HTML}`
descriptionMain=`echo $description | grep -A2 -B3 -oP "${aboutTag}\K[^<]+"`
descriptionMain=`echo $descriptionMain | awk '
  function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
  function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
  function trim(s) { return rtrim(ltrim(s)); }
  {  print trim($0) };'`
descriptionDetail=`echo $description | sed 's/<a\(.*\)[/]a>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<br>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<[/]span>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/\.\.\.//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<div[^>]*>//g'`
descriptionDetail=`echo $descriptionDetail | sed 's/<span[^>]*>//g'`
descriptionDetail=`echo $descriptionDetail | sed "0,/$descriptionMain/{s/$descriptionMain//}"`
companyName=`grep -A2 -B3 -oP '<meta property="og:title" content="\K[^<]+"' ${CLEAN_HTML} | sed 's/"//g'`

mapInfo=`awk '
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
postalCode=`echo $mapInfo | grep -B2 -A3 -oP '"postalCode"\:"\K[^"]+'`
state=`echo $mapInfo | grep -B2 -A3 -oP '"addressRegion"\:"\K[^"]+'`
streetAddress=`echo $mapInfo | grep -B2 -A3 -oP '"streetAddress"\:"\K[^"]+'`
addressLocality=`echo $mapInfo | grep -B2 -A3 -oP '"addressLocality"\:"\K[^"]+'`

#### PRINT
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

if [ ${WINDOWS_FILE} = true ]; then
	# Convert UNIX to Win
	mv ${OUTPUT_FILE} temporary_html.txt
	perl -p -e 's/\n/\r\n/' < temporary_html.txt > ${OUTPUT_FILE}
	rm temporary_html.txt
fi
rm ${CLEAN_HTML}
