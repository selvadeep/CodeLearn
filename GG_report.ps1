import-module activedirectory
$groups=Get-Content .\input.txt
$date=Get-date -format "yyyyMMdd"


$managerlist=@()


Foreach ($Group in $Groups)
{

$Arrayofmembers = Get-ADgroupmember -identity $Group | Get-ADObject -Properties samaccountname,displayname,Givenname,sn,manager,managermail | select Givenname,samaccountname,Displayname,sn,manager,managermail

foreach ($Member in $Arrayofmembers)
{

$g1=$g1+1
$user_sno=$g1
$user_name2 = $Group
$user_name=$member.samaccountName
$user_name3=$member.givenName
$user_name4=$member.Displayname
$user_name5=$member.sn
$user_name6=$member.manager
$user_name7=$member.managerEmail
$selected_user = New-Object psobject
$selected_user | Add-Member NoteProperty -Name "S.No" -Value  $user_sno
$selected_user | Add-Member NoteProperty -Name "Group" -Value  $user_name2
$selected_user | Add-Member NoteProperty -Name "Samaccountname" -Value  $user_name
$selected_user | Add-Member NoteProperty -Name "Givenname" -Value  $user_name3
$selected_user | Add-Member NoteProperty -Name "Lastname" -Value  $user_name5
$selected_user | Add-Member NoteProperty -Name "Displayname" -Value  $user_name4
$selected_user | Add-Member NoteProperty -Name "Manager Mail" -Value  $user_name7
$selected_user | Add-Member NoteProperty -Name "manager" -Value  $user_name6


$managerlist+=$selected_user
$Managerlist | Export-csv ".\ggmember$date.csv"

}

}
$user_sno
