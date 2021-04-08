#sobl@tec.dk 10:41 23-11-2020
#Author Oliver Black
PowerShell.exe -windowstyle hidden {

#Export objectclass=group  og (kolonner member,grouptype,name,whenchanged)
csvde -f $env:TEMP\group-1.csv -r "(objectclass=group)" -l member,grouptype,name,whenchanged


#But om p� r�kkef�lge af kolonner (grouptype, name, member,whenchanged)
(Import-CSV -Path $env:TEMP\group-1.csv ) | Select-Object -Property grouptype, name, member,whenchanged  | Export-CSV -Path $env:TEMP\group-2.csv


#S�g/erstat   GruppeNr til GruppeType
((Get-Content -path $env:TEMP\group-2.csv -Raw) -replace '-2147483640','Univesal' -replace '-2147483643','Local' -replace '-2147483644','Domain Local' -replace '-2147483646','Global' )     | Set-Content -Path $env:TEMP\group-3.csv


#Fjern CN= OU=   OSV.
((Get-Content -path $env:TEMP\group-3.csv -Raw) -replace ',(CN|OU)=([a-zA-Z,=]+)' -replace '(CN=)') | Set-Content -Path $env:TEMP\group-4.csv


#Fjern Grupper uden medlemmer
Import-Csv $env:TEMP\group-4.csv | Where-Object { $_.member  -Match "[a-zA-Z0-9]" } | Export-csv  -Path .\group-5.csv

#Export til txt
Import-Csv .\group-5.csv | out-file   .\group-5.txt


#Vis i Grid View
Import-Csv .\group-5.csv | Out-GridView -wait

}



 