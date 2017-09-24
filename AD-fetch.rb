import-module activedirectory
$groups=Get-Content .\input.txt
$date=Get-date -format "yyyyMMdd"
$managerlist=@()


Function addOne($intIN) 
{ 
$user = Get-ADUser -Identity $intIN -Properties mail
$user.mail
} 
Function addTwo($intIN2) 
{ 
$user = Get-ADUser -Identity $intIN2 -Properties GivenName 
$user.GivenName
} 

Function addThree($intIN2) 
{ 
$user = Get-ADUser -Identity $intIN2 -Properties sn
$user.sn
}

Foreach ($Group in $Groups)
{

$Arrayofmembers = Get-ADgroupmember -identity $Group | Get-ADObject -Properties samaccountname,displayname,Givenname,sn,manager| select Givenname,samaccountname,Displayname,sn,manager

foreach ($Member in $Arrayofmembers)
{

$g1=$g1+1
$user_sno=$g1
$user_name2 = $Group
$user_name=$member.samaccountName
$user_name3=$member.givenName
$user_name4=$member.Displayname
$user_name5=$member.sn
$user_name66=$member.manager
$user_name66=$user_name66-split 'CN='
$user_name67=$user_name66[1]
$user_name68=$user_name67-split ','
$user_name6=$user_name68[0]


$user_name7=addone -intIn $user_name6 

$user_name8=addone -intIn $user_name

$fst_name=addTwo -intIn2 $user_name6

$lst_name=addThree -intIn2 $user_name6

$user_name9 = $fst_name + " " + $lst_name

$selected_user = New-Object psobject


		$selected_user | Add-Member NoteProperty -Name "Name" -Value  $user_name

		$selected_user | Add-Member NoteProperty -Name "DisplayName" -Value  $user_name4

		$selected_user | Add-Member NoteProperty -Name "Mail" -Value  $user_name8

		$selected_user | Add-Member NoteProperty -Name "Manager Name" -Value  $user_name9

		$selected_user | Add-Member NoteProperty -Name "Manger Mail ID" -Value  $user_name7

$managerlist+=$selected_user
$Managerlist | Export-csv ".\test$date.csv"

}

}


$user_sno