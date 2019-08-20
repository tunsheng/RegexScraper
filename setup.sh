
#!/bin/bash -l

# PREREQ
# https://curl.haxx.se/windows/dl-7.65.3_1/curl-7.65.3_1-win64-mingw.zip

## DOWNLOAD TIDY HTML
curl -LO https://github.com/htacg/tidy-html5/releases/download/5.6.0/tidy-5.6.0-vc14-64b.zip
unzip tidy-5.6.0-vc14-64b.zip

## DOWNLOAD
LINKS=(
http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip
http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip
http://gnuwin32.sourceforge.net/downlinks/libintl-bin-zip.php
http://gnuwin32.sourceforge.net/downlinks/libintl-dep-zip.php
http://gnuwin32.sourceforge.net/downlinks/libiconv-bin-zip.php
http://gnuwin32.sourceforge.net/downlinks/libiconv-dep-zip.php
http://downloads.sourceforge.net/gnuwin32/openssl-0.9.8h-1-bin.zip
)

LEN=${#LINKS[@]}
for i in `seq 0 $LEN`; do
  curl -LO ${LINKS[$i]}
done

for i in `seq 0 $LEN`; do
  FILE=`echo ${LINKS[$i]} | grep  -A1 -oP '(/)(?!.*/).*\.zip' | sed 's/\///g'`
  unzip $FILE
done


DESTINATION=`echo ${LINKS[0]} | grep  -A1 -oP '(/)(?!.*/).*\.zip' | sed 's/\///g' | sed 's/.zip//g'`
for i in `seq 1 $LEN`; do
  FILE=`echo ${LINKS[$i]} | grep  -A1 -oP '(/)(?!.*/).*\.zip' | sed 's/\///g' | sed 's/.zip//g'`
  cp $FILE/bin/* $DESTINATION/bin
  rm -r $FILE
done
