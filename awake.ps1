$wshell = New-Object -ComObject WScript.Shell
$logFile = "awake.log"
$lastSent = $false

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class IdleTime
{
    [StructLayout(LayoutKind.Sequential)]
    struct LASTINPUTINFO
    {
        public uint cbSize;
        public uint dwTime;
    }

    [DllImport("user32.dll")]
    static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    public static uint GetIdleTime()
    {
        LASTINPUTINFO lii = new LASTINPUTINFO();
        lii.cbSize = (uint)Marshal.SizeOf(lii);

        if (!GetLastInputInfo(ref lii))
        {
            throw new InvalidOperationException("GetLastInputInfo failed.");
        }

        return ((uint)Environment.TickCount - lii.dwTime) / 1000;
    }
}
"@

Add-Content -Path $logFile `
    -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Script started"

while ($true)
{
    try
    {
        $idleSeconds = [IdleTime]::GetIdleTime()

        if ($idleSeconds -ge 120)
        {
            if (-not $lastSent)
            {
                $wshell.SendKeys('{F15}')

                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

                Add-Content -Path $logFile `
                    -Value "$timestamp - F15 sent after $idleSeconds seconds idle"

                $lastSent = $true
            }
        }
        else
        {
            $lastSent = $false
        }
    }
    catch
    {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        Add-Content -Path $logFile `
            -Value "$timestamp - ERROR: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds 60
}