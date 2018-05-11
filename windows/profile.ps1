﻿if (-Not(Get-Module -ListAvailable -Name posh-git)) {
    // Requires Powershell 5+
    PowerShellGet\Install-Module posh-git -Scope CurrentUser
}

Import-Module posh-git
Start-SshAgent -Quiet

function global:prompt {

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #                                                                              Rikard Ronnkvist / snowland.se
    # Multicolored prompt with marker for windows started as Admin and marker for providers outside filesystem
    # Examples
    #    C:\Windows\System32>
    #    [Admin] C:\Windows\System32>
    #    [Registry] HKLM:\SOFTWARE\Microsoft\Windows>
    #    [Admin] [Registry] HKLM:\SOFTWARE\Microsoft\Windows>
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
    # New nice WindowTitle
    $Host.UI.RawUI.WindowTitle = "PowerShell v" + (get-host).Version.Major + "." + (get-host).Version.Minor + " (" + $pwd.Provider.Name + ") " + $pwd.Path
 
    # Admin ?
    if( (
        New-Object Security.Principal.WindowsPrincipal (
            [Security.Principal.WindowsIdentity]::GetCurrent())
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        # Admin-mark in WindowTitle
        $Host.UI.RawUI.WindowTitle = "[Admin] " + $Host.UI.RawUI.WindowTitle
 
        # Admin-mark on prompt
        Write-Host "[" -nonewline -foregroundcolor DarkGray
        Write-Host "Admin" -nonewline -foregroundcolor Red
        Write-Host "] " -nonewline -foregroundcolor DarkGray
    }
 
    # Show providername if you are outside FileSystem
    if ($pwd.Provider.Name -ne "FileSystem") {
        Write-Host "[" -nonewline -foregroundcolor DarkGray
        Write-Host $pwd.Provider.Name -nonewline -foregroundcolor Gray
        Write-Host "] " -nonewline -foregroundcolor DarkGray
    }
 
    # Split path and write \ in a gray
    $pwd.Path.Split("\") | foreach {
        Write-Host $_ -nonewline -foregroundcolor Yellow
        Write-Host "\" -nonewline -foregroundcolor Gray
    }

    $realLASTEXITCODE = $LASTEXITCODE

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "`n> "
}

function ExplorerHere { explorer.exe . }
Set-Alias "o" ExplorerHere