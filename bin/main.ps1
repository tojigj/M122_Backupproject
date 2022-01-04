$backupPfad = "..\TopBck\"
$sourcePfad = "..\TopSrc\*"
$logName = Get-Date -Format 'dd-MM-yyyy HH-mm-ss'
$logPfad =  "..\log\" + $logName + ".log"

Write-Host "Rufen Sie makeBackup um das Backup zu starten."

function makeBackup {
    $answer = Read-Host "Wollen Sie die Pfaede fuer Backup, source, und log aendern?(n/y) "

    if ($answer -eq "y") {
        $logpfad = Read-Host "Geben sie den gewuenschten Pfad fuer das Logfile an: "
        $backupPfad = Read-Host "Geben sie den gewuenschten Pfad fuer das Backup an: "
        $sourcePfad = Read-Host "Geben sie den gewuenschten Pfad fuer die Source an: "
    } elseif ($answer -ne "n") {
        Write-Host "Falsche Eingabe. Programm wird geschlossen."
        exit
    }
    try {
        Remove-Item -Recurse -Force -Exclude "TopBck" $backupPfad -ErrorAction stop
        copy-item -Path $sourcePfad -Destination $backupPfad -Recurse -ErrorAction stop
    }
    catch {
        write-Host "Alle Files sind gleich."
    }
    get-childitem -path $sourcePfad -Recurse | Select-Object name | out-file -FilePath $logpfad
    if ((get-childitem -path $backupPfad -Recurse | Select-Object name) -eq (get-childitem -path $sourcePfad -Recurse | Select-Object name)) {
        write-host "Das Backup wurde erfolgreich durchgefuehrt"
    }
    else {
        write-host "Nicht alle Files konnten kopiert werden. Fuehren Sie das Skript bitte noch mals aus."
    }
}
