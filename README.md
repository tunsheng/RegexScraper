


STEP 1) Downloading CMDER
=================
NOTE: REPLACE yourusername  WITH THE NAME OF YOUR ACCOUNT.

**Method A:**
1. Download [cmder](https://github.com/cmderdev/cmder/releases/download/v1.3.12/cmder.zip "cmder").
2. Extract the zip file in your **C:\Users\yourusername\Documents** folder.

**Method B:**
1. Copy **setup.ps1**  to your **C:\Users\yourusername\Documents** folder
2. Run **powershell**
3. In the **powershell**, type:
   ```bash
   cd C:\Users\yourusername\Documents
   ```
4. Start downloading:
   ```bash
   powershell -ExecutionPolicy ByPass -File setup.ps1
   ```
5. If everything goes well, then you are done. Proceed to step 3.


STEP 2) Setup CMDER
===========
NOTE: REPLACE yourusername  WITH THE NAME OF YOUR ACCOUNT.

1. Go to your **cmder** folder. Make a new folder called **userApp**.
2. Go into **C:\Users\yourusername\Documents\cmder\userApp** folder and start dowloading the files here.
3. Paste the following links into your browser to download then unzip them.

     https://curl.haxx.se/windows/dl-7.65.3_1/curl-7.65.3_1-win64-mingw.zip
     
     https://github.com/htacg/tidy-html5/releases/download/5.6.0/tidy-5.6.0-vc14-64b.zip

     http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip
      
     http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip
      
5. Rename **wget-1.11.4-1-bin** folder to **wget-1.11.4-1**
6. Copy everything in the **C:\Users\yourusername\Documents\cmder\userApp\wget-1.11.4-1-dep\bin** into the **C:\Users\yourusername\Documents\cmder\userApp\wget-1.11.4-1\bin** folder. Delete **wget-1.11.4-1-dep** folder.
7. Open the **C:\Users\yourusername\Documents\cmder\config\user-profile.cmd** file using notepad. Paste the following at the end of the file.

```bash
set MY_APP_PATH="C:\Users\yourusername\Documents\cmder\userApp\"
set MY_WGET_PATH=%MY_APP_PATH%"wget-1.11.4-1\bin\"
set MY_TIDY_PATH=%MY_APP_PATH%"tidy-5.6.0-vc14-64b\bin\"
set MY_CURL_PATH=%MY_APP_PATH%"curl-7.65.3_1-win64-mingw\bin\"
set "PATH=%MY_WGET_PATH%;%MY_TIDY_PATH%;%MY_CURL_PATH%;%PATH%"
```

At this point you need to make sure that the following folders exist before proceeeding.
  - C:\Users\yourusername\Documents\cmder\myApp\curl-7.65.3-win64-mingw\bin
  - C:\Users\yourusername\Documents\cmder\myApp\tidy-5.6.0-vc14-64bw\bin
  - C:\Users\yourusername\Documents\cmder\myApp\wget-1.11.4-1\bin

STEP 3) RUNNING
=======
NOTE: REPLACE yourusername  WITH THE NAME OF YOUR ACCOUNT.
1. Create a folder in **C:\Users\yourusername\Documents** folder. For example, name it **ServiceList**.
2. Copy **iterate.sh, getInfo.sh** in the **C:\Users\yourusername\Documents\ServiceList** folder.
3. In the **C:\Users\yourusername\Documents\ServiceList** folder, create a list of links that you want in a text file called **list.txt**. Enter all the links that you have in separate lines.
5. Run **cmder.exe** and go into **C:\Users\yourusername\Documents\ServiceList** folder by typing:
    ```bash
    cd C:\Users\yourusername\Documents\ServiceList
    ```
6. Start running by: (assuming u already created a list of links)
   ```bash
   sh iterate.sh
   ```
   If you have a list of html, then u can do:
   ```bash
   sh iterate.sh --html
   ```

   If you have a list with different name (say SHREK.txt):
   ```bash
   sh iterate.sh -i SHREK.txt
   ```
