#!/usr/bin/env bash

if [[ "$OSTYPE" == "msys" ]]; then
  echo "﴾͡๏̯͡๏﴿ O'RLY? You should not be messing with this. ლ(ಠ益ಠლ)"
  exit
elif [[ "$OSTYPE" == "win32" ]]; then
  echo "﴾͡๏̯͡๏﴿ O'RLY? You should not be messing with this. ლ(ಠ益ಠლ)"
  exit
elif [[ "$OSTYPE" == "cygwin" ]]; then
  echo "﴾͡๏̯͡๏﴿ O'RLY? You should not be messing with this. ლ(ಠ益ಠლ)"
  exit
fi

if ! curl --version &>/dev/null; then
  echo "(╯°□°)╯︵ curl does not exist."
  printf '%s\n' "Download curl from https://curl.haxx.se/windows/dl-7.65.3_1/curl-7.65.3_1-win64-mingw.zip" | fold -s
  exit
fi

if ! wget --version &>/dev/null; then
  echo "(╯°□°)╯︵ wget does not exist."
  printf '%s\n' "Download wget" | fold -s
  exit
fi

## DOWNLOAD AWK
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  if ! awk --version &>/dev/null; then
    echo "No AWK detected. Installing AWK"
  else
    VERSION_AWK=`"${AWK_EXE}" --version 2>&1 | "${AWK_EXE}" '/GNU Awk/{print $3}' | sed -e 's/,//g'`
    NUM_AWK=`echo ${VERSION_AWK} | sed -e 's/\.//g'`
    exit
    if [ ${NUM_AWK} -lt 421 ]; then
      printf '%s\n' "WARNING: Your AWK version is ${VERSION_AWK} is obselete" | fold -s
      echo "Installing AWK 4.2.1"
    fi
  fi

  sudo apt-get update
  sudo apt-get install gcc
  wget http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz
  tar -xvf gawk-4.2.1.tar.gz
  cd gawk-4.2.1
  ./configure
  sudo make install
fi


## DOWNLOAD TIDY HTML
echo "Start installing tidy."
cd ~/Documents/
mkdir -p cmder
cd cmder
mkdir -p userApp
curl -LO https://github.com/htacg/tidy-html5/releases/download/5.6.0/tidy-5.6.0-vc14-64b.zip
unzip tidy-5.6.0-vc14-64b.zip
echo "=== Task completed. (▀̿Ĺ̯▀̿ ̿)"
# Final check
if  ! [[ -d ~/Documents/cmder/userApp/tidy-5.6.0-vc14-64b/bin/ ]]; then
  echo "ლ(ಠ益ಠლ) Why ?!! tidy not found."
  exit
fi
### ʕ•ᴥ•ʔ OBSELETE ʕ•ᴥ•ʔ
# LINKS=(
# http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip
# http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip
# )
#
# LEN=${#LINKS[@]}
# for i in `seq 0 $LEN`; do
#   curl -LO ${LINKS[$i]}
# done
#
# for i in `seq 0 $LEN`; do
#   FILE=`echo ${LINKS[$i]} | grep  -A1 -oP '(/)(?!.*/).*\.zip' | sed 's/\///g'`
#   unzip $FILE
# done
#
# DESTINATION=`echo ${LINKS[0]} | grep  -A1 -oP '(/)(?!.*/).*\.zip' | sed 's/\///g' | sed 's/.zip//g'`
# for i in `seq 1 $LEN`; do
#   FILE=`echo ${LINKS[$i]} | grep  -A1 -oP '(/)(?!.*/).*\.zip' | sed 's/\///g' | sed 's/.zip//g'`
#   cp $FILE/bin/* $DESTINATION/bin
#   rm -r $FILE
# done
