$backupPfad = "C:\Users\vmadmin\programming\LB3_Luis_Gjokaj\TopBck\"
$sourcePfad = "C:\Users\vmadmin\programming\LB3_Luis_Gjokaj\TopSrc\*"
$logName = Get-Date -Format 'dd-MM-yyyy'
$logPfad =  "C:\Users\vmadmin\programming\LB3_Luis_Gjokaj\log\" + $logName + ".log"

Write-Host "Rufen Sie makeBackup um das Backup zu starten."

function makeBackup {
    $answer = Read-Host "Wollen Sie die Pfaede fuer Backup, source, und log aendern?(n/y) "

    if ($answer -eq "y") {
        $logpfad = Read-Host "Geben sie den gewuenschten namen fuer das Logfile an: "
        $backupPfad = Read-Host "Geben sie den gewuenschten namen fuer den Backuppfad an: "
        $sourcePfad = Read-Host "Geben sie den gewuenschten namen fuer den Sourcepfad an: "
    } elseif ($answer -ne "n") {
        Write-Host "Falsche Eingabe. Programm wird geschlossen."
    }
    try {
        Remove-Item -Recurse -Force -Exclude "TopBck" $backupPfad
        copy-item -Path $sourcePfad -Destination $backupPfad -Recurse  
    }
    catch {
        write-Host "Alle Files sind gleich."
    }
    get-childitem -path $backupPfad -Recurse | Select-Object name, LastWriteTime  | out-file -FilePath $logpfad
}
