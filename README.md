SETUP
=================
NOTE: REPLACE *yourusername*  WITH THE NAME OF YOUR ACCOUNT.

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

 RUNNING
=======
NOTE: REPLACE *yourusername*  WITH THE NAME OF YOUR ACCOUNT.

IMPORTANT: Use the link from the ABOUT page of Facebook profile.

1. Create a folder in **C:\Users\yourusername\Documents** folder. For example, name it **ServiceList**.
2. Copy **iterate.sh, getInfo.sh** to the **C:\Users\yourusername\Documents\ServiceList** folder.
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
