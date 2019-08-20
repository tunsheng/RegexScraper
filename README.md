HOW TO SETUP YOUR WORKFLOW

=================
Downloading CMDER
=================
NOTICE: Use method B for now, since it is quicker.

Method A: Have setup.ps1 in your "Documents" folder [Can be slow]
   1) Run powershell
   2) In the powershell, type:
         cd Documents
   3) Then type:
         powershell -ExecutionPolicy ByPass -File setup.ps1

Method B: Open your browser and paste the following links
   https://github.com/cmderdev/cmder/releases/download/v1.3.12/cmder.zip

   1) Extract the zip file in your Documents folder.

===========
Setup CMDER
===========
NOTICE: if cmder has the CURL functionality, then skip dowloading CURL.

1) Go to your cmder folder. Make a new folder called userApp.
2) Go into userApp folder and start dowloading.
3) Paste the following links into your browser to download then unzip them.
     https://curl.haxx.se/windows/dl-7.65.3_1/curl-7.65.3_1-win64-mingw.zip
     https://github.com/htacg/tidy-html5/releases/download/5.6.0/tidy-5.6.0-vc14-64b.zip
4) a. In the same folder, download and extract everything.
      http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip
      http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip
   b. Rename wget-1.11.4-1-bin folder to wget-1.11.4-1
   c. Copy everything in the bin folder of wget-1.11.4-1-dep folder into the bin folder of
      wget-1.11.4-1
5) Open the user-profile.cmd file in config folder of cmder folder using notepad.
   Paste the following at the end of the file.

    set MY_APP_PATH="C:\Users\yourusername\Documents\cmder\userApp\"
    set MY_WGET_PATH=%MY_APP_PATH%"wget-1.11.4-1\bin\"
    set MY_TIDY_PATH=%MY_APP_PATH%"tidy-5.6.0-vc14-64b\bin\"
    set MY_CURL_PATH=%MY_APP_PATH%"curl-7.65.3_1-win64-mingw\bin\"
    set "PATH=%MY_WGET_PATH%;%MY_TIDY_PATH%;%MY_CURL_PATH%;%PATH%"

========
RUNNING
========
NOTICE: Make sure that the following folder exits
  Documents/cmder/myApp/curl-7.65.3-win64-mingw/bin/
  Documents/cmder/myApp/tidy-5.6.0-vc14-64b/bin/
  Documents/cmder/myApp/wget-1.11.4-1/bin/

1) Create a folder in Documents folder. Rename it as ServiceList

2) a. Go into that folder. Extract Software.zip file there.
   b. Create a list of links that u want in a text file called list.txt
   c. Each line should contain a link

3) Run cmder and go into that folder by typing:
      cd C:\Users\yourusername\Documents\ServiceList

4) Start running by: (assuming u already created a list of links)
      sh iterate.sh

   If you have a list of html, then u can do:
      sh iterate.sh --html

   If you have a list with different name (say SHREK.txt):
      sh iterate.sh -i SHREK.txt
