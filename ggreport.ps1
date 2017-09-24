import-module activedirectory
$groups=Get-Content .\input.txt
$date=Get-date -format "yyyyMMdd"


$managerlist=@()


Foreach ($Group in $Groups)
{

$Arrayofmembers = Get-ADgroupmember $Group | Get-ADUser -Properties name,displayname| select Givenname,samaccountname,Displayname

foreach ($Member in $Arrayofmembers)
{
$g1=$g1+1
$user_sno=$g1
$user_name2 = $Group
$user_name=$member.samaccountName
$user_name3=$member.givenName
$user_name4=$member.Displayname
$selected_user = New-Object psobject
$selected_user | Add-Member NoteProperty -Name "S.No" -Value  $user_sno
$selected_user | Add-Member NoteProperty -Name "Group" -Value  $user_name2
$selected_user | Add-Member NoteProperty -Name "Samaccountname" -Value  $user_name
$selected_user | Add-Member NoteProperty -Name "Givenname" -Value  $user_name3
$selected_user | Add-Member NoteProperty -Name "Displayname" -Value  $user_name4
$managerlist+=$selected_user
$Managerlist | Export-csv ".\ggmember$date.csv"


}

}

Write-Host "Total Member: " $user_sno