#!/usr/bin/env bash

# TO RUN
#    $ powershell -ExecutionPolicy ByPass -File setup.ps1


if ($PSVersionTable.PSVersion.ToString() -lt 4.0) {
    Write-Output ("Please upgrade to Powershell 4.0 by upgrading to Windows 10.")
    Exit
}


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


# Packages
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

$toolUrls=@($tidyUrl)
$toolZips=@($tidyZip)

# Set initial starting point
$myDocumentDir=[Environment]::GetFolderPath("MyDocument")
$myDocumentDir=(Get-Location).ToString()
cd $myDocumentDir
$currentDir=(Get-Location).ToString()
Write-Output ("Current Path = "+$currentDir.ToString())

# Setup bash tools
mkdir -f cmder > $null
cd cmder
$currentDir=(Get-Location).ToString()
Write-Output ("Current Path = "+$currentDir.ToString())

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
    Expand-Archive -Force -Path $toolZips[$i] -DestinationPath $currentDir
}

Write-Output "Done"
