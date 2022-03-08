param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function DTImport_check {
    if ($Total_users.count -eq 0){
        Write-Host("There is no users inside DT Import, No reason to run the script") -BackgroundColor Red
        break
    }
    else{
        Write-Host("There is $($Total_users.count) account inside DT Import") -BackgroundColor Green -ForegroundColor Black
    }
    
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}
$OU = @(Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase "OU=Students,OU=CEI Users,DC=CEI,DC=EDU" | ForEach-Object {$_.name})
$OUDTImport = 'OU=DT Import,OU=CEI Users,DC=CEI,DC=EDU'
$Total_users = Get-ADUser -Filter * -SearchBase $OUDTImport | Measure-Object
$Lists_OU = Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase "OU=Students,OU=CEI Users,DC=CEI,DC=EDU" | Sort-Object -Property Name | Format-Table @{L='List of OU';E={$_.Name}}
$Lists_OU
DTImport_check

$OU_Exists = $false
while ($OU_Exists -eq $false) {
    $Academic_Year = Read-Host("Which OU do you want to send the accounts in? (Type one from the list)")
    if ($Academic_Year -in $OU) {
    $OU_Exists = $true
    continue
    }
    else{
        Write-Host("Not a valid choice") -BackgroundColor Red -ForegroundColor Black
    }
}

$TargetOU = "OU=$($Academic_Year),OU=Students,OU=CEI Users,DC=CEI,DC=EDU"
$DTList = Get-ADUser -Filter * -SearchBase $OUDTImport

#This loops everything from the $DTList variable and then changes the description and company tags to the specified strings
$counter = 0
Clear-Host
foreach ($user in $DTList) {
    $counter ++
    Set-ADUser $user -Description $Academic_Year -Company "Student"
    Move-ADObject -Identity $user -TargetPath $TargetOU
    Write-Host ("$($user.name) has been moved to $Academic_Year OU and student license has been set") -ForegroundColor Green
    Write-Host ("$counter AD account has been moved")
}
Pause