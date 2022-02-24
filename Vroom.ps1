#This gets the path of the DTImport OU in AD
$OUDTImport = 'OU=DT Import,OU=CEI Users,DC=CEI,DC=EDU'
#This gets the Destination OU of where we're sending the users
$TargetOU = 'OU=Spring 2022,OU=Students,OU=CEI Users,DC=CEI,DC=EDU'
#This puts the users in the DTimport OU in a variable so we can loop through each student and change tags
$DTList = Get-ADUser -Filter * -SearchBase $OUDTImport

#This loops everything from the $DTList variable and then changes the description and company tags to the specified strings
foreach ($user in $DTList) {
    Set-ADUser $user -Description "Spring 2022" -Company "Student"
    Move-ADObject -Identity $user -TargetPath $TargetOU
}
