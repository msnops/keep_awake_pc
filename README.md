# Awake PowerShell Script

## Overview

`awake.ps1` is a Windows PowerShell script that monitors keyboard and mouse inactivity.

When the computer has been idle for **120 seconds**, the script sends the **F15** key once using `WScript.Shell`.

The script:

- Checks the Windows idle time every **60 seconds**
- Sends `F15` after **120 seconds** of inactivity
- Sends the key only once during the same idle period
- Resets when keyboard or mouse activity is detected
- Writes activity and errors to `awake.log`
- Can run with a hidden PowerShell window

---

## Repository Structure

```text
awake/
├── awake.ps1
└── README.md
```

The log file is created when the script runs:

```text
awake/
├── awake.ps1
├── awake.log
└── README.md
```

---

## Prerequisites

The script requires:

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or compatible PowerShell
- Permission to execute local PowerShell scripts
- Access to `WScript.Shell`
- Access to Windows `user32.dll`

---

## Important: Update the Script Location

Every user should change the paths according to where they have downloaded or cloned the repository.

For example, if your script is located here:

```text
C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1
```

another user must replace `<YOUR_USER_ID>` and/or the folder location with their own path.

Example:

```text
C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1
```

---

## Configure the Log Location

Inside `awake.ps1`, locate:

```powershell
$logFile = "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.log"
```

Change this to your own location.

For example:

```powershell
$logFile = "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.log"
```

### Recommended Option

Instead of hard-coding the Windows username, you can use `$env:USERPROFILE`.

Replace:

```powershell
$logFile = "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.log"
```

with:

```powershell
$awakeFolder = Join-Path $env:USERPROFILE "OneDrive - FIS\Desktop\awake"
$logFile = Join-Path $awakeFolder "awake.log"
```

This automatically uses the currently logged-in user's profile.

> Note: If your OneDrive or Desktop is stored in another location, update the path accordingly.

---

## Run the Script

Open PowerShell and run:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\<YOUR_USER_ID>\OneDrive - FIS\Desktop\awake\awake.ps1"
```

For example:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\e5738591\OneDrive - FIS\Desktop\awake\awake.ps1"
```

Leave the keyboard and mouse idle for at least two minutes.

The script should send the `F15` key automatically.

---

## Run the Script in the Background

To run PowerShell with the window hidden:

```powershell
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1"
```

For example:

```powershell
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1"
```

### Important

Every user must change:

```text
C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1
```

to their actual script location.

---

## Verify That the Script Is Working

The script creates:

```text
awake.log
```

Example:

```text
2026-11-20 12:30:00 - Script started
2026-11-20 12:32:05 - F15 sent after 125 seconds idle
```

If an error occurs, it will also be written to the log:

```text
2026-11-20 12:35:00 - ERROR: <error message>
```

---

## How It Works

The script uses the Windows API:

```text
GetLastInputInfo
```

from:

```text
user32.dll
```

This determines how long the user has been inactive.

The basic logic is:

```text
            Script starts
                 |
                 v
        Check Windows idle time
                 |
                 v
        Idle for 120 seconds?
             /       \
           No         Yes
           |           |
           |           v
           |       Send F15
           |           |
           |       Write log
           |           |
           +-----< Wait 60 sec
```

The variable:

```powershell
$lastSent
```

prevents `F15` from being sent every 60 seconds while the computer continues to remain idle.

Once keyboard or mouse activity is detected:

```powershell
$lastSent = $false
```

The script can then send `F15` again during the next idle period.

---

## Change the Idle Time

The default idle threshold is:

```powershell
if ($idleSeconds -ge 120)
```

`120` means:

```text
120 seconds = 2 minutes
```

For example, to use **5 minutes**:

```powershell
if ($idleSeconds -ge 300)
```

To use **10 minutes**:

```powershell
if ($idleSeconds -ge 600)
```

---

## Change the Check Interval

The script currently checks the idle time every:

```powershell
Start-Sleep -Seconds 60
```

This means:

```text
60 seconds = 1 minute
```

For example, to check every 30 seconds:

```powershell
Start-Sleep -Seconds 30
```

---

## Start Automatically When You Log In

You can use Windows **Task Scheduler** to start the script automatically.

### 1. Open Task Scheduler

Press:

```text
Win + R
```

and run:

```text
taskschd.msc
```

### 2. Create a Task

Select:

```text
Create Task
```

Use a name such as:

```text
Awake PowerShell Script
```

You can select:

```text
Run only when user is logged on
```

### 3. Create the Trigger

Go to:

```text
Triggers
```

Create a new trigger:

```text
Begin the task: At log on
```

### 4. Create the Action

Go to:

```text
Actions
```

Create a new action.

**Program/script:**

```text
powershell.exe
```

**Add arguments:**

```text
-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1"
```

For example:

```text
-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1"
```

Save the task.

The script should now start automatically after the user logs into Windows.

---

## Check Whether the Script Is Running

Run:

```powershell
Get-Process powershell
```

You can also check Task Manager for:

```text
Windows PowerShell
```

---

## Stop the Script

If you are running it directly in PowerShell, press:

```text
Ctrl + C
```

If it is running in a hidden window, identify the correct PowerShell process using Task Manager.

You can also list PowerShell processes with:

```powershell
Get-Process powershell
```

If you started the script through Task Scheduler, you can stop the corresponding task from:

```text
Task Scheduler
```

---

## Troubleshooting

### Check that `awake.ps1` exists

```powershell
Test-Path "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1"
```

The expected result is:

```text
True
```

---

### Check that the directory exists

```powershell
Test-Path "C:\Users\<YOUR_USER_ID>\Desktop\awake"
```

If required, create it:

```powershell
New-Item `
    -ItemType Directory `
    -Path "C:\Users\<YOUR_USER_ID>\Desktop\awake" `
    -Force
```

---

### Test Without Hidden Mode

If the script does not appear to work, run it without `-WindowStyle Hidden`:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<YOUR_USER_ID>\Desktop\awake\awake.ps1"
```

You can then see any errors directly in the PowerShell window.

Also check:

```text
awake.log
```

for error messages.

---

## Security / Company Policy

`-ExecutionPolicy Bypass` applies to the PowerShell process used to launch the script.

On company-managed devices, PowerShell execution, Task Scheduler, `WScript.Shell`, or simulated keyboard input may be restricted by endpoint/security policies.

Make sure the script is used in accordance with your organization's security, endpoint-management, acceptable-use, attendance, and presence-status policies.
