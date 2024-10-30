# Define the URL for the latest release
  $LibrewolfURL = "https://gitlab.com/api/v4/projects/librewolf-community%2Fbrowser%2Fbsys5/releases"

# Get the latest release information
  $LibrewolfInfo = Invoke-RestMethod -Uri $LibrewolfURL -Method Get
  $LatestReleaseLibrewolf = $LibrewolfInfo[0]

# Get the download URL for the portable version
  $portableDownloadUrl = $LatestReleaseLibrewolf.assets | Where-Object {$_.name -like "*portable*"}

# Download the portable version
  $downloadPath = "$env:TEMP\librewolf-portable.exe"
  Invoke-WebRequest -Uri $portableDownloadUrl.browser_download_url -OutFile $downloadPath

# Extract the portable version
  $extractPath = "$env:APPDATA\LibreWolfPortable"
  New-Item -ItemType Directory -Path $extractPath -Force
  $extractProcess = Start-Process -FilePath $downloadPath -ArgumentList "/S", "/D=$extractPath" -Wait -PassThru
  $extractProcess.WaitForExit()

# Clean up
  Remove-Item -Path $downloadPath

# Create a shortcut to the portable version
  $shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\LibreWolfPortable.lnk"
  $wshell = New-Object -ComObject WScript.Shell
  $shortcut = $wshell.CreateShortcut($shortcutPath)
  $shortcut.TargetPath = "$extractPath\LibreWolf.exe"
  $shortcut.Save()
