# Nvidia Tesla P40 for Gaming
Using a Tesla P40 for Gaming with an Intel iGPU as Display Output on Windows 11 22H2. [中文版本](https://github.com/toAlice/NvidiaTeslaP40forGaming/blob/main/README_CHS.md)

## Requirements
1) You will need an Intel iGPU (im using an Intel 13th gen CPU), and 
1) A mobo with display output and "Above 4G decoding" option provided.

## Steps
1) Enable "Above 4G decoding" in BIOS.
1) Download the latest (528.24 at this moment) Studio driver for Titan Xp or other Pascal Geforce GPUs from [Nvidia's official website](https://www.nvidia.com/download/index.aspx). It's recommended to perform a clean install. Reboot if required.
1) Run "regedit" and navigate to "HKEY_LOCAL_MACHINE\\SYSTEM\\". Then press "Ctrl + F" and find "Tesla P40". The path (in the text bar on the top) should be something like "Computer\\HKEY_LOCAL_MACHINE\\SYSTEM\\ControlSet001\\Control\\Class\\{4d36e968-e325-11ce-bfc1-08002be10318}\\0000". Only the last 4 digits may vary. Copy the those 4 digits. 
1) Create a file at "%APPDATA%\\Tesla Workaround\\logon.ps1" with the content [here](https://github.com/toAlice/NvidiaTeslaP40forGaming/blob/main/logon.ps1). You may want to modify the first several lines. Replace "0000" with the 4 digits you copied in the previous step.
1) Run "taskschd.msc". Right-click "Task Scheduler Library" on the left and create a new task (not a basic task).
1) Name the task whatever you like. Check "Run with highest privileges".
1) On the tab "Triggers", create a new trigger by clicking "New..." on the bottom. Use the "Begin the task" drop-down menu and select the "At log on" option. Click "OK".
1) On the tab "Actions", create a new trigger by clicking "New..." on the bottom. Fill "Program/script" with "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" (with or without quotation marks), and fill "Add arguments (optional)" with '-File "%APPDATA%\\Tesla Workaround\\logon.ps1"' (without apostrophes).
1) Click "OK", close Task Scheduler, and reboot or manually start the task.

## Known Issue(s)
Machine freezes when waking up from sleep (at least from state S3).
