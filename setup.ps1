# TO RUN
#    $ powershell -ExecutionPolicy ByPass -File setup.ps1

# https://blogs.technet.microsoft.com/dsheehan/2018/10/27/powershell-taking-control-over-ctrl-c/
# Change the default behavior of CTRL-C so that the script can intercept and use it versus just terminating the script.
[Console]::TreatControlCAsInput = $True
# Sleep for 1 second and then flush the key buffer so any previously pressed keys are discarded and the loop can monitor for the use of
#   CTRL-C. The sleep command ensures the buffer flushes correctly.
Start-Sleep -Seconds 1
$Host.UI.RawUI.FlushInputBuffer()


function DownloadFile($url, $targetFile)
{
   # https://stackoverflow.com/questions/21422364/is-there-any-way-to-monitor-the-progress-of-a-download-using-a-webclient-object
   $uri = New-Object "System.Uri" "$url"

   $request = [System.Net.HttpWebRequest]::Create($uri)

   $request.set_Timeout(15000) #15 second timeout

   $response = $request.GetResponse()

   $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)

   $responseStream = $response.GetResponseStream()

   $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create

   $buffer = new-object byte[] 10KB

   $count = $responseStream.Read($buffer,0,$buffer.length)

   $downloadedBytes = $count

   while ($count -gt 0)

   {
       # If a key was pressed during the loop execution, check to see if it was CTRL-C (aka "3"), and if so exit the script after clearing
       #   out any running jobs and setting CTRL-C back to normal.

      If ($Host.UI.RawUI.KeyAvailable -and ($Key = $Host.UI.RawUI.ReadKey("AllowCtrlC,NoEcho,IncludeKeyUp"))) {
           If ([Int]$Key.Character -eq 3) {
               Write-Host ""
               Write-Warning "CTRL-C was used - Shutting down any running jobs before exiting the script."
               Get-Job | Where-Object {$_.Name -like "MessageProfile*"} | Remove-Job -Force -Confirm:$False
               [Console]::TreatControlCAsInput = $False
               Exit
           }
           # Flush the key buffer again for the next loop.
           $Host.UI.RawUI.FlushInputBuffer()
       }

       $targetStream.Write($buffer, 0, $count)

       $count = $responseStream.Read($buffer,0,$buffer.length)

       $downloadedBytes = $downloadedBytes + $count
       if (0 -eq $count % 100) {
        Write-Progress -activity "Downloading file '$($url.split('/') | Select -Last 1)'" -status "Downloaded ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
       }
   }

   Write-Progress -activity "Finished downloading file '$($url.split('/') | Select -Last 1)'"

   $targetStream.Flush()

   $targetStream.Close()

   $targetStream.Dispose()

   $responseStream.Dispose()

}

# Set initial starting point
$myDocumentDir=[Environment]::GetFolderPath("MyDocument")
$myDocumentDir=(Get-Location).ToString()
cd $myDocumentDir
$currentDir=(Get-Location).ToString()
Write-Output ("Current Path = "+$currentDir.ToString())
$cmderUrl="https://github.com/cmderdev/cmder/releases/download/v1.3.12/cmder.zip"
$curlUrl="https://curl.haxx.se/windows/dl-7.65.3_1/curl-7.65.3_1-win64-mingw.zip"
$tidyUrl="https://github.com/htacg/tidy-html5/releases/download/5.6.0/tidy-5.6.0-vc14-64b.zip"
$wgetUrl="http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip"
$wgetDepUrl="http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-dep.zip"
$cmderZip="cmder.zip"
$curlZip="curl-7.65.3_1-win64-mingw.zip"
$tidyZip="tidy-5.6.0-vc14-64b.zip"
$wgetZip="wget-1.11.4-1-bin.zip"
$wgetDepZip="wget-1.11.4-1-dep.zip"

$toolUrls=@($curlUrl, $tidyUrl, $wgetUrl, $wgetDepUrl)
$toolZips=@($curlZip, $tidyZip, $wgetZip, $wgetDepZip)

# Setup cmder
if  (! [System.IO.File]::Exists($cmderZip)) {
    DownloadFile $cmderUrl $cmderZip
}

if  (! (Test-Path -Path cmder)) {
    Expand-Archive -Force -Path $cmderZip -DestinationPath cmder
}

# Setup bash tools
cd cmder
$currentDir=(Get-Location).ToString()
Write-Output ("Current Path = "+$currentDir.ToString())

Write-Output ("Starting cmder... [Wait for 5s]")
.\Cmder.exe
Start-Sleep -s 5

mkdir -f userApp > $null
cd userApp
$currentDir=(Get-Location).ToString()
Write-Output ("Current Path = "+$currentDir.ToString())

for ($i=0; $i -lt $toolZips.Length; $i++) {
    $zipPath=$myDocumentDir+"\"+$toolZips[$i]
    $targetPath=$currentDir+"\"+$toolZips[$i]
    if  (! [System.IO.File]::Exists($zipPath)) {
        DownloadFile $toolUrls[$i] $toolZips[$i]
    }

    if ( [System.IO.File]::Exists($zipPath)) {
            mv -force $zipPath $targetPath
    }


    $unpackedFolder=$toolZips[$i].ToString() -replace ".zip"
    Write-Output ("Unpacking "+$toolZips[$i].ToString())
    Expand-Archive -Force -Path $toolZips[$i] -DestinationPath $unpackedFolder
}

if   (Test-Path -Path wget-1.11.4-1-dep/bin) {
        cp wget-1.11.4-1-dep/bin/* wget-1.11.4-1-bin/bin
}

if   (Test-Path -Path wget-1.11.4-1-dep) {
        rm -r wget-1.11.4-1-dep
}


$configFile=$myDocumentDir+"\cmder\config\user_profile.cmd"
if ( [System.IO.File]::Exists($configFile)) {
    $appPath="set MY_APP_PATH=`""+$myDocumentDir.ToString()+"\cmder\userApp\`""
    Add-Content  $configFile -Value $appPath
    Add-Content  $configFile -Value 'set MY_WGET_PATH=%MY_APP_PATH%"wget-1.11.4-1\bin\"'
    Add-Content  $configFile -Value 'set MY_TIDY_PATH=%MY_APP_PATH%"tidy-5.6.0-vc14-64b\bin\"'
    Add-Content  $configFile -Value 'set MY_CURL_PATH=%MY_APP_PATH%"curl-7.65.3_1-win64-mingw\bin\"'
    Add-Content  $configFile -Value 'set "PATH=%MY_WGET_PATH%;%MY_TIDY_PATH%;%MY_CURL_PATH%;%PATH%"'
}

$configFile=$myDocumentDir+"\cmder\config\user-profile.cmd"
if ( [System.IO.File]::Exists($configFile)) {
    $appPath="set MY_APP_PATH=`""+$myDocumentDir.ToString()+"\cmder\userApp\`""
    Add-Content  $configFile -Value $appPath
    Add-Content  $configFile -Value 'set MY_WGET_PATH=%MY_APP_PATH%"wget-1.11.4-1\bin\"'
    Add-Content  $configFile -Value 'set MY_TIDY_PATH=%MY_APP_PATH%"tidy-5.6.0-vc14-64b\bin\"'
    Add-Content  $configFile -Value 'set MY_CURL_PATH=%MY_APP_PATH%"curl-7.65.3_1-win64-mingw\bin\"'
    Add-Content  $configFile -Value 'set "PATH=%MY_WGET_PATH%;%MY_TIDY_PATH%;%MY_CURL_PATH%;%PATH%"'
}

Write-Output "Done"
