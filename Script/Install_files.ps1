param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}
$current_location = $PSScriptRoot
$program_location = $current_location + "\Programs"
$software_list = Get-ChildItem -Path $program_location
$counter = 0
foreach($software in $software_list){
    Write-Host("$software is installing....")
    Start-Process $software -ArgumentList "/passive" -Wait -WorkingDirectory $program_location
    $counter++
}
Set-ExecutionPolicy Restricted
Write-Host("Number of Software Installed: $counter")
Pause