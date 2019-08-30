SETUP Terminal
=================
***NOTE:*** REPLACE *yourusername*  WITH THE NAME OF YOUR ACCOUNT.

#### FOR WINDOWS


0. If you are using WINDOWS 10, then follow this link to setup [Windows Subsystem For Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10 "Windows Subsystem For Linux"). You are done with installation.
1. Copy **setup.ps1** a.k.a windows shell script from the repository  to your **C:\Users\yourusername\Documents** folder.
2. Run **powershell** from Windows Start Menu.
3. In the **powershell**, type:
   ```bash
   cd C:\Users\yourusername\Documents
   ```
4. To start downloading, in the **powershell** type:
   ```bash
   powershell -ExecutionPolicy ByPass -File setup.ps1
   ```
5. If everything goes well, then you are done.



#### FOR macOS & LINUX

1. Copy **setup.sh** to your **Downloads** folder.
2. Open **terminal**.
3. In the **terminal**, type:
   ```bash
   cd ~/Downloads
   ```
4. To start downloading, in the **terminal** type:
   ```bash
   sh setup.sh
   ```
5. If everything goes well, then you are done.

 Setup Workspace
=======

***NOTE:*** For macOS/Linux, replace **C:\Users\yourusername** with just the symbol **~** and **forwardslash (\\)** with **backslash (/)** in the path. Instead of launching **cmder**, you will be launching **terminal**.
      
***IMPORTANT:*** Use the link from the ABOUT page of Facebook profile.

0. Replace the word **yourusername**  with the name of your account whenever u see below.
1. Create a folder in **C:\Users\yourusername\Documents** folder. For example, name it **ServiceList**.
2. Copy **iterate.sh, getInfo.sh** to the **C:\Users\yourusername\Documents\ServiceList** folder.
3. In the **C:\Users\yourusername\Documents\ServiceList** folder, create a list of links that you want in a text file called **list.txt**. Enter all the links that you have in separate lines.
4. Now proceeed to the relevant **Run with** section.

 Run with cmder
=======
1. Run **cmder.exe** and go into **C:\Users\yourusername\Documents\ServiceList** folder by typing:
    ```bash
    cd C:\Users\yourusername\Documents\ServiceList
    ```
2. Start running by: (assuming u already created a list of links)
   ```bash
   sh iterate.sh --input list.txt
   ```
   If you have a list of html, then u can do:
   ```bash
   sh iterate.sh --html --input list.txt
   ```
   If you have a list with different name (say SHREK.txt):
   ```bash
   sh iterate.sh --input SHREK.txt
   ```
   If you created **list.txt** using Windows' **notepad**, then use this:
   ```bash
   sh iterate.sh --win-input --input list.txt
   ```
   
 Run with Windows Linus Subsystem
=======
  1. Open your linux terminal. Go to your directory by typing the following into your terminal.
  ```bash
    cd mnt/c/Users/yourusername/Documents/ServiceList
  ```
  2. Convert DOS formatted script to UNIX compatible script [**Optional**].
  ```bash
   ./dos2unix.sh iterate.sh
   ./dos2unix.sh getBusiness.sh
   ./dos2unix.sh getInfo.pl
   ```   
  3. Type the following if you use **terminal** to create your list.
  ```bash
   ./iterate.sh --win-subsys --input list.txt
   ``` 
  4. Type the following if you use **Notepad** to create your list.
  ```bash
   ./iterate.sh --win-subsys --win-input --input list.txt
   ``` 
